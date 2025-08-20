# Authentication & Authorization Architecture Design

## Overview

Comprehensive multi-channel authentication system supporting:
- NextJS frontend (Guest/Subscriber/Owner)
- Rails admin interface (Operator/Admin)
- Multiple authentication methods
- Role-based access control (RBAC)

## Architecture Components

### 1. User Models & Relationships

```ruby
# Identity layer (polymorphic, flexible)
IAM::User
  belongs_to :applicable, polymorphic: true
  has_many :accounts
  has_many :oauth_identities, through: :accounts
  has_one :profile # user metadata

# Authentication layer
IAM::Account
  belongs_to :user (IAM::User)
  has_many :oauth_identities
  has_many :magic_links
  has_many :otp_secrets
  has_one :active_session

# Business logic layer
Company::Business::User
  # Separate from IAM, handles business logic only
  has_many :owned_platforms
```

### 2. Authentication Methods

#### 2.1 Traditional Form (Email/Password)
- Via API for NextJS: `POST /api/v1/auth/login`
- Via Rails form for Admin: `/auth/login`

#### 2.2 Magic Links
```ruby
IAM::MagicLink
  belongs_to :account
  channel :string # email, whatsapp, telegram, sms
  token :string
  expires_at :datetime
  used_at :datetime
```

#### 2.3 OAuth Providers
```ruby
IAM::OAuthIdentity
  belongs_to :account
  provider :string # github, google, facebook, etc.
  uid :string
  auth_data :jsonb # encrypted
```

#### 2.4 OTP (for Admin/Operator)
```ruby
IAM::OTPSecret
  belongs_to :account
  secret :string # encrypted
  channel :string # email, whatsapp, telegram, sms, trezor
  verified_at :datetime
```

### 3. Role-Based Access Control

```ruby
IAM::Role
  name :string # guest, subscriber, owner, operator, admin
  permissions :jsonb

IAM::UserRole
  belongs_to :user
  belongs_to :role
  context_type :string # polymorphic context
  context_id :integer
```

### 4. API Authentication Strategy

#### 4.1 JWT Tokens for NextJS
```ruby
# app/controllers/api/v1/auth_controller.rb
class Api::V1::AuthController < Api::V1::BaseController
  # Login endpoint
  def login
    # Returns JWT token
  end
  
  # Magic link request
  def request_magic_link
    # Sends link via selected channel
  end
  
  # OAuth callback
  def oauth_callback
    # Handles OAuth flow
  end
end
```

#### 4.2 Session-based for Admin
- Uses Rodauth with additional OTP layer
- Requires 2FA for all admin operations

### 5. Multi-Channel Communication

```ruby
# app/services/communication/channel_dispatcher.rb
class Communication::ChannelDispatcher
  CHANNELS = {
    email: Communication::EmailChannel,
    whatsapp: Communication::WhatsAppChannel,
    telegram: Communication::TelegramChannel,
    sms: Communication::SMSChannel
  }
  
  def send_magic_link(account, channel)
    CHANNELS[channel].new(account).send_magic_link
  end
  
  def send_otp(account, channel)
    CHANNELS[channel].new(account).send_otp
  end
end
```

### 6. Security Features

#### 6.1 Rate Limiting
```ruby
# config/initializers/rack_attack.rb
Rack::Attack.throttle('auth/ip', limit: 5, period: 1.minute) do |req|
  req.ip if req.path.start_with?('/api/v1/auth')
end
```

#### 6.2 Token Security
- JWT with short expiration (15 min)
- Refresh tokens (30 days)
- Secure cookie storage for admin sessions

#### 6.3 CORS Configuration
```ruby
# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV['NEXTJS_URL']
    resource '/api/*', 
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options],
      credentials: true
  end
end
```

## Implementation Steps

### Phase 1: Fix Current Issues
1. Fix Vite build error (missing assets)
2. Correct IAM::Account association
3. Update OAuth callback to use IAM::User

### Phase 2: API Authentication
1. Implement JWT strategy
2. Create API auth controller
3. Add refresh token mechanism

### Phase 3: Multi-Channel Support
1. Implement channel dispatcher
2. Add WhatsApp/Telegram/SMS providers
3. Create magic link system

### Phase 4: Admin OTP
1. Add OTP to Rodauth config
2. Create OTP management UI
3. Implement Trezor integration

### Phase 5: Role Management
1. Create role/permission system
2. Add authorization layer
3. Implement context-aware permissions

## Database Migrations Needed

```ruby
# Magic links
create_table :iam_magic_links do |t|
  t.references :account, foreign_key: { to_table: :iam_accounts }
  t.string :token, null: false
  t.string :channel, null: false
  t.datetime :expires_at, null: false
  t.datetime :used_at
  t.timestamps
  t.index :token, unique: true
end

# OTP secrets
create_table :iam_otp_secrets do |t|
  t.references :account, foreign_key: { to_table: :iam_accounts }
  t.string :secret_encrypted, null: false
  t.string :channel, null: false
  t.datetime :verified_at
  t.timestamps
  t.index :account_id, unique: true
end

# Roles
create_table :iam_roles do |t|
  t.string :name, null: false
  t.jsonb :permissions, default: {}
  t.timestamps
  t.index :name, unique: true
end

# User roles
create_table :iam_user_roles do |t|
  t.references :user, foreign_key: { to_table: :iam_users }
  t.references :role, foreign_key: { to_table: :iam_roles }
  t.string :context_type
  t.integer :context_id
  t.timestamps
  t.index [:user_id, :role_id, :context_type, :context_id], 
    unique: true, name: 'index_user_roles_on_user_role_context'
end

# API tokens
create_table :iam_api_tokens do |t|
  t.references :account, foreign_key: { to_table: :iam_accounts }
  t.string :token_hash, null: false
  t.string :refresh_token_hash
  t.datetime :expires_at
  t.datetime :last_used_at
  t.timestamps
  t.index :token_hash, unique: true
  t.index :refresh_token_hash, unique: true
end
```

## Configuration Requirements

### Environment Variables
```bash
# OAuth Providers
GITHUB_CLIENT_ID=xxx
GITHUB_CLIENT_SECRET=xxx
GOOGLE_CLIENT_ID=xxx
GOOGLE_CLIENT_SECRET=xxx
# ... other providers

# Communication Channels
TWILIO_ACCOUNT_SID=xxx # SMS
TWILIO_AUTH_TOKEN=xxx
WHATSAPP_API_KEY=xxx
TELEGRAM_BOT_TOKEN=xxx

# JWT
JWT_SECRET_KEY=xxx
JWT_EXPIRATION=900 # 15 minutes
REFRESH_TOKEN_EXPIRATION=2592000 # 30 days

# NextJS
NEXTJS_URL=http://localhost:3000
API_BASE_URL=http://localhost:3000/api/v1
```

## Security Considerations

1. **Token Storage**: Use httpOnly cookies for web, secure storage for mobile
2. **CSRF Protection**: Enable for session-based auth, use CORS for API
3. **Rate Limiting**: Implement per-IP and per-account limits
4. **Audit Logging**: Track all authentication events
5. **Encryption**: Encrypt sensitive data (OAuth tokens, OTP secrets)

## Testing Strategy

1. **Unit Tests**: Test each authentication method
2. **Integration Tests**: Test full authentication flows
3. **Security Tests**: Test rate limiting, token expiration
4. **E2E Tests**: Test from NextJS frontend