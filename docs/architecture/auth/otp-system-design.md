# OTP System Design for Admin/Operator Roles

## Overview
Mandatory Two-Factor Authentication (2FA) system for administrative roles with multi-channel OTP delivery including hardware wallet support.

## Architecture

### 1. OTP Configuration in Rodauth

```ruby
# app/misc/rodauth_admin.rb
class RodauthAdmin < Rodauth::Rails::Auth
  configure do
    # Enable OTP features
    enable :otp, :recovery_codes, :sms_codes, :webauthn
    
    # Base configuration
    prefix "/admin/auth"
    session_key_prefix "admin_"
    
    # Require OTP for admin accounts
    require_two_factor_setup? { account_admin? }
    require_two_factor_authenticated? { account_admin? }
    
    # OTP configuration
    otp_drift 30 # Allow 30 second drift
    otp_interval 30 # 30 second intervals
    otp_digits 6 # 6-digit codes
    
    # Recovery codes
    recovery_codes_limit 10
    
    # Custom OTP setup
    before_otp_setup do
      # Ensure admin role
      unless account_admin?
        flash[:error] = "OTP required only for admin accounts"
        redirect "/"
      end
    end
    
    # Override OTP delivery
    sms_send do |phone, message|
      channel = account[:otp_channel] || 'sms'
      Communication::ChannelDispatcher.send_otp(
        account, 
        channel.to_sym,
        message
      )
    end
    
    # WebAuthn for hardware keys
    webauthn_rp_name Rails.application.config.app_name
    webauthn_rp_id Rails.application.config.domain
    webauthn_origin "https://#{Rails.application.config.domain}"
    
    # Trezor integration
    auth_class_eval do
      def valid_trezor_authentication?(code)
        TrezorService.verify_signature(
          account_id: account_id,
          challenge: session[:trezor_challenge],
          signature: code
        )
      end
    end
  end
  
  # Custom route for Trezor setup
  route(:trezor_setup) do |r|
    require_authentication
    require_account_session
    
    r.get do
      @trezor_setup_data = TrezorService.generate_setup_data(account)
      view 'trezor_setup', 'Setup Trezor Authentication'
    end
    
    r.post do
      if TrezorService.verify_and_save_public_key(
        account: account,
        public_key: param('public_key'),
        signature: param('signature')
      )
        flash[:notice] = "Trezor authentication enabled"
        redirect otp_manage_path
      else
        flash[:error] = "Invalid Trezor signature"
        redirect
      end
    end
  end
end
```

### 2. OTP Service Layer

```ruby
# app/services/otp/otp_service.rb
module OTP
  class OTPService
    CHANNELS = %w[email sms whatsapp telegram trezor].freeze
    
    class << self
      def generate_and_send(account, channel = nil)
        channel ||= account.otp_channel || 'email'
        
        case channel.to_s
        when 'trezor'
          generate_trezor_challenge(account)
        else
          code = generate_totp(account)
          send_otp_code(account, code, channel)
        end
      end
      
      def verify(account, code, channel = nil)
        channel ||= account.otp_channel || 'email'
        
        case channel.to_s
        when 'trezor'
          verify_trezor(account, code)
        else
          verify_totp(account, code)
        end
      end
      
      private
      
      def generate_totp(account)
        secret = account.otp_secret || generate_otp_secret(account)
        totp = ROTP::TOTP.new(secret, issuer: Rails.application.config.app_name)
        totp.now
      end
      
      def generate_otp_secret(account)
        secret = ROTP::Base32.random
        account.update!(otp_secret: secret)
        secret
      end
      
      def send_otp_code(account, code, channel)
        Communication::ChannelDispatcher.send_otp(
          account,
          channel.to_sym,
          code
        )
      end
      
      def verify_totp(account, code)
        return false unless account.otp_secret.present?
        
        totp = ROTP::TOTP.new(
          account.otp_secret,
          issuer: Rails.application.config.app_name
        )
        
        # Allow for time drift
        totp.verify(code, drift_behind: 30, drift_ahead: 30)
      end
      
      def generate_trezor_challenge(account)
        challenge = SecureRandom.hex(32)
        
        Rails.cache.write(
          "trezor_challenge:#{account.id}",
          challenge,
          expires_in: 5.minutes
        )
        
        {
          challenge: challenge,
          message: "Sign this message to authenticate:\n#{challenge}",
          path: "m/44'/0'/0'/0/0" # Bitcoin path by default
        }
      end
      
      def verify_trezor(account, signature)
        challenge = Rails.cache.read("trezor_challenge:#{account.id}")
        return false unless challenge.present?
        
        result = TrezorService.verify_signature(
          account: account,
          challenge: challenge,
          signature: signature
        )
        
        Rails.cache.delete("trezor_challenge:#{account.id}") if result
        result
      end
    end
  end
end
```

### 3. Trezor Integration Service

```ruby
# app/services/otp/trezor_service.rb
module OTP
  class TrezorService
    class << self
      def generate_setup_data(account)
        {
          message: "Register Trezor for #{Rails.application.config.app_name}",
          path: derive_path(account),
          challenge: SecureRandom.hex(32)
        }
      end
      
      def verify_and_save_public_key(account:, public_key:, signature:)
        # Verify the signature matches the public key
        return false unless verify_setup_signature(
          public_key: public_key,
          signature: signature,
          message: generate_setup_data(account)[:message]
        )
        
        # Save the public key
        account.update!(
          trezor_public_key: public_key,
          trezor_path: derive_path(account),
          otp_channel: 'trezor'
        )
        
        true
      end
      
      def verify_signature(account:, challenge:, signature:)
        return false unless account.trezor_public_key.present?
        
        # Verify using the stored public key
        verify_message(
          public_key: account.trezor_public_key,
          message: challenge,
          signature: signature
        )
      end
      
      private
      
      def derive_path(account)
        # Use account ID to derive unique path
        # m/44'/0'/account_id'/0/0
        "m/44'/0'/#{account.id}'/0/0"
      end
      
      def verify_setup_signature(public_key:, signature:, message:)
        # Use Bitcoin message signing verification
        begin
          key = Bitcoin::Key.new(nil, public_key)
          key.verify_message(signature, message)
        rescue => e
          Rails.logger.error "Trezor signature verification failed: #{e.message}"
          false
        end
      end
      
      def verify_message(public_key:, message:, signature:)
        begin
          key = Bitcoin::Key.new(nil, public_key)
          key.verify_message(signature, message)
        rescue => e
          Rails.logger.error "Trezor message verification failed: #{e.message}"
          false
        end
      end
    end
  end
end
```

### 4. Admin Authentication Flow

```ruby
# app/controllers/admin/sessions_controller.rb
module Admin
  class SessionsController < ApplicationController
    layout 'authentication'
    
    def new
      @login_form = Admin::LoginForm.new
    end
    
    def create
      @login_form = Admin::LoginForm.new(login_params)
      
      if @login_form.valid?
        account = authenticate_admin(@login_form.email, @login_form.password)
        
        if account
          # First factor authenticated, now require OTP
          session[:pending_admin_id] = account.id
          redirect_to admin_otp_path
        else
          flash.now[:error] = "Invalid credentials"
          render :new
        end
      else
        render :new
      end
    end
    
    def otp
      @account = pending_admin_account
      redirect_to admin_login_path unless @account
      
      @otp_channels = available_otp_channels(@account)
      @selected_channel = params[:channel] || @account.otp_channel || 'email'
      
      # Send OTP if not already sent
      if request.post? && params[:send_otp]
        OTP::OTPService.generate_and_send(@account, @selected_channel)
        flash.now[:notice] = "OTP sent via #{@selected_channel}"
      end
      
      # Special handling for Trezor
      if @selected_channel == 'trezor'
        @trezor_challenge = OTP::OTPService.generate_and_send(@account, 'trezor')
      end
    end
    
    def verify_otp
      @account = pending_admin_account
      redirect_to admin_login_path unless @account
      
      if OTP::OTPService.verify(@account, params[:otp_code], params[:channel])
        # Clear pending admin
        session.delete(:pending_admin_id)
        
        # Complete login
        rodauth.account_from_id(@account.id)
        rodauth.login_session('Admin')
        
        # Mark OTP verification time
        session[:otp_verified_at] = Time.current
        
        redirect_to admin_dashboard_path, notice: "Successfully logged in"
      else
        flash[:error] = "Invalid OTP code"
        redirect_to admin_otp_path
      end
    end
    
    private
    
    def login_params
      params.require(:admin_login_form).permit(:email, :password)
    end
    
    def authenticate_admin(email, password)
      account = IAM::Account.find_by(email: email)
      return nil unless account&.admin?
      
      # Use Rodauth's password verification
      rodauth.account_from_id(account.id)
      rodauth.password_match?(password) ? account : nil
    end
    
    def pending_admin_account
      return nil unless session[:pending_admin_id]
      IAM::Account.find_by(id: session[:pending_admin_id])
    end
    
    def available_otp_channels(account)
      channels = ['email'] # Always available
      channels << 'sms' if account.phone_verified?
      channels << 'whatsapp' if account.whatsapp_verified?
      channels << 'telegram' if account.telegram_verified?
      channels << 'trezor' if account.trezor_public_key.present?
      channels
    end
  end
end
```

### 5. Admin Views

```erb
<!-- app/views/admin/sessions/otp.html.erb -->
<div class="max-w-md mx-auto mt-8">
  <h2 class="text-2xl font-bold mb-4">Two-Factor Authentication</h2>
  
  <% if @selected_channel != 'trezor' %>
    <!-- Regular OTP channels -->
    <%= form_with url: admin_otp_path, method: :post, local: true do |f| %>
      <div class="mb-4">
        <label class="block text-sm font-medium mb-2">Select Channel</label>
        <%= select_tag :channel, 
            options_for_select(@otp_channels.map { |c| [c.humanize, c] }, @selected_channel),
            class: "w-full px-3 py-2 border rounded",
            onchange: "this.form.submit();" %>
      </div>
      
      <%= hidden_field_tag :send_otp, true %>
      <%= f.submit "Send OTP", class: "btn btn-primary mb-4" %>
    <% end %>
    
    <%= form_with url: admin_verify_otp_path, method: :post, local: true do |f| %>
      <%= hidden_field_tag :channel, @selected_channel %>
      
      <div class="mb-4">
        <label class="block text-sm font-medium mb-2">Enter OTP Code</label>
        <%= text_field_tag :otp_code, nil,
            placeholder: "000000",
            maxlength: 6,
            class: "w-full px-3 py-2 border rounded text-center text-2xl tracking-widest",
            autocomplete: "off" %>
      </div>
      
      <%= f.submit "Verify", class: "btn btn-primary w-full" %>
    <% end %>
    
  <% else %>
    <!-- Trezor authentication -->
    <div class="trezor-auth">
      <p class="mb-4">Connect your Trezor device and sign the message.</p>
      
      <div class="bg-gray-100 p-4 rounded mb-4">
        <p class="text-sm font-mono break-all"><%= @trezor_challenge[:challenge] %></p>
      </div>
      
      <button id="trezor-sign" class="btn btn-primary w-full">
        Sign with Trezor
      </button>
      
      <%= form_with url: admin_verify_otp_path, method: :post, local: true, id: "trezor-form", class: "hidden" do |f| %>
        <%= hidden_field_tag :channel, 'trezor' %>
        <%= hidden_field_tag :otp_code, nil, id: 'trezor-signature' %>
      <% end %>
    </div>
    
    <script>
      document.getElementById('trezor-sign').addEventListener('click', async () => {
        try {
          const result = await TrezorConnect.signMessage({
            path: "<%= @account.trezor_path %>",
            message: "<%= @trezor_challenge[:challenge] %>"
          });
          
          if (result.success) {
            document.getElementById('trezor-signature').value = result.payload.signature;
            document.getElementById('trezor-form').submit();
          } else {
            alert('Trezor signing failed: ' + result.payload.error);
          }
        } catch (error) {
          alert('Trezor connection failed: ' + error.message);
        }
      });
    </script>
  <% end %>
</div>
```

### 6. Database Schema

```ruby
# db/migrate/add_otp_fields_to_accounts.rb
class AddOtpFieldsToAccounts < ActiveRecord::Migration[7.0]
  def change
    # OTP configuration
    add_column :iam_accounts, :otp_secret, :string
    add_column :iam_accounts, :otp_required, :boolean, default: false
    add_column :iam_accounts, :otp_channel, :string, default: 'email'
    
    # Trezor fields
    add_column :iam_accounts, :trezor_public_key, :string
    add_column :iam_accounts, :trezor_path, :string
    
    # Channel verification
    add_column :iam_accounts, :whatsapp_verified, :boolean, default: false
    add_column :iam_accounts, :telegram_verified, :boolean, default: false
    
    # Indexes
    add_index :iam_accounts, :otp_required
  end
end
```

### 7. Admin Role Check

```ruby
# app/models/iam/account.rb
module IAM
  class Account < ApplicationRecord
    def admin?
      user.roles.exists?(name: ['admin', 'operator'])
    end
    
    def require_otp?
      admin? || otp_required?
    end
    
    def available_otp_channels
      channels = ['email']
      channels << 'sms' if phone_verified?
      channels << 'whatsapp' if whatsapp_verified?
      channels << 'telegram' if telegram_verified?
      channels << 'trezor' if trezor_public_key.present?
      channels
    end
  end
end
```

## Security Considerations

1. **Session Security**: Clear OTP verification after timeout
2. **Rate Limiting**: Limit OTP attempts (5 per 15 minutes)
3. **Code Expiry**: OTP codes expire after 5 minutes
4. **Channel Verification**: Verify ownership of channels
5. **Audit Logging**: Log all OTP attempts
6. **Recovery Codes**: Provide backup codes for account recovery

## Testing

```ruby
# spec/services/otp/otp_service_spec.rb
RSpec.describe OTP::OTPService do
  let(:account) { create(:iam_account, :admin) }
  
  describe '.generate_and_send' do
    it 'generates and sends OTP via email' do
      expect(Communication::ChannelDispatcher).to receive(:send_otp)
        .with(account, :email, anything)
      
      described_class.generate_and_send(account, 'email')
    end
    
    it 'generates Trezor challenge' do
      result = described_class.generate_and_send(account, 'trezor')
      
      expect(result).to include(
        :challenge,
        :message,
        :path
      )
    end
  end
  
  describe '.verify' do
    it 'verifies valid TOTP code' do
      code = described_class.generate_and_send(account, 'email')
      
      expect(described_class.verify(account, code, 'email')).to be true
    end
  end
end
```