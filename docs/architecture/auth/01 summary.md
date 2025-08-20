# 🔐 Authentication System - Complete Architecture Summary

## 📊 System Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        CLIENTS                                  │
├─────────────────────┬───────────────────────────────────────────┤
│   NextJS Frontend   │        Rails Admin Interface              │
│  (Guest/Subscriber) │       (Operator/Admin)                    │
└──────────┬──────────┴──────────────┬────────────────────────────┘
           │                         │
           │ JWT API                 │ Session + OTP
           │                         │
┌──────────▼─────────────────────────▼────────────────────────────┐
│                     RAILS BACKEND                               │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────┐          │
│  │   Rodauth   │  │     API      │  │  Multi-Channel │          │
│  │   Engine    │  │  Controller  │  │   Dispatcher   │          │
│  └──────┬──────┘  └──────┬───────┘  └───────┬────────┘          │
│         │                │                  │                   │
│  ┌──────▼────────────────▼──────────────────▼─────────┐         │
│  │              AUTHENTICATION LAYER                  │         │
│  ├────────────────────────────────────────────────────┤         │
│  │  • IAM::User (Identity)                            │         │
│  │  • IAM::Account (Credentials)                      │         │
│  │  • IAM::OAuthIdentity (Social)                     │         │
│  │  • IAM::MagicLink (Passwordless)                   │         │
│  │  • IAM::OTPSecret (2FA)                            │         │
│  └────────────────────────────────────────────────────┘         │
└─────────────────────────────────────────────────────────────────┘
```

## 🎯 Authentication Methods

### 1. Traditional (Email/Password)
- **NextJS**: `POST /api/v1/auth/login` → JWT Token
- **Admin**: `/admin/auth/login` → Session + OTP

### 2. Magic Links
- **Channels**: Email, WhatsApp, Telegram, SMS
- **Flow**: Request → Send Link → Verify → JWT/Session

### 3. OAuth Providers
- **Supported**: GitHub, Google, Facebook, Twitter, LinkedIn, Apple, Microsoft
- **Flow**: Redirect → Provider → Callback → JWT/Session

### 4. OTP (Admin Only)
- **Channels**: Email, SMS, WhatsApp, Telegram, Trezor
- **Mandatory**: All admin/operator roles

## 🏗️ Key Components

### Models Structure
```ruby
IAM::User (polymorphic)
  → belongs_to :applicable (Site::Application, etc.)
  → has_many :accounts
  
IAM::Account (Rodauth)
  → belongs_to :user (IAM::User)
  → has_many :oauth_identities
  → has_many :magic_links
  → has_one :otp_secret
  
Company::Business::User
  → Business logic only (no auth)
```

### API Authentication (NextJS)
```typescript
// Login
POST /api/v1/auth/login
{ email, password } → { token, user }

// Magic Link
POST /api/v1/auth/magic-link
{ email, channel } → { message, expires_at }

// OAuth
GET /api/v1/oauth/providers → [providers]
GET /auth/:provider → Redirect to provider
```

### Admin Authentication Flow
```
1. Email/Password → /admin/auth/login
2. OTP Required → /admin/auth/otp
3. Select Channel → Send OTP
4. Verify OTP → Access Granted
```

## 🚀 Implementation Checklist

### ✅ Completed Design
- [x] Fixed IAM associations bug
- [x] API JWT strategy design
- [x] Multi-channel communication design
- [x] OAuth multi-provider design
- [x] OTP system with Trezor support
- [x] Fixed Vite build error (temporary)

### 📋 Pending Implementation

#### Phase 1: Core Fixes
- [ ] Update RodauthController OAuth callback
- [ ] Fix IAM::User associations in seeds
- [ ] Add proper hero image asset

#### Phase 2: API Layer
- [ ] Implement JWT service
- [ ] Create API auth controllers
- [ ] Add CORS configuration
- [ ] Implement refresh tokens

#### Phase 3: Multi-Channel
- [ ] Create channel dispatcher
- [ ] Integrate WhatsApp API
- [ ] Integrate Telegram Bot
- [ ] Setup Twilio for SMS

#### Phase 4: OAuth
- [ ] Configure OmniAuth providers
- [ ] Create OAuth service layer
- [ ] Implement provider-specific handling
- [ ] Add account linking

#### Phase 5: Admin OTP
- [ ] Extend Rodauth for OTP
- [ ] Create OTP services
- [ ] Implement Trezor integration
- [ ] Build admin UI

#### Phase 6: Roles & Permissions
- [ ] Create role models
- [ ] Implement RBAC
- [ ] Add authorization layer
- [ ] Create admin tasks

## 🔒 Security Features

1. **Rate Limiting**: 5 attempts per 15 minutes
2. **Token Security**: JWT 15min, Refresh 30 days
3. **OTP Expiry**: 5 minutes
4. **Magic Links**: 15 minutes
5. **Password Policy**: 8+ chars, complexity required
6. **Account Lockout**: After 5 failed attempts
7. **Audit Logging**: All auth events tracked

## 🌐 Environment Variables

```bash
# JWT
JWT_SECRET_KEY=xxx
JWT_EXPIRATION=900

# OAuth Providers
GITHUB_CLIENT_ID=xxx
GOOGLE_CLIENT_ID=xxx
FACEBOOK_APP_ID=xxx
# ... etc

# Communication
TWILIO_ACCOUNT_SID=xxx
WHATSAPP_API_KEY=xxx
TELEGRAM_BOT_TOKEN=xxx

# NextJS
NEXTJS_URL=http://localhost:3000
```

## 📁 File Structure

```
app/
├── controllers/
│   ├── api/v1/
│   │   ├── auth_controller.rb
│   │   └── oauth_controller.rb
│   └── admin/
│       └── sessions_controller.rb
├── models/iam/
│   ├── user.rb
│   ├── account.rb
│   ├── oauth_identity.rb
│   ├── magic_link.rb
│   └── otp_secret.rb
├── services/
│   ├── communication/
│   │   ├── channel_dispatcher.rb
│   │   ├── email_channel.rb
│   │   ├── whatsapp_channel.rb
│   │   └── telegram_channel.rb
│   ├── oauth/
│   │   ├── provider_service.rb
│   │   └── identity_service.rb
│   └── otp/
│       ├── otp_service.rb
│       └── trezor_service.rb
└── misc/
    ├── rodauth_main.rb
    └── rodauth_admin.rb
```

## 🎉 Summary

This architecture provides:
- **Flexibility**: Multiple auth methods and channels
- **Security**: 2FA, rate limiting, audit trails
- **Scalability**: Polymorphic design, service layers
- **User Experience**: Magic links, social login
- **Admin Security**: Mandatory OTP with hardware support

The system separates authentication (IAM) from business logic (Company::Business), allowing for flexible, secure, and maintainable authentication across multiple client types.
