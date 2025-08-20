# OpenAPI + Swagger Integration Proposal

## Overview
Integrating OpenAPI 3.0 specification with Swagger UI for comprehensive API documentation and testing.

## Recommended Solution: rswag

### Why rswag?
- **RSpec Integration**: Write tests that generate OpenAPI specs
- **DRY Principle**: Tests serve as both validation and documentation
- **Swagger UI**: Built-in interactive API explorer
- **Rails Native**: Designed specifically for Rails applications

### Implementation Plan

#### 1. Add to Gemfile
```ruby
group :development, :test do
  gem 'rswag-api'
  gem 'rswag-ui'
  gem 'rswag-specs'
end
```

#### 2. Configure rswag
```ruby
# config/initializers/rswag_api.rb
Rswag::Api.configure do |c|
  c.swagger_root = Rails.root.to_s + '/swagger'
  c.swagger_filter = lambda { |swagger, env| swagger['host'] = env['HTTP_HOST'] }
end

# config/initializers/rswag_ui.rb
Rswag::Ui.configure do |c|
  c.swagger_endpoint '/api-docs/v1/swagger.yaml', 'API V1 Docs'
  c.basic_auth_enabled = true if Rails.env.production?
end
```

#### 3. Update Request Specs
Transform existing request specs to generate OpenAPI documentation:

```ruby
# spec/requests/site/profiles/json/v1/get_spec.rb
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
            brand: { type: :string },
            startYear: { type: :integer },
            biography: { type: :array, items: { type: :string } },
            social_links: {
              type: :object,
              properties: {
                github: { type: :string, format: :uri },
                linkedin: { type: :string, format: :uri }
              }
            }
          },
          required: ['id', 'email', 'brand']
        
        let(:id) { 1 }
        run_test!
      end
      
      response '404', 'profile not found' do
        let(:id) { 999 }
        run_test!
      end
    end
  end
end
```

#### 4. Generate OpenAPI Spec
```bash
# Generate swagger.yaml from specs
bundle exec rake rswag:specs:swaggerize
```

#### 5. Access Documentation
- Development: `http://localhost:3000/api-docs`
- Production: Protected with basic auth

### Directory Structure with OpenAPI
```
spec/
├── swagger_helper.rb              # rswag configuration
├── requests/
│   └── site/
│       └── profiles/
│           └── json/
│               └── v1/
│                   ├── get_spec.rb    # Enhanced with OpenAPI annotations
│                   └── ...
└── swagger/
    └── v1/
        └── swagger.yaml           # Generated OpenAPI spec
```

### Additional Features

#### 1. Schema Definitions
```ruby
# spec/swagger_helper.rb
RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s
  
  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Portfolio API V1',
        version: 'v1'
      },
      components: {
        schemas: {
          Profile: {
            type: :object,
            properties: {
              id: { type: :integer },
              email: { type: :string, format: :email },
              brand: { type: :string }
            }
          },
          Error: {
            type: :object,
            properties: {
              error: { type: :string },
              status: { type: :integer }
            }
          }
        }
      }
    }
  }
end
```

#### 2. Authentication Documentation
```ruby
components: {
  securitySchemes: {
    bearer_auth: {
      type: :http,
      scheme: :bearer,
      bearerFormat: 'JWT'
    }
  }
}
```

#### 3. API Versioning
- Separate swagger files per version
- Version-specific endpoints documentation
- Migration guides between versions

### Benefits for This Project

1. **DDD Alignment**: Document each bounded context's API separately
2. **Multi-Protocol Ready**: Can document REST now, add GraphQL later
3. **Testing Integration**: Your existing RSpec tests generate docs
4. **Frontend Collaboration**: Frontend team has live API playground
5. **Client Generation**: Auto-generate TypeScript/JavaScript clients

### Alternative: grape-swagger
If using Grape for API:
```ruby
gem 'grape-swagger'
gem 'grape-swagger-rails'
```

### Next Steps
1. Install rswag gems
2. Configure swagger_helper.rb
3. Enhance one endpoint as proof of concept
4. Generate and review documentation
5. Gradually migrate all endpoints
6. Set up CI/CD to auto-generate docs

This approach maintains your test-first philosophy while adding comprehensive API documentation!
