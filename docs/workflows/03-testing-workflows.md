# Testing Workflows and Best Practices

## 🎯 Overview

This guide provides comprehensive workflows for testing the Portfolio Backend application. We follow a test-driven development (TDD) approach with multiple layers of testing to ensure code quality, reliability, and maintainability.

## 🏗️ Testing Architecture

### Testing Pyramid
```
         ╱╲
        ╱E2E╲        <- End-to-End Tests (5%)
       ╱──────╲
      ╱Integrat╲     <- Integration Tests (15%)
     ╱──────────╲
    ╱  System    ╲   <- System Tests (20%)
   ╱──────────────╲
  ╱   Unit Tests   ╲ <- Unit Tests (60%)
 ╱──────────────────╲
```

### Testing Stack
- **Framework**: RSpec 3.13
- **Factories**: Factory Bot
- **Mocking**: RSpec Mocks
- **Fixtures**: RSpec Fixtures
- **Coverage**: SimpleCov
- **E2E**: Capybara + Selenium
- **API Testing**: RSpec Request Specs
- **Performance**: rack-mini-profiler

## 🚀 Test Development Workflows

### Workflow 1: TDD for New Features

```bash
# 1. Write failing test first
# spec/models/product_spec.rb
require 'rails_helper'

RSpec.describe Product, type: :model do
  describe '#calculate_discount' do
    it 'calculates percentage discount correctly' do
      product = build(:product, price: 100, discount_percentage: 20)
      expect(product.calculate_discount).to eq(80)
    end
  end
end

# 2. Run test (should fail)
bundle exec rspec spec/models/product_spec.rb

# 3. Implement minimal code to pass
# app/models/product.rb
class Product < ApplicationRecord
  def calculate_discount
    price * (1 - discount_percentage / 100.0)
  end
end

# 4. Run test again (should pass)
bundle exec rspec spec/models/product_spec.rb

# 5. Refactor if needed
# 6. Add edge cases
```

### Workflow 2: Unit Testing Models

```ruby
# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  # Test validations
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_length_of(:password).is_at_least(8) }
    
    it 'validates email format' do
      user = build(:user, email: 'invalid-email')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is invalid')
    end
  end

  # Test associations
  describe 'associations' do
    it { should have_many(:projects).dependent(:destroy) }
    it { should have_many(:articles).through(:authorship) }
    it { should belong_to(:organization).optional }
  end

  # Test scopes
  describe 'scopes' do
    describe '.active' do
      let!(:active_user) { create(:user, status: 'active') }
      let!(:inactive_user) { create(:user, status: 'inactive') }

      it 'returns only active users' do
        expect(User.active).to include(active_user)
        expect(User.active).not_to include(inactive_user)
      end
    end
  end

  # Test instance methods
  describe '#full_name' do
    it 'concatenates first and last name' do
      user = build(:user, first_name: 'John', last_name: 'Doe')
      expect(user.full_name).to eq('John Doe')
    end

    it 'handles missing last name' do
      user = build(:user, first_name: 'John', last_name: nil)
      expect(user.full_name).to eq('John')
    end
  end

  # Test callbacks
  describe 'callbacks' do
    describe 'before_save' do
      it 'normalizes email to lowercase' do
        user = create(:user, email: 'TEST@EXAMPLE.COM')
        expect(user.reload.email).to eq('test@example.com')
      end
    end
  end
end
```

### Workflow 3: Controller Testing

```ruby
# spec/controllers/api/v1/products_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  let(:user) { create(:user) }
  let(:product) { create(:product, user: user) }

  before { sign_in user }

  describe 'GET #index' do
    let!(:products) { create_list(:product, 3) }

    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end

    it 'returns all products' do
      get :index
      expect(json_response[:data].size).to eq(3)
    end

    context 'with search params' do
      let!(:special_product) { create(:product, name: 'Special Item') }

      it 'filters products by search term' do
        get :index, params: { q: 'Special' }
        expect(json_response[:data].size).to eq(1)
        expect(json_response[:data][0][:name]).to eq('Special Item')
      end
    end

    context 'with pagination' do
      let!(:many_products) { create_list(:product, 30) }

      it 'paginates results' do
        get :index, params: { page: 2, per_page: 10 }
        expect(json_response[:data].size).to eq(10)
        expect(json_response[:meta][:current_page]).to eq(2)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:valid_params) {
        { product: attributes_for(:product) }
      }

      it 'creates a new product' do
        expect {
          post :create, params: valid_params
        }.to change(Product, :count).by(1)
      end

      it 'returns created status' do
        post :create, params: valid_params
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      let(:invalid_params) {
        { product: { name: '' } }
      }

      it 'does not create a product' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Product, :count)
      end

      it 'returns unprocessable entity status' do
        post :create, params: invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
```

### Workflow 4: Request/Integration Testing

```ruby
# spec/requests/api/v1/products_spec.rb
require 'rails_helper'

RSpec.describe "Products API", type: :request do
  let(:user) { create(:user) }
  let(:headers) { authenticated_headers(user) }

  describe 'Product CRUD operations' do
    it 'allows full CRUD workflow' do
      # CREATE
      product_params = { product: { name: 'Test Product', price: 99.99 } }
      post api_v1_products_path, params: product_params, headers: headers
      
      expect(response).to have_http_status(:created)
      product_id = json_response[:id]

      # READ
      get api_v1_product_path(product_id), headers: headers
      expect(response).to be_successful
      expect(json_response[:name]).to eq('Test Product')

      # UPDATE
      patch api_v1_product_path(product_id), 
            params: { product: { name: 'Updated Product' } },
            headers: headers
      
      expect(response).to be_successful
      expect(json_response[:name]).to eq('Updated Product')

      # DELETE
      delete api_v1_product_path(product_id), headers: headers
      expect(response).to have_http_status(:no_content)

      # Verify deletion
      get api_v1_product_path(product_id), headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'Error handling' do
    it 'handles not found errors gracefully' do
      get api_v1_product_path(999999), headers: headers
      
      expect(response).to have_http_status(:not_found)
      expect(json_response[:error][:code]).to eq('not_found')
    end

    it 'handles validation errors with details' do
      post api_v1_products_path, 
           params: { product: { name: '', price: -10 } },
           headers: headers
      
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response[:error][:details]).to include("Name can't be blank")
      expect(json_response[:error][:details]).to include("Price must be greater than 0")
    end
  end
end
```

### Workflow 5: System/Feature Testing

```ruby
# spec/system/user_registration_spec.rb
require 'rails_helper'

RSpec.describe "User Registration", type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end

  scenario 'User successfully registers' do
    visit new_user_registration_path

    fill_in 'Email', with: 'new_user@example.com'
    fill_in 'Password', with: 'password123'
    fill_in 'Password confirmation', with: 'password123'
    fill_in 'First name', with: 'John'
    fill_in 'Last name', with: 'Doe'

    click_button 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(page).to have_current_path(dashboard_path)
    expect(User.last.email).to eq('new_user@example.com')
  end

  scenario 'User sees validation errors' do
    visit new_user_registration_path

    fill_in 'Email', with: 'invalid-email'
    fill_in 'Password', with: 'short'
    
    click_button 'Sign up'

    expect(page).to have_content('Email is invalid')
    expect(page).to have_content('Password is too short')
    expect(User.count).to eq(0)
  end
end
```

## 🏭 Factory Patterns

### Basic Factory
```ruby
# spec/factories/products.rb
FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Product #{n}" }
    description { Faker::Lorem.paragraph }
    price { Faker::Commerce.price(range: 10..100) }
    status { 'active' }
    user

    # Traits for different states
    trait :featured do
      featured { true }
      featured_at { Time.current }
    end

    trait :archived do
      status { 'archived' }
      archived_at { Time.current }
    end

    trait :with_images do
      after(:create) do |product|
        create_list(:product_image, 3, product: product)
      end
    end

    trait :with_reviews do
      transient do
        reviews_count { 5 }
      end

      after(:create) do |product, evaluator|
        create_list(:review, evaluator.reviews_count, product: product)
      end
    end
  end
end

# Usage examples:
# create(:product)
# create(:product, :featured)
# create(:product, :with_images, :with_reviews, reviews_count: 10)
# build_stubbed(:product)  # Doesn't hit database
```

### Complex Factory with Associations
```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { 'password123' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    confirmed_at { Time.current }

    factory :admin_user do
      role { 'admin' }
      
      after(:create) do |user|
        user.add_role(:admin)
      end
    end

    factory :user_with_portfolio do
      after(:create) do |user|
        create(:portfolio, user: user)
        create_list(:project, 3, user: user)
      end
    end
  end
end
```

## 🧪 Testing Best Practices

### Test Organization
```ruby
# spec/support/shared_examples/authenticated_endpoint.rb
RSpec.shared_examples "an authenticated endpoint" do
  context 'without authentication' do
    it 'returns unauthorized status' do
      make_request
      expect(response).to have_http_status(:unauthorized)
    end
  end

  context 'with invalid token' do
    let(:headers) { { 'Authorization' => 'Bearer invalid-token' } }

    it 'returns unauthorized status' do
      make_request
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

# Usage in specs:
describe 'GET #index' do
  let(:make_request) { get api_v1_products_path }
  
  it_behaves_like "an authenticated endpoint"
  
  context 'with valid authentication' do
    # ... authenticated tests
  end
end
```

### Test Helpers
```ruby
# spec/support/request_helpers.rb
module RequestHelpers
  def json_response
    JSON.parse(response.body, symbolize_names: true)
  end

  def authenticated_headers(user)
    token = JsonWebToken.encode(user_id: user.id)
    { 'Authorization' => "Bearer #{token}" }
  end

  def sign_in_as(user)
    post api_v1_auth_login_path, 
         params: { email: user.email, password: 'password' }
    
    token = json_response[:token]
    { 'Authorization' => "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end
```

### Database Cleaner Configuration
```ruby
# spec/support/database_cleaner.rb
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
```

## 📊 Test Coverage

### SimpleCov Configuration
```ruby
# spec/spec_helper.rb
require 'simplecov'

SimpleCov.start 'rails' do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/vendor/'
  
  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Services', 'app/services'
  add_group 'Serializers', 'app/serializers'
  add_group 'Domains', 'app/domains'
  
  minimum_coverage 90
  minimum_coverage_by_file 80
end
```

### Coverage Goals
- **Overall**: 90%+ coverage
- **Models**: 95%+ coverage
- **Controllers**: 90%+ coverage
- **Services**: 95%+ coverage
- **Critical Paths**: 100% coverage

## 🚀 Running Tests

### Quick Commands
```bash
# Run all tests
bundle exec rspec

# Run specific file
bundle exec rspec spec/models/user_spec.rb

# Run specific line
bundle exec rspec spec/models/user_spec.rb:42

# Run by tag
bundle exec rspec --tag focus
bundle exec rspec --tag ~slow  # Exclude slow tests

# Run with coverage
COVERAGE=true bundle exec rspec

# Run in parallel
bundle exec parallel_rspec spec/

# Run with documentation format
bundle exec rspec --format documentation
```

### Continuous Testing
```bash
# Using Guard
bundle exec guard

# Using Spring
spring rspec spec/models/user_spec.rb
```

## 🐛 Debugging Tests

### Debugging Techniques
```ruby
# 1. Use binding.pry
it 'debugs the test' do
  product = create(:product)
  binding.pry  # Stops execution here
  expect(product).to be_valid
end

# 2. Use save_and_open_page (system specs)
scenario 'debugging view' do
  visit products_path
  save_and_open_page  # Opens page in browser
  click_on 'New Product'
end

# 3. Use puts/pp for quick debugging
it 'shows data' do
  product = create(:product)
  pp product.attributes  # Pretty print
  puts product.inspect   # Standard output
end

# 4. Use screenshot helpers
scenario 'captures failure' do
  visit products_path
  save_screenshot('products_page.png')
  # or automatically on failure with:
  # Capybara::Screenshot.autosave_on_failure = true
end
```

## ⚡ Performance Testing

### Benchmark Tests
```ruby
# spec/performance/api_performance_spec.rb
require 'rails_helper'
require 'benchmark'

RSpec.describe "API Performance", type: :request do
  describe 'Products endpoint' do
    let!(:products) { create_list(:product, 100) }

    it 'responds within acceptable time' do
      time = Benchmark.realtime do
        get api_v1_products_path
      end

      expect(time).to be < 0.5  # 500ms threshold
    end

    it 'handles concurrent requests' do
      threads = 10.times.map do
        Thread.new { get api_v1_products_path }
      end

      threads.each(&:join)
      
      # All requests should succeed
      expect(response).to be_successful
    end
  end
end
```

## 🔗 Next Steps

- Continue to [Domain-Driven Design](./04-domain-driven-design.md)
- Review [Frontend Integration](./05-frontend-integration.md)
- Explore [CI/CD Workflows](./06-deployment.md)

## 📚 Resources

- [RSpec Documentation](https://rspec.info/)
- [Better Specs](http://www.betterspecs.org/)
- [Factory Bot Documentation](https://github.com/thoughtbot/factory_bot)
- [Testing Rails Applications Guide](https://guides.rubyonrails.org/testing.html)