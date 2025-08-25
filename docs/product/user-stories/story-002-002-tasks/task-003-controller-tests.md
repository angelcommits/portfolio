# TASK-002-002-003: API Controller Tests

**Parent**: STORY-002-002 - Backend Unit and Integration Tests  
**Status**: ⏳ PENDING  
**Assignee**: Backend Developer  
**Priority**: P0  
**Estimation**: 4 hours  
**Time Spent**: 0 hours  

---

## 📋 Task Details

Write comprehensive tests for all API controllers including authentication, authorization, and response formats.

## 🎯 Objective

Ensure all API endpoints are properly tested with various scenarios and edge cases.

## ✅ Acceptance Criteria

- [ ] Authentication controller tests complete
- [ ] Portfolios controller tests complete
- [ ] Portfolio items controller tests complete
- [ ] Users controller tests complete
- [ ] Request specs for all endpoints
- [ ] >85% controller coverage achieved

## 📊 Controllers to Test

### AuthenticationController
```ruby
# Endpoints:
POST   /api/auth/login
POST   /api/auth/logout
POST   /api/auth/refresh
POST   /api/auth/register
POST   /api/auth/verify
POST   /api/auth/reset-password
```

### PortfoliosController
```ruby
# Endpoints:
GET    /api/portfolios
GET    /api/portfolios/:id
POST   /api/portfolios
PATCH  /api/portfolios/:id
DELETE /api/portfolios/:id
GET    /api/portfolios/:id/public
```

### PortfolioItemsController
```ruby
# Endpoints:
GET    /api/portfolios/:portfolio_id/items
POST   /api/portfolios/:portfolio_id/items
PATCH  /api/portfolios/:portfolio_id/items/:id
DELETE /api/portfolios/:portfolio_id/items/:id
PATCH  /api/portfolios/:portfolio_id/items/reorder
```

## 📝 Test Scenarios

### Authentication Tests
```ruby
describe 'POST /api/auth/login' do
  context 'with valid credentials' do
    it 'returns JWT token'
    it 'returns user data'
  end
  
  context 'with invalid credentials' do
    it 'returns 401 unauthorized'
    it 'returns error message'
  end
  
  context 'with locked account' do
    it 'returns account locked message'
  end
end
```

### Authorization Tests
```ruby
describe 'authorization' do
  context 'without token' do
    it 'returns 401 for protected endpoints'
  end
  
  context 'with expired token' do
    it 'returns 401 with expired message'
  end
  
  context 'with invalid token' do
    it 'returns 401 with invalid message'
  end
end
```

### CRUD Tests
```ruby
describe 'GET /api/portfolios' do
  it 'returns paginated portfolios'
  it 'filters by status'
  it 'sorts by created_at'
  it 'includes portfolio items when requested'
end

describe 'POST /api/portfolios' do
  context 'with valid params' do
    it 'creates portfolio'
    it 'returns created portfolio'
    it 'generates unique slug'
  end
  
  context 'with invalid params' do
    it 'returns validation errors'
    it 'returns 422 status'
  end
end
```

## 🔧 Request Spec Structure

```ruby
# spec/requests/api/portfolios_spec.rb
RSpec.describe 'Portfolios API', type: :request do
  let(:user) { create(:user) }
  let(:token) { generate_jwt_token(user) }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  
  describe 'GET /api/portfolios' do
    before do
      create_list(:portfolio, 3, user: user)
    end
    
    it 'returns portfolios for authenticated user' do
      get '/api/portfolios', headers: headers
      
      expect(response).to have_http_status(:ok)
      expect(json_response['portfolios'].size).to eq(3)
    end
  end
end
```

## 📊 Coverage Requirements

| Controller | Endpoints | Tests Needed | Priority |
|------------|-----------|--------------|----------|
| Authentication | 6 | 18 | P0 |
| Portfolios | 6 | 24 | P0 |
| PortfolioItems | 5 | 20 | P0 |
| Users | 3 | 9 | P1 |

## 🎯 Response Format Tests

```ruby
# Ensure consistent API responses
it 'returns standard success format' do
  # { success: true, data: {...} }
end

it 'returns standard error format' do
  # { success: false, error: {...}, message: "..." }
end

it 'includes pagination metadata' do
  # { data: [...], meta: { page: 1, total: 10 } }
end
```

---

*Created: 2025-01-20*  
*Blocked by: TASK-002 (Model tests)*