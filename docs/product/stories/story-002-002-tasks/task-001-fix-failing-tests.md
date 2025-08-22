# TASK-002-002-001: Fix Failing Model Tests

**Parent**: STORY-002-002 - Backend Unit and Integration Tests  
**Status**: 🔄 IN PROGRESS  
**Assignee**: Backend Developer  
**Priority**: P0 (Blocking)  
**Estimation**: 2 hours  
**Time Spent**: 1 hour  

---

## 📋 Task Details

Fix 18 failing tests that are currently blocking test suite progression.

## 🎯 Objective

Make all existing tests pass by adjusting them to match actual model structure.

## ✅ Acceptance Criteria

- [ ] All 18 failing tests fixed
- [ ] Tests match actual model structure
- [ ] No skip or pending tests
- [ ] CI pipeline green for backend tests

## 📊 Failing Tests Analysis

### User Model (6 failures)
```ruby
# Issues found:
- Module name: IAM vs Iam
- Devise modules not configured
- Missing validations
```

### Portfolio Model (4 failures)
```ruby
# Issues found:
- Polymorphic associations unexpected
- Missing required attributes
```

### PortfolioItem Model (4 failures)
```ruby
# Issues found:
- Belongs to portfolio relationship
- Validation differences
```

### PortfolioAccess Model (4 failures)
```ruby
# Issues found:
- Model structure mismatch
- Association naming
```

## 📝 Implementation Steps

1. **Analyze actual models**
   ```bash
   ls -la app/models/
   cat app/models/user.rb
   cat app/models/portfolio.rb
   ```

2. **Update test expectations**
   - Fix module naming (IAM → Iam)
   - Adjust association tests
   - Update validation tests

3. **Verify factories**
   - Ensure factories match models
   - Fix any factory build errors

4. **Run tests iteratively**
   ```bash
   bundle exec rspec spec/models/user_spec.rb
   bundle exec rspec spec/models/portfolio_spec.rb
   ```

## 🔧 Technical Notes

- Models use `Iam` module, not `IAM`
- Polymorphic associations may not be implemented
- Check for STI vs separate models

## 📊 Progress Log

- [x] Initial test run - 18 failures identified
- [x] Fixed module naming: `Iam::` → `IAM::`
- [x] Fixed factory attribute mismatches
- [x] Removed non-existent service spec
- [x] Reduced failures from 18 → 9 (50% improvement)
- [ ] Fix status field integer comparisons in Account model
- [ ] Add missing email validations
- [ ] Fix remaining association issues

## 🎯 Current Status (1 hour spent)

**Failures Reduced**: 18 → 9 (50% progress)  
**Key Issues Fixed**: Module naming, factory mismatches  
**Remaining Work**: Model validation fixes  
**Next Action**: Apply quick fixes to Account model

See detailed findings: `spec/TASK-001-FINDINGS.md`

---

*Created: 2025-01-20*  
*Last Updated: 2025-01-20*