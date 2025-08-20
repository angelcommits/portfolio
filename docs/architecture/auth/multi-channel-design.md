# Multi-Channel Authentication System Design

## Overview
Unified authentication system supporting multiple communication channels for magic links and OTP delivery.

## Channel Architecture

### 1. Base Channel Interface
```ruby
# app/services/communication/base_channel.rb
module Communication
  class BaseChannel
    attr_reader :account, :config

    def initialize(account, config = {})
      @account = account
      @config = default_config.merge(config)
    end

    def send_magic_link(magic_link)
      raise NotImplementedError
    end

    def send_otp(otp_code)
      raise NotImplementedError
    end

    def available?
      raise NotImplementedError
    end

    private

    def default_config
      {}
    end
  end
end
```

### 2. Email Channel (Default)
```ruby
# app/services/communication/email_channel.rb
module Communication
  class EmailChannel < BaseChannel
    def send_magic_link(magic_link)
      AuthMailer.magic_link(
        account: account,
        token: magic_link.token,
        expires_at: magic_link.expires_at
      ).deliver_later
    end

    def send_otp(otp_code)
      AuthMailer.otp_code(
        account: account,
        code: otp_code,
        expires_in: config[:otp_expiry]
      ).deliver_later
    end

    def available?
      account.email.present?
    end
  end
end
```

### 3. WhatsApp Channel
```ruby
# app/services/communication/whatsapp_channel.rb
module Communication
  class WhatsAppChannel < BaseChannel
    def send_magic_link(magic_link)
      WhatsAppClient.send_message(
        to: account.phone_number,
        template: 'magic_link',
        params: {
          link: magic_link_url(magic_link.token),
          expires_in: time_until_expiry(magic_link.expires_at)
        }
      )
    end

    def send_otp(otp_code)
      WhatsAppClient.send_message(
        to: account.phone_number,
        template: 'otp_code',
        params: {
          code: otp_code,
          app_name: Rails.application.config.app_name
        }
      )
    end

    def available?
      account.phone_number.present? && 
      WhatsAppClient.verified?(account.phone_number)
    end

    private

    def default_config
      {
        api_key: ENV['WHATSAPP_API_KEY'],
        business_id: ENV['WHATSAPP_BUSINESS_ID']
      }
    end
  end
end
```

### 4. Telegram Channel
```ruby
# app/services/communication/telegram_channel.rb
module Communication
  class TelegramChannel < BaseChannel
    def send_magic_link(magic_link)
      TelegramBot.send_message(
        chat_id: account.telegram_chat_id,
        text: format_magic_link_message(magic_link),
        parse_mode: 'Markdown'
      )
    end

    def send_otp(otp_code)
      TelegramBot.send_message(
        chat_id: account.telegram_chat_id,
        text: format_otp_message(otp_code),
        parse_mode: 'Markdown'
      )
    end

    def available?
      account.telegram_chat_id.present?
    end

    private

    def format_magic_link_message(magic_link)
      <<~MSG
        🔐 *Login to #{Rails.application.config.app_name}*
        
        Click the link below to login:
        #{magic_link_url(magic_link.token)}
        
        This link expires in #{time_until_expiry(magic_link.expires_at)}.
        
        If you didn't request this, please ignore this message.
      MSG
    end

    def format_otp_message(otp_code)
      <<~MSG
        🔐 *Verification Code*
        
        Your code is: `#{otp_code}`
        
        This code expires in #{config[:otp_expiry]} minutes.
        
        Do not share this code with anyone.
      MSG
    end
  end
end
```

### 5. SMS Channel
```ruby
# app/services/communication/sms_channel.rb
module Communication
  class SMSChannel < BaseChannel
    def send_magic_link(magic_link)
      TwilioClient.messages.create(
        to: account.phone_number,
        from: config[:from_number],
        body: sms_magic_link_body(magic_link)
      )
    end

    def send_otp(otp_code)
      TwilioClient.messages.create(
        to: account.phone_number,
        from: config[:from_number],
        body: "Your verification code is: #{otp_code}. Valid for #{config[:otp_expiry]} minutes."
      )
    end

    def available?
      account.phone_number.present? && 
      account.phone_verified?
    end

    private

    def sms_magic_link_body(magic_link)
      # SMS has character limits, use short URL
      short_url = UrlShortener.shorten(magic_link_url(magic_link.token))
      "Login to #{Rails.application.config.app_name}: #{short_url} (expires in #{config[:magic_link_expiry]} min)"
    end

    def default_config
      {
        from_number: ENV['TWILIO_PHONE_NUMBER'],
        otp_expiry: 5,
        magic_link_expiry: 15
      }
    end
  end
end
```

## Channel Dispatcher Service

```ruby
# app/services/communication/channel_dispatcher.rb
module Communication
  class ChannelDispatcher
    CHANNELS = {
      email: EmailChannel,
      whatsapp: WhatsAppChannel,
      telegram: TelegramChannel,
      sms: SMSChannel
    }.freeze

    class << self
      def send_magic_link(account, channel_name = nil)
        channel = get_channel(account, channel_name)
        magic_link = create_magic_link(account, channel_name)
        
        channel.send_magic_link(magic_link)
        magic_link
      rescue => e
        Rails.logger.error "Failed to send magic link via #{channel_name}: #{e.message}"
        fallback_to_email(account, :magic_link, magic_link)
      end

      def send_otp(account, channel_name = nil)
        channel = get_channel(account, channel_name)
        otp_code = generate_otp(account)
        
        channel.send_otp(otp_code)
        otp_code
      rescue => e
        Rails.logger.error "Failed to send OTP via #{channel_name}: #{e.message}"
        fallback_to_email(account, :otp, otp_code)
      end

      private

      def get_channel(account, channel_name)
        channel_name ||= account.preferred_channel || :email
        channel_class = CHANNELS[channel_name.to_sym]
        
        raise "Unknown channel: #{channel_name}" unless channel_class
        
        channel = channel_class.new(account)
        raise "Channel not available: #{channel_name}" unless channel.available?
        
        channel
      end

      def create_magic_link(account, channel)
        IAM::MagicLink.create!(
          account: account,
          token: SecureRandom.urlsafe_base64(32),
          channel: channel.to_s,
          expires_at: 15.minutes.from_now
        )
      end

      def generate_otp(account)
        otp = format('%06d', SecureRandom.random_number(1_000_000))
        
        # Store OTP with expiration
        Rails.cache.write(
          "otp:#{account.id}",
          otp,
          expires_in: 5.minutes
        )
        
        otp
      end

      def fallback_to_email(account, type, data)
        return unless account.email.present?
        
        email_channel = EmailChannel.new(account)
        case type
        when :magic_link
          email_channel.send_magic_link(data)
        when :otp
          email_channel.send_otp(data)
        end
      end
    end
  end
end
```

## Integration with Rodauth

### 1. Extend Rodauth Configuration
```ruby
# app/misc/rodauth_main.rb
class RodauthMain < Rodauth::Rails::Auth
  configure do
    # Enable magic link authentication
    enable :email_auth  # Rodauth's magic link feature
    
    # Custom magic link handler
    email_auth_email_sent_redirect do
      "/auth/magic-link-sent?channel=#{param(:channel)}"
    end
    
    # Override email sending to use our dispatcher
    email_auth_email do |email_type, account|
      channel = param(:channel) || 'email'
      Communication::ChannelDispatcher.send_magic_link(
        account, 
        channel.to_sym
      )
      nil # Prevent Rodauth from sending its own email
    end
  end
end
```

### 2. API Endpoints for NextJS
```ruby
# app/controllers/api/v1/auth_controller.rb
module Api
  module V1
    class AuthController < BaseController
      # Request magic link
      def magic_link
        account = find_or_create_account(params[:email])
        channel = params[:channel] || 'email'
        
        magic_link = Communication::ChannelDispatcher.send_magic_link(
          account, 
          channel.to_sym
        )
        
        render json: {
          message: "Magic link sent via #{channel}",
          expires_at: magic_link.expires_at
        }
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
      
      # Verify magic link
      def verify_magic_link
        magic_link = IAM::MagicLink.valid.find_by(token: params[:token])
        
        if magic_link && !magic_link.used?
          magic_link.use!
          jwt_token = generate_jwt(magic_link.account)
          
          render json: {
            token: jwt_token,
            user: UserSerializer.new(magic_link.account.user)
          }
        else
          render json: { error: 'Invalid or expired link' }, status: :unauthorized
        end
      end
      
      # Request OTP (for admin/operator)
      def request_otp
        account = current_account
        channel = params[:channel] || 'email'
        
        Communication::ChannelDispatcher.send_otp(account, channel.to_sym)
        
        render json: { 
          message: "OTP sent via #{channel}",
          expires_in: 300 # 5 minutes
        }
      end
      
      # Verify OTP
      def verify_otp
        otp = Rails.cache.read("otp:#{current_account.id}")
        
        if otp == params[:code]
          Rails.cache.delete("otp:#{current_account.id}")
          
          # Mark session as OTP verified
          session[:otp_verified_at] = Time.current
          
          render json: { message: 'OTP verified successfully' }
        else
          render json: { error: 'Invalid OTP' }, status: :unauthorized
        end
      end
    end
  end
end
```

## Channel Setup Endpoints

```ruby
# app/controllers/api/v1/account/channels_controller.rb
module Api
  module V1
    module Account
      class ChannelsController < BaseController
        before_action :authenticate!
        
        # Setup WhatsApp
        def setup_whatsapp
          phone = PhoneValidator.normalize(params[:phone_number])
          
          # Send verification code via WhatsApp
          verification = WhatsAppVerification.create!(
            account: current_account,
            phone_number: phone
          )
          
          render json: { 
            message: 'Verification code sent',
            verification_id: verification.id 
          }
        end
        
        # Setup Telegram
        def setup_telegram
          # Generate unique setup link
          setup_token = SecureRandom.urlsafe_base64(16)
          
          Rails.cache.write(
            "telegram_setup:#{setup_token}",
            current_account.id,
            expires_in: 1.hour
          )
          
          render json: {
            setup_url: "https://t.me/#{ENV['TELEGRAM_BOT_USERNAME']}?start=#{setup_token}",
            expires_in: 3600
          }
        end
        
        # Verify channel setup
        def verify_channel
          case params[:channel]
          when 'whatsapp'
            verify_whatsapp
          when 'telegram'
            # Handled by webhook from Telegram bot
            render json: { message: 'Check Telegram for confirmation' }
          when 'sms'
            verify_sms
          else
            render json: { error: 'Unknown channel' }, status: :bad_request
          end
        end
        
        private
        
        def verify_whatsapp
          verification = WhatsAppVerification.find(params[:verification_id])
          
          if verification.verify!(params[:code])
            current_account.update!(
              phone_number: verification.phone_number,
              phone_verified_at: Time.current
            )
            
            render json: { message: 'WhatsApp verified successfully' }
          else
            render json: { error: 'Invalid verification code' }, status: :unauthorized
          end
        end
        
        def verify_sms
          # Similar to WhatsApp verification
        end
      end
    end
  end
end
```

## Database Schema

```ruby
# db/migrate/add_channel_fields_to_accounts.rb
class AddChannelFieldsToAccounts < ActiveRecord::Migration[7.0]
  def change
    add_column :iam_accounts, :phone_number, :string
    add_column :iam_accounts, :phone_verified_at, :datetime
    add_column :iam_accounts, :telegram_chat_id, :string
    add_column :iam_accounts, :telegram_username, :string
    add_column :iam_accounts, :preferred_channel, :string, default: 'email'
    
    add_index :iam_accounts, :phone_number
    add_index :iam_accounts, :telegram_chat_id, unique: true
  end
end
```

## Configuration

```yaml
# config/communication.yml
default: &default
  magic_link:
    expiry_minutes: 15
    max_attempts: 3
  otp:
    expiry_minutes: 5
    length: 6
  channels:
    email:
      enabled: true
    whatsapp:
      enabled: <%= ENV['WHATSAPP_API_KEY'].present? %>
      templates:
        magic_link: 'auth_magic_link_v1'
        otp: 'auth_otp_v1'
    telegram:
      enabled: <%= ENV['TELEGRAM_BOT_TOKEN'].present? %>
    sms:
      enabled: <%= ENV['TWILIO_ACCOUNT_SID'].present? %>
      
development:
  <<: *default
  
production:
  <<: *default
  magic_link:
    expiry_minutes: 10
  otp:
    expiry_minutes: 3
```

## Security Considerations

1. **Rate Limiting**: Limit requests per account/IP
2. **Token Security**: Use cryptographically secure tokens
3. **Channel Verification**: Verify ownership before enabling
4. **Fallback Strategy**: Always fallback to email if available
5. **Audit Logging**: Log all authentication attempts
6. **Encryption**: Encrypt sensitive channel data (phone numbers)