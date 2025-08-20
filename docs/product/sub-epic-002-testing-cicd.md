# SUB-EPIC-002: Testing Infrastructure and CI/CD Pipeline

## Epic Information
- **Parent Epic**: EPIC-001 - Portfolio as a Service Stabilization
- **Epic ID**: SUB-EPIC-002
- **Priority**: P0 - Critical (No deployment without testing)
- **Duration**: 2 weeks
- **Status**: PENDING
- **Dependencies**: SUB-EPIC-001 (Documentation) should be mostly complete

## Goal
Establish a robust testing infrastructure with comprehensive test coverage and a reliable CI/CD pipeline that ensures code quality and enables safe, frequent deployments to production.

## Background Context

### Current State
- RSpec tests broken or missing in backend
- No frontend tests configured
- GitHub Actions pipeline misconfigured or failing
- No test coverage reporting
- No E2E tests
- No performance testing
- Manual deployment process

### Target State
- >80% test coverage on critical paths
- All test suites passing in CI/CD
- Automated deployment pipeline
- Test coverage reports and quality gates
- E2E tests for critical user journeys
- Performance benchmarks established
- Deployment possible multiple times per day

## User Stories

### STORY-001: Repair and Configure RSpec Test Suite
**As a** backend developer  
**I want to** have a working RSpec test suite  
**So that** I can ensure code quality and prevent regressions

**Acceptance Criteria:**
- [ ] All existing RSpec tests fixed or removed if obsolete
- [ ] Test database properly configured (test.sqlite3)
- [ ] Factory Bot factories created for all models
- [ ] Test helpers and support files configured
- [ ] Spring and parallel testing configured for speed
- [ ] Coverage reporting with SimpleCov configured
- [ ] Guard configured for continuous testing

**Tasks:**
1. Fix RSpec configuration in `rails_helper.rb` and `spec_helper.rb`
2. Repair or remove broken test files
3. Create factories for User, Portfolio, and related models
4. Configure database_cleaner for transaction rollback
5. Set up SimpleCov with 80% threshold
6. Configure Guard for file watching

**Estimation:** 8 hours

---

### STORY-002: Implement Critical Backend Tests
**As a** technical lead  
**I want to** have comprehensive backend test coverage  
**So that** the API is reliable and maintainable

**Acceptance Criteria:**
- [ ] Model specs for all domain models (>90% coverage)
- [ ] Controller specs for all API endpoints (>80% coverage)
- [ ] Service specs for business logic (>85% coverage)
- [ ] Request specs for integration testing
- [ ] Validation and edge case testing
- [ ] Authentication flow fully tested

**Tasks:**
1. Write model specs for User, Portfolio, and related models
2. Write controller specs for API v1 endpoints
3. Write service specs for authentication and portfolio services
4. Create request specs for full API flow testing
5. Test error handling and edge cases
6. Test Rodauth authentication flows

**Estimation:** 16 hours

---

### STORY-003: Setup Frontend Testing Infrastructure
**As a** frontend developer  
**I want to** have Jest and React Testing Library configured  
**So that** I can test Next.js components and logic

**Acceptance Criteria:**
- [ ] Jest configured for Next.js
- [ ] React Testing Library installed and configured
- [ ] Test utilities and custom render functions created
- [ ] Mock API client for testing
- [ ] Coverage reporting configured
- [ ] ESLint rules for tests configured

**Tasks:**
1. Install and configure Jest with Next.js
2. Set up React Testing Library
3. Create test utilities and mocks
4. Configure coverage thresholds
5. Create example tests as templates
6. Document testing patterns

**Estimation:** 6 hours

---

### STORY-004: Implement Frontend Component Tests
**As a** frontend developer  
**I want to** have tests for critical components  
**So that** the UI remains stable during changes

**Acceptance Criteria:**
- [ ] Portfolio viewer components tested
- [ ] Dashboard components tested
- [ ] Authentication forms tested
- [ ] Navigation components tested
- [ ] Custom hooks tested
- [ ] API integration layer tested

**Tasks:**
1. Test portfolio display components
2. Test dashboard and editing components
3. Test login/signup forms
4. Test navigation and routing
5. Test custom hooks for auth and data
6. Test API service layer

**Estimation:** 12 hours

---

### STORY-005: Fix GitHub Actions CI Pipeline
**As a** DevOps engineer  
**I want to** have a working CI pipeline  
**So that** code quality is automatically verified

**Acceptance Criteria:**
- [ ] GitHub Actions workflow files corrected
- [ ] Backend tests running in CI
- [ ] Frontend tests running in CI
- [ ] Linting (RuboCop, ESLint) in CI
- [ ] Security scanning (Brakeman, npm audit)
- [ ] Test results and coverage visible in PR
- [ ] Build artifacts created

**Tasks:**
1. Fix `.github/workflows/ci.yml`
2. Configure test job for Rails with PostgreSQL service
3. Configure test job for Next.js
4. Add linting jobs
5. Add security scanning
6. Configure coverage reporting to PR comments
7. Cache dependencies for speed

**Estimation:** 8 hours

---

### STORY-006: Implement E2E Testing with Cypress
**As a** QA engineer  
**I want to** have E2E tests for critical user journeys  
**So that** we ensure the full system works correctly

**Acceptance Criteria:**
- [ ] Cypress installed and configured
- [ ] Test data seeding strategy implemented
- [ ] Critical user journeys tested
- [ ] Visual regression testing configured
- [ ] E2E tests integrated in CI pipeline
- [ ] Test reports generated

**Critical User Journeys to Test:**
1. User registration and email verification
2. User login and logout
3. Portfolio creation and editing
4. Portfolio public viewing
5. Password reset flow
6. Profile management

**Estimation:** 12 hours

---

### STORY-007: Setup Deployment Pipeline
**As a** DevOps engineer  
**I want to** have automated deployment  
**So that** we can deploy safely and frequently

**Acceptance Criteria:**
- [ ] Staging deployment workflow created
- [ ] Production deployment workflow created
- [ ] Docker images built and pushed
- [ ] Database migrations automated
- [ ] Rollback procedure implemented
- [ ] Deployment notifications configured

**Tasks:**
1. Create `.github/workflows/deploy-staging.yml`
2. Create `.github/workflows/deploy-production.yml`
3. Configure Docker build and push
4. Set up Kamal deployment
5. Configure secrets and environment variables
6. Add deployment status notifications

**Estimation:** 10 hours

---

### STORY-008: Implement Performance Testing
**As a** performance engineer  
**I want to** have performance benchmarks  
**So that** we maintain acceptable response times

**Acceptance Criteria:**
- [ ] Load testing configured with k6
- [ ] API performance benchmarks established
- [ ] Frontend performance metrics (Lighthouse)
- [ ] Database query performance monitored
- [ ] Performance regression alerts configured
- [ ] Performance reports in CI

**Tasks:**
1. Install and configure k6 for load testing
2. Write load test scenarios
3. Configure Lighthouse CI for frontend
4. Add query performance logging
5. Set up performance thresholds
6. Create performance dashboard

**Estimation:** 8 hours

## Technical Approach

### Testing Strategy
```
┌─────────────────────────────────────┐
│          E2E Tests (Cypress)         │  <- User Journeys
├─────────────────────────────────────┤
│     Integration Tests (RSpec)        │  <- API Flows
├─────────────────────────────────────┤
│  Unit Tests (RSpec/Jest)            │  <- Models/Components
└─────────────────────────────────────┘
```

### CI/CD Pipeline Architecture
```yaml
name: CI/CD Pipeline
on: [push, pull_request]

jobs:
  backend-tests:
    - Setup PostgreSQL
    - Run RSpec
    - Generate coverage
    
  frontend-tests:
    - Run Jest
    - Run ESLint
    - Generate coverage
    
  e2e-tests:
    - Start services
    - Run Cypress
    - Upload screenshots
    
  deploy:
    - Build Docker images
    - Push to registry
    - Deploy with Kamal
```

### Quality Gates
- Minimum 80% test coverage
- All tests must pass
- No critical security issues
- Performance benchmarks met
- Successful staging deployment

## Dependencies

### Technical Dependencies
- GitHub Actions runners available
- Docker Hub or registry access
- Test database setup
- Staging environment available

### Knowledge Dependencies
- RSpec best practices
- Jest/React Testing Library patterns
- Cypress test writing
- GitHub Actions syntax
- Docker and Kamal configuration

## Risks and Mitigation

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Tests reveal many bugs | High | High | Fix critical bugs first, create tech debt backlog |
| CI pipeline complex to fix | Medium | Medium | Start with simple pipeline, iterate |
| E2E tests flaky | Medium | Medium | Implement retry logic, fix flaky tests immediately |
| Performance issues found | High | Low | Address before production, may delay timeline |
| Team lacks testing knowledge | Medium | Medium | Provide examples, pair programming, documentation |

## Success Metrics

### Coverage Metrics
- Backend: >80% overall, >90% models, >80% controllers
- Frontend: >70% overall, >80% components
- E2E: All critical paths covered

### Pipeline Metrics
- CI build time: <10 minutes
- Test execution time: <5 minutes
- Deployment time: <10 minutes
- Pipeline success rate: >95%

### Quality Metrics
- Bug escape rate: <5%
- Test flakiness: <2%
- Mean time to deploy: <30 minutes

## Timeline

### Week 1: Foundation
**Days 1-2: Test Infrastructure**
- Fix RSpec configuration
- Setup Jest for frontend
- Fix basic CI pipeline

**Days 3-5: Core Testing**
- Write critical backend tests
- Write critical frontend tests
- Ensure CI runs successfully

### Week 2: Comprehensive Coverage
**Days 6-8: Full Coverage**
- Complete test coverage goals
- Add E2E tests
- Performance testing setup

**Days 9-10: Pipeline Completion**
- Complete deployment pipeline
- Documentation and training
- Handoff to team

## Definition of Done

- [ ] All 8 stories completed and accepted
- [ ] Test coverage meets thresholds (>80%)
- [ ] CI/CD pipeline fully green
- [ ] E2E tests passing for all critical paths
- [ ] Performance benchmarks established and met
- [ ] Deployment to staging successful
- [ ] Documentation updated
- [ ] Team trained on new processes
- [ ] Monitoring and alerts configured
- [ ] Rollback procedure tested

## Team Assignments

| Story | Primary | Secondary | Reviewer |
|-------|---------|-----------|----------|
| STORY-001 | Backend Dev | Tech Lead | QA |
| STORY-002 | Backend Dev | QA | Tech Lead |
| STORY-003 | Frontend Dev | Tech Lead | Backend Dev |
| STORY-004 | Frontend Dev | QA | Tech Lead |
| STORY-005 | DevOps | Tech Lead | Backend Dev |
| STORY-006 | QA | Frontend Dev | Tech Lead |
| STORY-007 | DevOps | Backend Dev | Tech Lead |
| STORY-008 | QA | DevOps | Tech Lead |

## Next Steps After Completion

1. Monitor pipeline stability for 1 week
2. Address any flaky tests immediately
3. Begin SUB-EPIC-003 (Authentication)
4. Establish regular test review sessions
5. Create testing best practices guide

---

*Sub-Epic created with BMad Framework*
*Version: 1.0.0*
*Created: 2025-01-19*
*Status: PENDING*