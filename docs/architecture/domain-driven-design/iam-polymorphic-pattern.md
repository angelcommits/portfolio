# IAM Polymorphic Identity Pattern

## Overview

The IAM (Identity and Access Management) context implements a sophisticated polymorphic association pattern that enables universal identity management across different business entities without code duplication.

## Architecture Decision

### Problem
- Multiple business entities need authentication (Site::Application, Company::Business::User, etc.)
- Avoiding duplicate authentication logic across different models
- Maintaining clean domain boundaries while sharing identity management

### Solution: Polymorphic Association Pattern

```ruby
module IAM
  class User < ApplicationRecord
    # Universal identity bridge via polymorphic association
    belongs_to :applicable, polymorphic: true
    
    # Authentication handled separately by Rodauth
    has_one :account, class_name: "IAM::Account"
  end
end
```

## Key Architectural Principles

### 1. Universal Identity Bridge
- IAM::User acts as a bridge between any business entity and authentication
- Uses `applicable_type` and `applicable_id` to connect to ANY model
- Enables multi-tenant authentication without duplication

### 2. Separation of Concerns
- **IAM::User**: Identity and profile information
- **IAM::Account**: Authentication state (managed by Rodauth)
- **Business Entities**: Domain-specific logic (Site::Application, etc.)

### 3. Rodauth Integration
- Password management delegated to Rodauth
- IAM::Account has `password_hash` but NO direct password attribute
- Authentication flow handled by Rodauth, not ActiveRecord validations

## Implementation Patterns

### Creating Users with Polymorphic Association

```ruby
# Correct pattern - use associations
application = Site::Application.create!(name: "App", email: "app@example.com")
user = IAM::User.find_or_create_for(application)

# WRONG - don't set IDs directly
user = IAM::User.create!(applicable_id: 123, applicable_type: "Site::Application")
```

### Factory Pattern for Tests

```ruby
# Correct factory usage
factory :iam_user, class: 'IAM::User' do
  association :applicable, factory: :site_application
  
  # Traits for different applicable types
  trait :admin do
    applicable_type { 'Company::Business::Admin' }
  end
end
```

### Test Helpers

```ruby
module IAMTestHelpers
  def create_authenticated_user(applicable: nil)
    applicable ||= create(:site_application)
    IAM::User.create_with_account(applicable, email: applicable.email)
  end
end
```

## Testing Considerations

### 1. Always Use Associations
- Never set `applicable_id` directly in tests
- Create the associated entity first, then pass it as `applicable`

### 2. Rodauth Testing
- Don't test password directly on IAM::Account
- Mock Rodauth at the controller boundary
- Test IAM models independently from auth flow

### 3. Validation Expectations
- IAM::User validates: email, name (NOT account or profile_type)
- Blog::Article validates: title (NOT summary - that's a DB constraint)
- Don't expect validations that don't exist in the model

## Benefits of This Pattern

1. **Flexibility**: Any model can become authenticatable
2. **Maintainability**: Single source of truth for identity
3. **Scalability**: Easy to add new authenticatable entities
4. **Clean Boundaries**: Clear separation between identity and business logic
5. **Type Safety**: Polymorphic association ensures referential integrity

## Common Pitfalls to Avoid

1. **Don't bypass the polymorphic pattern** - Always use associations
2. **Don't add authentication logic to IAM models** - Let Rodauth handle it
3. **Don't duplicate user attributes** - Sync from applicable entity
4. **Don't test implementation details** - Test behavior, not structure

## Migration Path for Existing Tests

When updating tests to match this architecture:

1. Replace direct attribute assignments with associations
2. Remove password-related tests from model specs
3. Use IAMTestHelpers for consistent test data creation
4. Update validation expectations to match actual model validations
5. Test polymorphic behavior explicitly

## Related Documentation

- [Rodauth Integration](../auth/rodauth-integration.md)
- [Testing Strategy](../testing-strategy.md)
- [Domain Contexts](./contexts.md)