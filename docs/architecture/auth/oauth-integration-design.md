# OAuth Integration Design

## Overview
Comprehensive OAuth 2.0 integration supporting multiple providers with unified authentication flow.

## Supported Providers

1. **GitHub** - Developer authentication
2. **Google** - General purpose
3. **Facebook** - Social login
4. **Twitter/X** - Social login
5. **LinkedIn** - Professional network
6. **Apple** - iOS/macOS users
7. **Microsoft** - Enterprise users

## Architecture

### 1. OmniAuth Configuration

```ruby
# config/initializers/omniauth.rb
Rails.application.config.middleware.use OmniAuth::Builder do
  # GitHub
  provider :github, 
    ENV['GITHUB_CLIENT_ID'], 
    ENV['GITHUB_CLIENT_SECRET'],
    scope: 'user:email'
  
  # Google
  provider :google_oauth2,
    ENV['GOOGLE_CLIENT_ID'],
    ENV['GOOGLE_CLIENT_SECRET'],
    {
      scope: 'email,profile',
      prompt: 'select_account',
      image_aspect_ratio: 'square',
      image_size: 200
    }
  
  # Facebook
  provider :facebook,
    ENV['FACEBOOK_APP_ID'],
    ENV['FACEBOOK_APP_SECRET'],
    scope: 'email,public_profile',
    info_fields: 'email,name,picture'
  
  # Twitter/X
  provider :twitter2,
    ENV['TWITTER_CLIENT_ID'],
    ENV['TWITTER_CLIENT_SECRET'],
    scope: 'users.read tweet.read'
  
  # LinkedIn
  provider :linkedin_oauth2,
    ENV['LINKEDIN_CLIENT_ID'],
    ENV['LINKEDIN_CLIENT_SECRET'],
    scope: 'r_emailaddress r_liteprofile'
  
  # Apple
  provider :apple,
    ENV['APPLE_CLIENT_ID'],
    ENV['APPLE_TEAM_ID'],
    ENV['APPLE_KEY_ID'],
    ENV['APPLE_PEM'],
    scope: 'email name'
  
  # Microsoft
  provider :microsoft_graph,
    ENV['MICROSOFT_CLIENT_ID'],
    ENV['MICROSOFT_CLIENT_SECRET'],
    scope: 'openid email profile'
end

# Handle failures
OmniAuth.config.on_failure = Proc.new do |env|
  RodauthController.action(:omniauth_failure).call(env)
end

# Security settings
OmniAuth.config.allowed_request_methods = [:post, :get]
OmniAuth.config.silence_get_warning = true
```

### 2. OAuth Service Layer

```ruby
# app/services/oauth/provider_service.rb
module OAuth
  class ProviderService
    PROVIDER_CONFIGS = {
      github: {
        name: 'GitHub',
        icon: 'github',
        color: '#24292e',
        scope_mappings: {
          email: 'user:email',
          profile: 'read:user'
        }
      },
      google_oauth2: {
        name: 'Google',
        icon: 'google',
        color: '#4285f4',
        scope_mappings: {
          email: 'email',
          profile: 'profile'
        }
      },
      facebook: {
        name: 'Facebook',
        icon: 'facebook',
        color: '#1877f2',
        scope_mappings: {
          email: 'email',
          profile: 'public_profile'
        }
      },
      twitter2: {
        name: 'Twitter/X',
        icon: 'twitter',
        color: '#1da1f2',
        scope_mappings: {
          email: 'users.read',
          profile: 'users.read'
        }
      },
      linkedin_oauth2: {
        name: 'LinkedIn',
        icon: 'linkedin',
        color: '#0077b5',
        scope_mappings: {
          email: 'r_emailaddress',
          profile: 'r_liteprofile'
        }
      },
      apple: {
        name: 'Apple',
        icon: 'apple',
        color: '#000000',
        scope_mappings: {
          email: 'email',
          profile: 'name'
        }
      },
      microsoft_graph: {
        name: 'Microsoft',
        icon: 'microsoft',
        color: '#0078d4',
        scope_mappings: {
          email: 'email',
          profile: 'profile'
        }
      }
    }.freeze

    class << self
      def available_providers
        PROVIDER_CONFIGS.keys.select { |provider| provider_enabled?(provider) }
      end

      def provider_config(provider)
        PROVIDER_CONFIGS[provider.to_sym]
      end

      def provider_enabled?(provider)
        case provider.to_sym
        when :github
          ENV['GITHUB_CLIENT_ID'].present?
        when :google_oauth2
          ENV['GOOGLE_CLIENT_ID'].present?
        when :facebook
          ENV['FACEBOOK_APP_ID'].present?
        when :twitter2
          ENV['TWITTER_CLIENT_ID'].present?
        when :linkedin_oauth2
          ENV['LINKEDIN_CLIENT_ID'].present?
        when :apple
          ENV['APPLE_CLIENT_ID'].present?
        when :microsoft_graph
          ENV['MICROSOFT_CLIENT_ID'].present?
        else
          false
        end
      end

      def normalize_auth_hash(auth_hash)
        {
          provider: auth_hash.provider,
          uid: auth_hash.uid,
          email: extract_email(auth_hash),
          name: extract_name(auth_hash),
          image_url: extract_image(auth_hash),
          raw_info: auth_hash.to_h
        }
      end

      private

      def extract_email(auth_hash)
        auth_hash.info.email || 
        auth_hash.extra&.raw_info&.email ||
        extract_verified_email(auth_hash)
      end

      def extract_verified_email(auth_hash)
        case auth_hash.provider
        when 'github'
          # GitHub may not provide email in info, need to fetch from emails endpoint
          auth_hash.extra&.all_emails&.find { |e| e['verified'] && e['primary'] }&.dig('email')
        when 'facebook'
          auth_hash.info.email if auth_hash.extra&.raw_info&.verified
        else
          auth_hash.info.email
        end
      end

      def extract_name(auth_hash)
        auth_hash.info.name || 
        "#{auth_hash.info.first_name} #{auth_hash.info.last_name}".strip ||
        auth_hash.info.nickname
      end

      def extract_image(auth_hash)
        case auth_hash.provider
        when 'google_oauth2'
          # Get larger image from Google
          auth_hash.info.image&.gsub('s96-c', 's400-c')
        when 'facebook'
          # Get larger image from Facebook
          "https://graph.facebook.com/#{auth_hash.uid}/picture?type=large"
        else
          auth_hash.info.image
        end
      end
    end
  end
end
```

### 3. OAuth Identity Management

```ruby
# app/services/oauth/identity_service.rb
module OAuth
  class IdentityService
    class << self
      def find_or_create_from_auth(auth_hash)
        normalized = ProviderService.normalize_auth_hash(auth_hash)
        
        ActiveRecord::Base.transaction do
          # Find existing identity
          identity = IAM::OAuthIdentity.find_by(
            provider: normalized[:provider],
            uid: normalized[:uid]
          )
          
          if identity
            # Update identity info
            identity.update!(
              email: normalized[:email],
              name: normalized[:name],
              image_url: normalized[:image_url],
              auth_data: normalized[:raw_info]
            )
          else
            # Create new identity
            identity = create_new_identity(normalized)
          end
          
          identity
        end
      end

      private

      def create_new_identity(auth_data)
        # Try to find existing account by email
        account = find_or_create_account(auth_data[:email], auth_data[:name])
        
        # Create OAuth identity
        IAM::OAuthIdentity.create!(
          account: account,
          provider: auth_data[:provider],
          uid: auth_data[:uid],
          email: auth_data[:email],
          name: auth_data[:name],
          image_url: auth_data[:image_url],
          auth_data: auth_data[:raw_info]
        )
      end

      def find_or_create_account(email, name)
        return nil unless email.present?
        
        # Find existing account
        account = IAM::Account.find_by(email: email)
        return account if account
        
        # Create new user and account
        ActiveRecord::Base.transaction do
          # Find or create application context
          application = Site::Application.first || Site::Application.create!(
            name: 'default',
            code: 'APP1',
            email: 'admin@example.com'
          )
          
          # Create IAM::User (not Company::Business::User)
          user = IAM::User.create!(
            applicable: application,
            email: email,
            name: name || 'OAuth User'
          )
          
          # Create account
          IAM::Account.create!(
            user: user,
            email: email,
            password: SecureRandom.hex(32), # Random password for OAuth users
            status: :verified # OAuth users are pre-verified
          )
        end
      end
    end
  end
end
```

### 4. API OAuth Flow for NextJS

```ruby
# app/controllers/api/v1/oauth_controller.rb
module Api
  module V1
    class OAuthController < BaseController
      skip_before_action :authenticate!, only: [:providers, :callback, :failure]
      
      # GET /api/v1/oauth/providers
      def providers
        providers = OAuth::ProviderService.available_providers.map do |provider|
          config = OAuth::ProviderService.provider_config(provider)
          {
            id: provider,
            name: config[:name],
            icon: config[:icon],
            color: config[:color],
            auth_url: "/auth/#{provider}"
          }
        end
        
        render json: { providers: providers }
      end
      
      # GET /auth/:provider/callback
      def callback
        auth_hash = request.env['omniauth.auth']
        identity = OAuth::IdentityService.find_or_create_from_auth(auth_hash)
        
        # Generate JWT token
        jwt_token = JwtService.encode(
          account_id: identity.account.id,
          user_id: identity.account.user.id
        )
        
        # Redirect to NextJS with token
        redirect_to "#{ENV['NEXTJS_URL']}/auth/callback?token=#{jwt_token}&provider=#{auth_hash.provider}",
                    allow_other_host: true
      rescue => e
        Rails.logger.error "OAuth callback error: #{e.message}"
        redirect_to "#{ENV['NEXTJS_URL']}/auth/error?message=#{CGI.escape(e.message)}",
                    allow_other_host: true
      end
      
      # GET /auth/failure
      def failure
        message = params[:message] || 'Authentication failed'
        redirect_to "#{ENV['NEXTJS_URL']}/auth/error?message=#{CGI.escape(message)}",
                    allow_other_host: true
      end
      
      # POST /api/v1/oauth/unlink
      def unlink
        identity = current_user.oauth_identities.find_by(provider: params[:provider])
        
        if identity && current_user.oauth_identities.count > 1
          identity.destroy
          render json: { message: "#{params[:provider]} unlinked successfully" }
        else
          render json: { error: 'Cannot unlink last authentication method' }, 
                 status: :unprocessable_entity
        end
      end
      
      # GET /api/v1/oauth/connections
      def connections
        connections = current_user.oauth_identities.map do |identity|
          {
            provider: identity.provider,
            name: OAuth::ProviderService.provider_config(identity.provider)[:name],
            email: identity.email,
            connected_at: identity.created_at
          }
        end
        
        render json: { connections: connections }
      end
    end
  end
end
```

### 5. Routes Configuration

```ruby
# config/routes.rb
Rails.application.routes.draw do
  # OmniAuth routes
  get '/auth/:provider/callback', to: 'api/v1/oauth#callback'
  get '/auth/failure', to: 'api/v1/oauth#failure'
  
  namespace :api do
    namespace :v1 do
      # OAuth endpoints
      get 'oauth/providers', to: 'oauth#providers'
      post 'oauth/unlink', to: 'oauth#unlink'
      get 'oauth/connections', to: 'oauth#connections'
    end
  end
end
```

### 6. NextJS Integration

```typescript
// Frontend OAuth service (NextJS)
// services/auth/oauth.service.ts

interface OAuthProvider {
  id: string;
  name: string;
  icon: string;
  color: string;
  auth_url: string;
}

class OAuthService {
  private readonly API_URL = process.env.NEXT_PUBLIC_API_URL;

  async getProviders(): Promise<OAuthProvider[]> {
    const response = await fetch(`${this.API_URL}/oauth/providers`);
    const data = await response.json();
    return data.providers;
  }

  async login(provider: string): Promise<void> {
    // Open OAuth flow in popup or redirect
    const width = 500;
    const height = 600;
    const left = window.screenX + (window.outerWidth - width) / 2;
    const top = window.screenY + (window.outerHeight - height) / 2;
    
    const popup = window.open(
      `${this.API_URL.replace('/api/v1', '')}/auth/${provider}`,
      'oauth',
      `width=${width},height=${height},left=${left},top=${top}`
    );
    
    // Listen for callback
    window.addEventListener('message', (event) => {
      if (event.origin !== window.location.origin) return;
      
      if (event.data.type === 'oauth_callback') {
        popup?.close();
        this.handleCallback(event.data.token, event.data.provider);
      }
    });
  }

  private handleCallback(token: string, provider: string): void {
    // Store token
    localStorage.setItem('auth_token', token);
    
    // Redirect to dashboard or home
    window.location.href = '/dashboard';
  }

  async unlinkProvider(provider: string): Promise<void> {
    const response = await fetch(`${this.API_URL}/oauth/unlink`, {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('auth_token')}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ provider })
    });
    
    if (!response.ok) {
      throw new Error('Failed to unlink provider');
    }
  }

  async getConnections(): Promise<any[]> {
    const response = await fetch(`${this.API_URL}/oauth/connections`, {
      headers: {
        'Authorization': `Bearer ${localStorage.getItem('auth_token')}`
      }
    });
    
    const data = await response.json();
    return data.connections;
  }
}

export default new OAuthService();
```

### 7. OAuth Callback Page (NextJS)

```tsx
// pages/auth/callback.tsx
import { useEffect } from 'react';
import { useRouter } from 'next/router';

export default function OAuthCallback() {
  const router = useRouter();
  
  useEffect(() => {
    const { token, provider, error } = router.query;
    
    if (error) {
      // Handle error
      router.push(`/login?error=${error}`);
      return;
    }
    
    if (token && provider) {
      // Store token
      localStorage.setItem('auth_token', token as string);
      
      // Notify parent window if in popup
      if (window.opener) {
        window.opener.postMessage({
          type: 'oauth_callback',
          token,
          provider
        }, window.location.origin);
        window.close();
      } else {
        // Redirect to dashboard
        router.push('/dashboard');
      }
    }
  }, [router.query]);
  
  return (
    <div className="flex items-center justify-center min-h-screen">
      <div className="text-center">
        <h2>Completing authentication...</h2>
        <div className="spinner" />
      </div>
    </div>
  );
}
```

## Security Considerations

1. **State Parameter**: Use state parameter to prevent CSRF
2. **Nonce Validation**: Validate nonce for OpenID Connect providers
3. **Scope Limitations**: Request minimal required scopes
4. **Token Storage**: Store tokens securely (encrypted)
5. **Provider Verification**: Verify provider responses
6. **Rate Limiting**: Limit OAuth attempts per IP/account

## Testing

```ruby
# spec/services/oauth/provider_service_spec.rb
RSpec.describe OAuth::ProviderService do
  describe '.normalize_auth_hash' do
    let(:auth_hash) do
      OmniAuth::AuthHash.new({
        provider: 'github',
        uid: '123456',
        info: {
          email: 'user@example.com',
          name: 'Test User',
          image: 'https://github.com/avatar.jpg'
        }
      })
    end
    
    it 'normalizes auth hash correctly' do
      result = described_class.normalize_auth_hash(auth_hash)
      
      expect(result).to include(
        provider: 'github',
        uid: '123456',
        email: 'user@example.com',
        name: 'Test User'
      )
    end
  end
end
```