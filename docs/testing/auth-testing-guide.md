# Authentication Test Suite

This directory contains comprehensive tests for the authentication system implemented in this Rails application.

## Test Coverage

### 1. API Authentication Controller (`spec/controllers/api/v1/auth_controller_spec.rb`)
- **Login endpoint** (`POST /api/v1/auth/login`)
  - Valid credentials
  - Invalid credentials
  - Locked accounts
  - Unverified accounts
  - Rate limiting
  - Parameter validation
- **Logout endpoint** (`POST /api/v1/auth/logout`)
  - With valid token
  - Without token
- **Token refresh** (`POST /api/v1/auth/refresh`)
  - Valid refresh token
  - Invalid/expired tokens
  - Wrong token type
- **Magic link endpoints**
  - Request (`POST /api/v1/auth/magic-link`)
  - Verify (`POST /api/v1/auth/magic-link/verify`)
  - Rate limiting
  - Expiration handling
- **Current user** (`GET /api/v1/auth/me`)
  - With valid/invalid/expired tokens
- **Password validation**
  - Minimum length, uppercase, lowercase, digits, special characters

### 2. OAuth Controller (`spec/controllers/api/v1/oauth_controller_spec.rb`)
- **Provider management**
  - List providers (`GET /api/v1/oauth/providers`)
  - Link provider (`POST /api/v1/oauth/:provider/link`)
  - Unlink provider (`DELETE /api/v1/oauth/:provider/unlink`)
- **OAuth flow**
  - Provider authentication (`GET /auth/:provider`)
  - Callback handling (`GET /auth/:provider/callback`)
  - New user registration via OAuth
  - Existing user login via OAuth
  - Account linking
- **Provider-specific behaviors**
  - Apple Sign In (no email handling)
  - Twitter OAuth (no initial email)
- **Security**
  - CSRF protection (state parameter)
  - Session expiration
  - XSS prevention

### 3. Security Services

#### Rate Limiter (`spec/services/security/rate_limiter_spec.rb`)
- Basic rate limiting functionality
- Custom limits and windows
- Key-based tracking
- Reset functionality
- Use cases: login, magic links, OAuth, API requests
- Thread safety
- Performance testing

#### Audit Logger (`spec/services/security/audit_logger_spec.rb`)
- Event logging (login, logout, OAuth, etc.)
- Structured JSON output
- Request context capture
- Severity levels
- Privacy compliance (no sensitive data)
- Log rotation handling

### 4. OAuth Services

#### Provider Service (`spec/services/oauth/provider_service_spec.rb`)
- Available providers listing
- Provider configuration
- OAuth URL generation
- Callback processing
- Token refresh
- Access revocation
- Provider-specific behaviors (GitHub, Google, Apple, etc.)

#### Identity Service (`spec/services/oauth/identity_service_spec.rb`)
- Find or create account from OAuth
- Link/unlink providers
- Token management
- Security (input sanitization)

### 5. Model Tests

#### IAM::Account (`spec/models/iam/account_spec.rb`)
- Validations (email format, uniqueness, password requirements)
- Associations (users, OAuth identities, sessions)
- Status management (verified, locked, closed)
- Authentication helpers
- OAuth integration
- Session management
- Magic link functionality

#### IAM::User (`spec/models/iam/user_spec.rb`)
- Validations
- Polymorphic profile association
- Delegated methods
- Scopes
- Authentication helpers

#### IAM::OAuthIdentity (`spec/models/iam/oauth_identity_spec.rb`)
- Validations
- Provider-specific handling
- Token management
- Data storage (JSON fields)
- Security features

### 6. Base API Controller (`spec/controllers/api_controller_spec.rb`)
- JWT authentication
- Error handling
- CORS headers
- Request ID tracking
- Rate limiting integration
- Audit logging integration

### 7. Rodauth Controller (`spec/controllers/rodauth_controller_spec.rb`)
- Traditional login/logout forms
- Account registration
- OAuth callback handling
- Account status handling

### 8. Integration Tests (`spec/integration/authentication_flow_spec.rb`)
- Complete authentication journeys
- Email/password registration and login
- Magic link flow
- OAuth authentication
- Token refresh flow
- Security features (rate limiting, account locking)
- Audit logging verification

## Running the Tests

### Run all authentication tests:
```bash
bundle exec rspec spec/auth_test_suite.rb
```

### Run specific test files:
```bash
# API authentication tests
bundle exec rspec spec/controllers/api/v1/auth_controller_spec.rb

# OAuth tests
bundle exec rspec spec/controllers/api/v1/oauth_controller_spec.rb

# Security service tests
bundle exec rspec spec/services/security/

# Model tests
bundle exec rspec spec/models/iam/

# Integration tests
bundle exec rspec spec/integration/authentication_flow_spec.rb
```

### Run with coverage:
```bash
COVERAGE=true bundle exec rspec spec/auth_test_suite.rb
```

## Test Helpers

The test suite includes several helper modules in `spec/support/`:

### AuthenticationHelpers
- `create_account` - Create test accounts
- `api_login` - Login via API
- `auth_headers` - Generate auth headers
- `create_and_login_account` - Combined helper
- `create_magic_link` / `verify_magic_link` - Magic link helpers
- `create_oauth_identity` - OAuth identity creation
- `mock_oauth_auth` - Mock OmniAuth responses
- Rate limiting helpers
- Audit log helpers

### RodauthHelpers
- Rodauth-specific helpers
- Password requirement helpers
- Session management helpers
- OTP helpers (for future implementation)

## Test Database

The test suite uses DatabaseCleaner to ensure a clean database state between tests:
- Transaction strategy for most tests
- Truncation strategy for request specs
- Automatic cleanup after each test

## Factory Definitions

FactoryBot factories are defined for:
- `iam_account` - IAM accounts
- `iam_user` - IAM users with polymorphic profiles
- `oauth_identity` - OAuth identities
- `company_business_user` - Business user profiles

## Coverage Requirements

The test suite aims for:
- 90% overall coverage
- 100% coverage of authentication endpoints
- 100% coverage of security services
- Comprehensive edge case testing

## Notes

1. **Multi-channel Support**: The authentication system is designed for multi-channel delivery (email, WhatsApp, Telegram, SMS) but currently only email is implemented.

2. **OTP System**: The OTP/2FA system is designed but not yet implemented. Tests are ready to be activated when the feature is built.

3. **Hardware Wallet**: Trezor hardware wallet integration is planned but not yet implemented.

4. **Rate Limiting**: All rate limits are configurable and tested with realistic thresholds.

5. **Audit Logging**: Comprehensive audit logging is tested for all authentication events.

6. **Security**: The test suite includes extensive security testing including XSS prevention, CSRF protection, and rate limiting.