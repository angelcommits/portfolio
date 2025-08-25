# TASK-004: Service Test Coverage - Pre-Implementation Review

**Date**: 2025-08-23  
**Status**: READY TO START  
**Branch**: To be created: `task/story-002-004-service-tests`  
**Estimated Time**: 2-3 hours  

---

## 📋 Task Overview

**Objective**: Implement comprehensive test coverage for all service layer components  
**Target Coverage**: >85% for service layer  
**Prerequisites**: TASK-001 ✅, TASK-002 ✅, TASK-003 ✅

## 🔍 Service Discovery Results

### Services Identified

#### 1. **Inference::GenerateService** 
- **Location**: `app/services/inference/generate_service.rb`
- **Purpose**: LLM integration service for AI content generation
- **Dependencies**: LLMAdapterFactory, ENV['LLM_PROVIDER']
- **Methods**: `.call(prompt:, model:, temperature:)`
- **Test Priority**: HIGH - Core AI functionality

#### 2. **OAuth::ProviderService**
- **Location**: `app/services/oauth/provider_service.rb`
- **Purpose**: OAuth provider configuration and data normalization
- **Dependencies**: Environment variables for OAuth credentials
- **Methods**: 
  - `.available_providers`
  - `.provider_config(provider)`
  - `.provider_enabled?(provider)`
  - `.normalize_auth_data(auth)`
  - `.extract_email(auth)`
  - `.extract_name(auth)`
  - `.extract_image_url(auth)`
  - `.extract_credentials(auth)`
- **Test Priority**: HIGH - Authentication critical path

#### 3. **OAuth::IdentityService**
- **Location**: `app/services/oauth/identity_service.rb`
- **Purpose**: OAuth identity management and account linking
- **Dependencies**: IAM::OAuthIdentity, IAM::Account, Company::Business::User
- **Methods**:
  - `.find_or_create_from_auth(auth_hash)`
  - `.link_to_account(identity, account)`
  - `.unlink_from_account(identity)`
  - `.find_or_create_account(identity, auth_data)`
  - `.update_account_from_oauth(account, auth_data)`
  - `.connected_providers(account)`
  - `.can_disconnect_provider?(account, provider)`
- **Test Priority**: CRITICAL - User authentication and account management

#### 4. **Identity::Application::RegisterUser** (Use Case)
- **Location**: `app/contexts/identity/application/register_user.rb`
- **Purpose**: User registration use case following DDD pattern
- **Dependencies**: Identity::Domain::User, Identity::Infrastructure::UserRepository
- **Methods**: `#call(params)`
- **Test Priority**: HIGH - User onboarding flow

## 📊 Current Coverage Analysis

### Service Test Status
| Service | Current Coverage | Tests Exist | Status |
|---------|-----------------|-------------|--------|
| Inference::GenerateService | 0% | ❌ | Pending |
| OAuth::ProviderService | 0% | ❌ | Pending |
| OAuth::IdentityService | 0% | ❌ | Pending |
| Identity::Application::RegisterUser | 0% | ❌ | Pending |

### Test Complexity Assessment
| Service | Complexity | Test Cases Needed | Mocking Required |
|---------|------------|-------------------|------------------|
| Inference::GenerateService | Low | 5-7 | LLMAdapterFactory |
| OAuth::ProviderService | Medium | 15-20 | ENV variables |
| OAuth::IdentityService | High | 20-25 | Multiple models |
| Identity::Application::RegisterUser | Medium | 8-10 | Repository pattern |

## 🎯 Implementation Strategy

### Phase 1: Foundation (30 min)
1. Create service test directory structure
2. Set up shared contexts and helpers
3. Configure mocking patterns for external dependencies

### Phase 2: OAuth Services (60 min)
1. **OAuth::ProviderService Tests**
   - Provider availability based on ENV
   - Configuration retrieval
   - Data normalization for each provider
   - Edge cases (missing email, name, image)

2. **OAuth::IdentityService Tests**
   - Identity creation and updates
   - Account linking/unlinking
   - Provider connection management
   - Transaction rollback scenarios

### Phase 3: Core Services (45 min)
1. **Inference::GenerateService Tests**
   - Successful generation calls
   - Model and temperature parameters
   - LLMAdapterFactory integration
   - Error handling for missing provider

2. **Identity::Application::RegisterUser Tests**
   - Successful registration flow
   - Validation failures
   - Repository save errors
   - Error result formatting

### Phase 4: Integration & Coverage (45 min)
1. Service interaction tests
2. Edge case coverage
3. Error recovery scenarios
4. Coverage report generation

## 📝 Test Patterns to Implement

### Service Test Template
```ruby
RSpec.describe ServiceName, type: :service do
  describe '.class_method' do
    subject { described_class.class_method(params) }
    
    context 'with valid params' do
      it 'returns expected result'
      it 'performs side effects'
      it 'logs appropriate messages'
    end
    
    context 'with invalid params' do
      it 'handles errors gracefully'
      it 'returns error response'
    end
    
    context 'with external dependencies' do
      it 'mocks external calls'
      it 'handles dependency failures'
    end
  end
end
```

### Mocking Strategy
- **Environment Variables**: Use stub_env helper
- **External Services**: Use WebMock for HTTP calls
- **Database Models**: Use FactoryBot with traits
- **Transactions**: Test rollback scenarios

## 🚨 Risk Assessment

### Technical Risks
1. **OAuth Complexity**: Multiple provider variations need careful mocking
2. **Transaction Testing**: Ensuring rollback scenarios work correctly
3. **Factory Dependencies**: Need proper IAM::OAuthIdentity factory
4. **Environment Setup**: Many ENV variables to stub

### Mitigation Strategies
1. Create comprehensive OAuth mock helpers
2. Use database_cleaner for transaction tests
3. Build complete factory hierarchy
4. Create ENV stubbing utility

## ✅ Success Criteria

### Must Have
- [ ] All 4 services have test files
- [ ] >85% coverage for service layer
- [ ] All happy paths tested
- [ ] Critical error paths covered
- [ ] No hard failures in test suite

### Nice to Have
- [ ] Performance benchmarks for services
- [ ] Integration tests between services
- [ ] Mock data fixtures for OAuth providers
- [ ] Service documentation generated from tests

## 🔄 Execution Plan

### Step 1: Branch Setup
```bash
git checkout -b task/story-002-004-service-tests
```

### Step 2: Directory Structure
```
spec/services/
├── inference/
│   └── generate_service_spec.rb
├── oauth/
│   ├── provider_service_spec.rb
│   └── identity_service_spec.rb
└── support/
    ├── oauth_helpers.rb
    └── service_helpers.rb

spec/contexts/identity/application/
└── register_user_spec.rb
```

### Step 3: Implementation Order
1. OAuth::ProviderService (simplest, no DB)
2. Inference::GenerateService (simple, one dependency)
3. Identity::Application::RegisterUser (medium complexity)
4. OAuth::IdentityService (most complex, many dependencies)

### Step 4: Validation
```bash
bundle exec rspec spec/services --format documentation
bundle exec rspec spec/contexts --format documentation
```

## 📊 Expected Outcomes

### Test Metrics
- **New Tests**: ~60 test cases
- **Coverage Increase**: +15-20% overall
- **Service Coverage**: >85%
- **Execution Time**: <500ms total

### Quality Improvements
- Service behavior documentation
- Error handling validation
- Integration point identification
- Performance baseline establishment

## 🔗 Dependencies

### Required Factories
- [ ] iam_oauth_identity
- [ ] company_business_user
- [ ] identity_domain_user

### Required Helpers
- [ ] OAuth mock data generator
- [ ] ENV stubbing utility
- [ ] Service test matchers

## 📝 Notes for Developer

### Priority Focus Areas
1. **OAuth flows** - Critical for user authentication
2. **Error scenarios** - Ensure graceful degradation
3. **Transaction integrity** - Validate rollback behavior
4. **Provider variations** - Test all 7 OAuth providers

### Watch Out For
- OAuth provider-specific quirks (Twitter email, Apple first-sign-in)
- Transaction nesting in OAuth::IdentityService
- Factory circular dependencies with polymorphic associations
- ENV variable presence checks in provider availability

### Quick Wins
- Start with OAuth::ProviderService (no DB, pure logic)
- Use shared examples for common patterns
- Leverage existing authentication_helpers.rb
- Copy patterns from TASK-003 controller tests

---

**Ready to Execute**: ✅  
**Estimated Completion**: 2-3 hours  
**Next Task**: TASK-005 (Integration Tests)