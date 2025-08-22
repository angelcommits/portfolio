# TASK-002-002-004: Service and Business Logic Tests

**Parent**: STORY-002-002 - Backend Unit and Integration Tests  
**Status**: ⏳ PENDING  
**Assignee**: Backend Developer  
**Priority**: P1  
**Estimation**: 3 hours  
**Time Spent**: 0 hours  

---

## 📋 Task Details

Test service objects, business logic, and domain services that handle complex operations.

## 🎯 Objective

Ensure all business logic is properly tested including edge cases and error scenarios.

## ✅ Acceptance Criteria

- [ ] Authentication services tested
- [ ] Portfolio services tested
- [ ] Media processing services tested
- [ ] Email services tested
- [ ] Background job tests complete
- [ ] >80% service coverage achieved

## 📊 Services to Test

### AuthenticationService
```ruby
class AuthenticationService
  # Methods to test:
  - authenticate_user
  - generate_jwt_token
  - refresh_token
  - verify_email
  - reset_password
  - lock_account
end
```

### PortfolioService
```ruby
class PortfolioService
  # Methods to test:
  - create_portfolio
  - duplicate_portfolio
  - publish_portfolio
  - archive_portfolio
  - generate_slug
  - check_permissions
end
```

### MediaService
```ruby
class MediaService
  # Methods to test:
  - process_upload
  - optimize_image
  - generate_thumbnails
  - validate_file_type
  - clean_orphaned_files
end
```

### NotificationService
```ruby
class NotificationService
  # Methods to test:
  - send_welcome_email
  - send_password_reset
  - send_portfolio_shared
  - queue_email
  - handle_bounce
end
```

## 📝 Test Scenarios

### Authentication Service Tests
```ruby
describe AuthenticationService do
  describe '#authenticate_user' do
    context 'with valid credentials' do
      it 'returns user and token'
      it 'updates last_login timestamp'
      it 'logs authentication event'
    end
    
    context 'with invalid password' do
      it 'returns nil'
      it 'increments failed attempts'
      it 'locks account after 5 attempts'
    end
    
    context 'with unverified email' do
      it 'returns unverified error'
      it 'sends verification reminder'
    end
  end
  
  describe '#generate_jwt_token' do
    it 'includes user id in payload'
    it 'sets correct expiration'
    it 'uses secure secret'
  end
end
```

### Portfolio Service Tests
```ruby
describe PortfolioService do
  describe '#create_portfolio' do
    it 'creates portfolio with default settings'
    it 'generates unique slug'
    it 'handles slug collisions'
    it 'creates audit log entry'
    
    context 'with template' do
      it 'copies template structure'
      it 'maintains item ordering'
    end
  end
  
  describe '#publish_portfolio' do
    it 'changes status to published'
    it 'sets published_at timestamp'
    it 'invalidates cache'
    it 'triggers indexing job'
    
    context 'with validation errors' do
      it 'returns errors without publishing'
      it 'maintains draft status'
    end
  end
end
```

### Background Job Tests
```ruby
describe PortfolioIndexJob do
  it 'indexes portfolio for search'
  it 'handles missing portfolio gracefully'
  it 'retries on network errors'
end

describe MediaProcessingJob do
  it 'processes uploaded images'
  it 'generates multiple sizes'
  it 'handles invalid files'
  it 'cleans up temp files'
end
```

## 🔧 Testing Patterns

### Service Object Testing
```ruby
# Arrange
let(:service) { described_class.new(user: user) }
let(:params) { { name: 'Test Portfolio' } }

# Act
result = service.call(params)

# Assert
expect(result).to be_success
expect(result.portfolio).to be_persisted
```

### Mock External Services
```ruby
before do
  allow(EmailService).to receive(:deliver).and_return(true)
  allow(S3Client).to receive(:upload).and_return('url')
end
```

### Test Transactions
```ruby
it 'rolls back on failure' do
  expect {
    service.call(invalid_params)
  }.not_to change { Portfolio.count }
end
```

## 📊 Service Coverage

| Service | Methods | Tests | Coverage |
|---------|---------|-------|----------|
| AuthenticationService | 6 | 0 | 0% |
| PortfolioService | 8 | 0 | 0% |
| MediaService | 5 | 0 | 0% |
| NotificationService | 5 | 0 | 0% |
| **Total** | **24** | **0** | **0%** |

## 🎯 Error Handling Tests

```ruby
describe 'error handling' do
  context 'when database is down' do
    it 'returns service unavailable'
    it 'logs error details'
    it 'sends alert to monitoring'
  end
  
  context 'when external API fails' do
    it 'uses fallback behavior'
    it 'queues for retry'
    it 'notifies admin after 3 failures'
  end
end
```

---

*Created: 2025-01-20*  
*Blocked by: TASK-003 (Controller tests)*