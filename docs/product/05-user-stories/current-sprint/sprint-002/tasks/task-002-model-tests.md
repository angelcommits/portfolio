# TASK-002-002-002: Complete Model Test Coverage

**Parent**: STORY-002-002 - Backend Unit and Integration Tests  
**Status**: 🔄 IN PROGRESS  
**Assignee**: Backend Developer  
**Priority**: P0  
**Estimation**: 3 hours  
**Time Spent**: 0 hours  
**Branch**: `task/story-002-002-model-tests`  

---

## 📋 Task Details

Write comprehensive tests for all Rails models to achieve >90% coverage.

## 🎯 Objective

Ensure all models have proper test coverage including validations, associations, and methods.

## ✅ Acceptance Criteria

- [ ] User model tests complete (>90% coverage)
- [ ] Portfolio model tests complete (>90% coverage)
- [ ] PortfolioItem tests complete (>90% coverage)
- [ ] PortfolioAccess tests complete (>90% coverage)
- [ ] Coverage report shows >90% for models

## 📊 Models to Test

### User Model
```ruby
# Tests needed:
- Validations (email, password)
- Associations (portfolios, accesses)
- Scopes (active, inactive)
- Instance methods
- Class methods
- Callbacks
```

### Portfolio Model
```ruby
# Tests needed:
- Validations (name, slug)
- Associations (user, items, accesses)
- Scopes (published, draft)
- Slug generation
- Privacy settings
- Soft delete
```

### PortfolioItem Model
```ruby
# Tests needed:
- Validations (type, position)
- Associations (portfolio)
- Ordering logic
- Media attachments
- Item types
```

### PortfolioAccess Model
```ruby
# Tests needed:
- Validations (level, token)
- Associations (portfolio, user)
- Access levels
- Token generation
- Expiration logic
```

## 📝 Implementation Steps

1. **User Model Tests**
   ```ruby
   describe User do
     # Authentication tests
     # Association tests
     # Validation tests
     # Method tests
   end
   ```

2. **Portfolio Model Tests**
   ```ruby
   describe Portfolio do
     # CRUD tests
     # Slug tests
     # Privacy tests
     # Soft delete tests
   end
   ```

3. **PortfolioItem Tests**
   ```ruby
   describe PortfolioItem do
     # Position tests
     # Type tests
     # Media tests
   end
   ```

4. **PortfolioAccess Tests**
   ```ruby
   describe PortfolioAccess do
     # Permission tests
     # Token tests
     # Expiration tests
   end
   ```

## 🔧 Test Patterns

### Validation Testing
```ruby
it { should validate_presence_of(:name) }
it { should validate_uniqueness_of(:email) }
```

### Association Testing
```ruby
it { should belong_to(:user) }
it { should have_many(:items) }
```

### Method Testing
```ruby
describe '#published?' do
  context 'when status is published' do
    it 'returns true'
  end
end
```

## 📊 Coverage Targets

| Model | Current | Target | Gap |
|-------|---------|--------|-----|
| User | 15% | 90% | 75% |
| Portfolio | 10% | 90% | 80% |
| PortfolioItem | 5% | 90% | 85% |
| PortfolioAccess | 0% | 90% | 90% |

---

*Created: 2025-01-20*  
*Blocked by: TASK-001 (Fix failing tests)*