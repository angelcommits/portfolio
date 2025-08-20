# 🧪 Testing Layers in Ribbon Rails App (RSpec)

This document explains the layered structure of tests in a Ruby on Rails application using RSpec. It includes practical examples and clear criteria to decide when to use each type of spec.

---

## 📁 Directory Structure Overview

```txt
spec/
├── models/         # Unit tests for models
├── services/       # Unit tests for business logic
├── requests/       # Integration tests (organized by resource and protocol)
│   └── site/
│       └── profiles/
│           ├── json/         # JSON REST API tests
│           │   └── v1/
│           │       ├── get_spec.rb
│           │       ├── post_spec.rb
│           │       ├── put_spec.rb
│           │       ├── patch_spec.rb
│           │       └── delete_spec.rb
│           ├── graphql/      # GraphQL API tests
│           │   ├── queries/
│           │   └── mutations/
│           ├── grpc/         # gRPC service tests
│           ├── websocket/    # WebSocket tests
│           └── html/         # HTML response tests
├── features/       # Feature tests (simulate user flow, may or may not use JS)
├── system/         # System tests (real browser interaction)
├── factories/      # FactoryBot definitions
├── support/        # Shared helpers and config
└── coverage/       # SimpleCov coverage reports
```

---

## 🧱 1. Unit Tests (`spec/models`, `spec/services`, etc.)

* **Purpose**: Test single units in isolation (classes, methods)
* **Tools**: RSpec only
* **Speed**: 🟢 Fast

**Use when**:

* You want to verify validations, associations, or algorithmic logic
* There are no side effects or external dependencies

```ruby
# spec/models/site/profile_spec.rb
RSpec.describe Site::Profile, type: :model do
  describe 'validations' do
    it 'is invalid without email' do
      expect(build(:profile, email: nil)).not_to be_valid
    end
  end
  
  describe '.find_by' do
    it 'returns profile data for valid id' do
      profile = Site::Profile.find_by(id: 1)
      expect(profile[:email]).to eq('angel@szymczak.dev')
    end
  end
end
```

---

## 🔗 2. Integration Tests (`spec/requests`)

* **Purpose**: Test endpoints and system interactions (e.g., API controller + model)
* **Tools**: RSpec + Rack::Test
* **Speed**: 🟡 Moderate

**Use when**:

* You want to verify request/response cycles
* You want to test GraphQL or REST endpoints
* You're not concerned with the UI

```ruby
# spec/requests/site/profiles/json/v1/get_spec.rb
RSpec.describe 'JSON API: GET /api/v1/site/profiles/:id', type: :request do
  context 'when profile exists' do
    it 'returns profile data' do
      get "/api/v1/site/profiles/1"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['email']).to eq('angel@szymczak.dev')
    end
  end
end

# spec/requests/site/profiles/graphql/queries/profile_spec.rb
RSpec.describe 'GraphQL: Profile Query', type: :request do
  let(:query) do
    <<~GRAPHQL
      query GetProfile($id: ID!) {
        profile(id: $id) {
          id
          email
          brand
        }
      }
    GRAPHQL
  end
  
  it 'returns profile data' do
    post '/graphql', params: { query: query, variables: { id: 1 } }
    expect(response).to have_http_status(:ok)
  end
end
```

---

## 🧩 3. Feature Tests (`spec/features`)

* **Purpose**: Simulate a complete user flow in terms of business logic
* **Tools**: RSpec + Capybara (can run with or without JS)
* **Speed**: 🟠 Slow if JS enabled

**Use when**:

* You're testing a feature described in a product ticket (e.g., "User logs in and sees dashboard")
* You want to simulate interactions, form submissions, flash messages
* JS is optional unless needed

```ruby
# spec/features/visitor_views_profile_spec.rb
RSpec.feature 'Visitor views profile', type: :feature do
  scenario 'sees developer information' do
    visit '/profiles/1'
    expect(page).to have_content('Angel Szymczak')
    expect(page).to have_content('Full Stack Web Developer')
    expect(page).to have_link('GitHub', href: 'https://github.com/angel.stack')
  end
  
  scenario 'downloads resume' do
    visit '/profiles/1'
    click_link 'Download Resume'
    expect(page.response_headers['Content-Type']).to include('application/pdf')
  end
end
```

> Add `js: true` if the feature uses JavaScript (e.g., modals, dynamic content)

---

## 🌐 4. System Tests (`spec/system`)

* **Purpose**: End-to-end test using a real browser (headless or visible)
* **Tools**: Capybara + Selenium/ChromeDriver/WebDriver
* **Speed**: 🔴 Slowest

**Use when**:

* You need to interact with dynamic content (e.g., stimulus, turbo, modals)
* You need to verify CSS/JS behavior or full frontend behavior
* You're debugging layout, rendering issues, or JS-based features

```ruby
# spec/system/profile_interactive_features_spec.rb
RSpec.describe 'Profile interactive features', type: :system, js: true do
  it 'displays social links in modal' do
    visit '/profiles/1'
    click_button 'Connect with me'
    within('#social-modal') do
      expect(page).to have_link('LinkedIn')
      expect(page).to have_link('GitHub')
      expect(page).to have_link('WhatsApp')
    end
  end
  
  it 'schedules meeting via Calendly widget' do
    visit '/profiles/1'
    click_button 'Schedule a meeting'
    expect(page).to have_css('.calendly-inline-widget')
  end
end
```

---

## 🧠 Feature vs System: Key Differences

| Criteria       | Feature Spec                     | System Test                      |
| -------------- | -------------------------------- | -------------------------------- |
| JS Support     | Optional (`js: true`)            | Required (real browser)          |
| Driver         | Capybara (rack or headless)      | Capybara + WebDriver             |
| Accuracy       | Medium (simulates flow)          | High (full E2E realism)          |
| Performance    | Better                           | Slower                           |
| Use Case       | Functional flow (business logic) | UI + JS-heavy testing            |
| When to prefer | Login, dashboard, submit form    | Animations, modals, turbo-frames |

> Think: Feature spec = "¿el flujo de negocio funciona?"
> System spec = "¿la UI completa reacciona correctamente con JS incluido?"

---

## ✅ Summary Cheatsheet

```txt
- Use UNIT TESTS to test logic in isolation (fastest)
- Use INTEGRATION TESTS to validate HTTP or GraphQL APIs
- Use FEATURE TESTS to simulate a business use-case flow
- Use SYSTEM TESTS for full UI + JS validation in the browser
```

---

## 🧩 Bonus: Setup Notes

Enable JavaScript support with Capybara:

```ruby
Capybara.javascript_driver = :selenium_chrome_headless
```

Run only feature specs:

```sh
bundle exec rspec spec/features
```

Run only system specs:

```sh
bundle exec rspec spec/system
```

---

## 📊 Test Coverage with SimpleCov

### Setup

```ruby
# spec/rails_helper.rb or spec/spec_helper.rb
require 'simplecov'

SimpleCov.start 'rails' do
  enable_coverage :branch  # Enable branch coverage
  
  # Coverage groups
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"
  add_group "Services", "app/services"
  add_group "Contexts", "app/contexts"
  add_group "Adapters", "app/adapters"
  
  # Exclude files
  add_filter "/spec/"
  add_filter "/config/"
  add_filter "/vendor/"
  
  # Minimum coverage enforcement
  minimum_coverage 90
  minimum_coverage_by_file 80
  
  # Coverage format
  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::HTMLFormatter,
    SimpleCov::Formatter::JSONFormatter,
  ])
end
```

### Running Tests with Coverage

```bash
# Run all tests with coverage
COVERAGE=true bundle exec rspec

# View coverage report
open coverage/index.html

# CI/CD integration
bundle exec rspec --format RspecJunitFormatter --out rspec.xml
```

### Coverage by Layer

```ruby
# spec/support/coverage_helper.rb
RSpec.configure do |config|
  config.after(:suite) do
    if ENV['COVERAGE']
      coverage_by_type = {
        models: SimpleCov.result.groups['Models'].covered_percent,
        controllers: SimpleCov.result.groups['Controllers'].covered_percent,
        services: SimpleCov.result.groups['Services'].covered_percent
      }
      
      puts "\n📊 Coverage by Layer:"
      coverage_by_type.each do |type, percent|
        puts "  #{type.to_s.capitalize}: #{percent.round(2)}%"
      end
    end
  end
end
```

---

## 🔄 OpenAPI/Swagger Integration

### Request Specs with OpenAPI Documentation

```ruby
# spec/swagger_helper.rb
require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s
  
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Portfolio API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'https://{defaultHost}',
          variables: {
            defaultHost: {
              default: 'www.example.com'
            }
          }
        }
      ]
    }
  }
end
```

### Enhanced Request Specs

```ruby
# spec/requests/site/profiles/json/v1/get_swagger_spec.rb
require 'swagger_helper'

RSpec.describe 'Site Profiles API', type: :request do
  path '/api/v1/site/profiles/{id}' do
    parameter name: :id, in: :path, type: :integer, description: 'Profile ID'
    
    get 'Retrieves a profile' do
      tags 'Profiles'
      produces 'application/json'
      
      response '200', 'profile found' do
        schema type: :object,
          properties: {
            id: { type: :integer },
            email: { type: :string, format: :email },
            brand: { type: :string }
          }
        
        let(:id) { 1 }
        
        run_test! do |response|
          data = JSON.parse(response.body)
          expect(data['email']).to eq('angel@szymczak.dev')
        end
      end
      
      response '404', 'profile not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end
```

---

## 🛠️ Auto-generate Spec Structure Script (Bash)

```bash
#!/usr/bin/env bash

# Create base directories
mkdir -p spec/{models,services,factories,support,coverage}

# Create request spec structure for a resource
create_request_specs() {
  local resource=$1
  local base_path="spec/requests/${resource}"
  
  mkdir -p "${base_path}"/{json/v1,graphql/{queries,mutations},grpc,websocket,html}
  
  # Create placeholder files
  for method in get post put patch delete; do
    touch "${base_path}/json/v1/${method}_spec.rb"
  done
  
  echo "✅ Request specs structure created for ${resource}"
}

# Create feature and system directories
mkdir -p spec/{features,system}

# Example: Create structure for profiles
create_request_specs "site/profiles"

# Setup coverage directory
mkdir -p coverage

echo "✅ Full spec directory structure created."
```

---

## 📋 Site::Profile Test Examples Summary

### Complete Test Coverage for Site::Profile

| Layer | File Path | Purpose |
|-------|-----------|---------|
| Unit | `spec/models/site/profile_spec.rb` | Model validations, methods |
| Integration (JSON) | `spec/requests/site/profiles/json/v1/*_spec.rb` | REST API endpoints |
| Integration (GraphQL) | `spec/requests/site/profiles/graphql/**/*_spec.rb` | GraphQL queries/mutations |
| Feature | `spec/features/visitor_views_profile_spec.rb` | User flow without JS |
| System | `spec/system/profile_interactive_features_spec.rb` | Full UI with JS interactions |
| Factory | `spec/factories/site/profiles.rb` | Test data generation |

### Coverage Goals by Layer

```yaml
coverage_goals:
  models: 95%          # High coverage for business logic
  controllers: 90%     # Good coverage for request handling
  services: 90%        # Critical business logic
  requests: 85%        # API endpoint coverage
  features: 70%        # Key user flows
  system: 60%          # Critical UI interactions
```

### Test Execution Strategy

```bash
# Run tests by layer
bundle exec rspec spec/models                    # Fastest
bundle exec rspec spec/requests                  # API tests
bundle exec rspec spec/features --tag ~js        # Features without JS
bundle exec rspec spec/system                    # Slowest, full browser

# Run with coverage report
COVERAGE=true bundle exec rspec

# Parallel execution for CI/CD
bundle exec parallel_test spec/ -t rspec
```

---

## 🎯 Best Practices

1. **Test Pyramid**: More unit tests, fewer system tests
2. **DRY**: Use shared examples and contexts
3. **Fast Feedback**: Run unit tests frequently during development
4. **Isolation**: Mock external services in unit/integration tests
5. **Documentation**: Tests serve as living documentation with OpenAPI
6. **Coverage**: Aim for high coverage but focus on meaningful tests

---

## 🚀 Next Steps

1. Implement SimpleCov configuration in `spec/spec_helper.rb`
2. Add rswag gems for OpenAPI integration
3. Create shared examples for common patterns
4. Set up parallel test execution for CI/CD
5. Configure coverage thresholds per layer
6. Generate API documentation from tests
