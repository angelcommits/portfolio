# TASK-002-002-006: Coverage Improvement to 80%

**Parent**: STORY-002-002 - Backend Unit and Integration Tests  
**Status**: ⏳ PENDING  
**Assignee**: Backend Developer  
**Priority**: P0  
**Estimation**: 3 hours  
**Time Spent**: 0 hours  

---

## 📋 Task Details

Improve test coverage from current 15% to target 80% across all backend components.

## 🎯 Objective

Achieve 80% test coverage milestone with focus on critical paths and business logic.

## ✅ Acceptance Criteria

- [ ] Overall coverage reaches 80%
- [ ] Model coverage >90%
- [ ] Controller coverage >85%
- [ ] Service coverage >80%
- [ ] Helper/Concern coverage >70%
- [ ] Coverage report in CI shows green

## 📊 Current Coverage Analysis

### Coverage Breakdown
```
File                          | % Stmts | % Branch | % Funcs | % Lines |
------------------------------|---------|----------|---------|---------|
All files                     |   15.2  |    12.4  |   18.3  |   15.2  |
 models/                      |   15.0  |    10.0  |   20.0  |   15.0  |
  user.rb                     |   15.0  |    10.0  |   20.0  |   15.0  |
  portfolio.rb                |   10.0  |     8.0  |   15.0  |   10.0  |
  portfolio_item.rb           |    5.0  |     5.0  |   10.0  |    5.0  |
  portfolio_access.rb         |    0.0  |     0.0  |    0.0  |    0.0  |
 controllers/                 |   18.0  |    15.0  |   20.0  |   18.0  |
 services/                    |    0.0  |     0.0  |    0.0  |    0.0  |
 jobs/                        |    0.0  |     0.0  |    0.0  |    0.0  |
 helpers/                     |    0.0  |     0.0  |    0.0  |    0.0  |
```

## 📝 Priority Areas for Coverage

### High Priority (Critical Paths)
1. **Authentication Flow** (0% → 90%)
   - Login/logout
   - Token generation
   - Password reset
   
2. **Portfolio CRUD** (10% → 85%)
   - Create/update/delete
   - Publishing flow
   - Access control

3. **API Responses** (18% → 85%)
   - Success responses
   - Error handling
   - Pagination

### Medium Priority
1. **Background Jobs** (0% → 70%)
   - Media processing
   - Email delivery
   - Search indexing

2. **Services** (0% → 80%)
   - Business logic
   - External integrations
   - Data transformations

### Low Priority
1. **Helpers** (0% → 60%)
   - Utility methods
   - Formatters
   - View helpers

## 🔧 Coverage Improvement Strategy

### Step 1: Fix Foundation (Current 15% → 30%)
```bash
# Fix failing tests first
bundle exec rspec --fail-fast

# Add missing model validations
bundle exec rspec spec/models/

# Coverage check
bundle exec rspec --format RspecJunitFormatter
```

### Step 2: Core Features (30% → 60%)
```bash
# Controller tests
bundle exec rspec spec/controllers/

# Request specs
bundle exec rspec spec/requests/
```

### Step 3: Business Logic (60% → 80%)
```bash
# Service tests
bundle exec rspec spec/services/

# Integration tests
bundle exec rspec spec/integration/
```

## 📊 Coverage Targets by Component

| Component | Current | Step 1 | Step 2 | Final | Gap |
|-----------|---------|--------|--------|-------|-----|
| Models | 15% | 40% | 70% | 90% | 75% |
| Controllers | 18% | 35% | 65% | 85% | 67% |
| Services | 0% | 20% | 50% | 80% | 80% |
| Jobs | 0% | 10% | 40% | 70% | 70% |
| Helpers | 0% | 10% | 30% | 60% | 60% |
| **Overall** | **15%** | **30%** | **60%** | **80%** | **65%** |

## 🎯 Quick Wins for Coverage

### 1. Model Validations (Easy +10%)
```ruby
# Quick validation tests with shoulda-matchers
it { should validate_presence_of(:email) }
it { should validate_uniqueness_of(:email) }
it { should have_many(:portfolios) }
```

### 2. Controller Actions (Medium +15%)
```ruby
# Basic controller tests
describe 'GET #index' do
  it 'returns success'
  it 'assigns portfolios'
  it 'renders json'
end
```

### 3. Happy Path Tests (Easy +20%)
```ruby
# Focus on success scenarios first
it 'creates portfolio successfully'
it 'updates portfolio successfully'
it 'deletes portfolio successfully'
```

## 📈 Tracking Progress

### Daily Goals
- **Day 1**: Fix failures, reach 30%
- **Day 2**: Add controller tests, reach 50%
- **Day 3**: Add service tests, reach 70%
- **Day 4**: Fill gaps, reach 80%

### Metrics to Monitor
```bash
# Run with coverage
COVERAGE=true bundle exec rspec

# Generate HTML report
open coverage/index.html

# Check specific file
bundle exec rspec spec/models/user_spec.rb --format documentation
```

## 🚧 Blockers

- Need to fix 18 failing tests first (TASK-001)
- Some services may need refactoring for testability
- External service mocks needed

## 📊 Success Metrics

- [ ] SimpleCov shows 80%+ coverage
- [ ] All tests passing (0 failures)
- [ ] CI pipeline green
- [ ] Coverage badge updated
- [ ] No skipped tests

---

*Created: 2025-01-20*  
*Final task in STORY-002-002 sequence*