# API Development Workflow

## 🎯 Overview

This guide provides comprehensive workflows for developing RESTful APIs in the Portfolio Backend. Follow these patterns to create consistent, maintainable, and well-documented API endpoints.

## 🏗️ API Architecture

### Design Principles
- **RESTful**: Follow REST conventions strictly
- **Versioned**: All APIs under `/api/v1/` namespace
- **Consistent**: Unified response formats and error handling
- **Documented**: OpenAPI/Swagger specifications
- **Secure**: Authentication and authorization by default
- **Performant**: Optimized queries and caching

### API Structure
```
/api/v1/
├── auth/           # Authentication endpoints
├── users/          # User management
├── sites/          # Site configuration
├── portfolios/     # Portfolio items
├── articles/       # Blog articles
├── technologies/   # Tech stack
└── health/         # System health
```

## 🚀 Creating New API Endpoints

### Workflow 1: Basic CRUD Endpoint

```bash
# 1. Generate API controller
rails generate controller api/v1/products --skip-assets --skip-helper

# 2. Generate model (if needed)
rails generate model Product name:string description:text price:decimal
rails db:migrate

# 3. Generate serializer
rails generate serializer Product name description price
```

#### Controller Implementation
```ruby
# app/controllers/api/v1/products_controller.rb
module Api
  module V1
    class ProductsController < ApplicationController
      before_action :set_product, only: [:show, :update, :destroy]

      # GET /api/v1/products
      def index
        @products = Product.page(params[:page]).per(params[:per_page] || 20)
        render json: {
          data: ActiveModelSerializers::SerializableResource.new(
            @products,
            each_serializer: ProductSerializer
          ),
          meta: pagination_meta(@products)
        }
      end

      # GET /api/v1/products/:id
      def show
        render json: @product, serializer: ProductSerializer
      end

      # POST /api/v1/products
      def create
        @product = Product.new(product_params)
        
        if @product.save
          render json: @product, 
                 serializer: ProductSerializer,
                 status: :created
        else
          render_validation_errors(@product)
        end
      end

      # PATCH/PUT /api/v1/products/:id
      def update
        if @product.update(product_params)
          render json: @product, serializer: ProductSerializer
        else
          render_validation_errors(@product)
        end
      end

      # DELETE /api/v1/products/:id
      def destroy
        @product.destroy
        head :no_content
      end

      private

      def set_product
        @product = Product.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render_not_found('Product')
      end

      def product_params
        params.require(:product).permit(:name, :description, :price)
      end
    end
  end
end
```

#### Serializer Configuration
```ruby
# app/serializers/product_serializer.rb
class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :price, :created_at, :updated_at

  # Custom attribute
  attribute :formatted_price do
    "$#{object.price}"
  end

  # Conditional attributes
  attribute :admin_notes, if: :is_admin?

  def is_admin?
    current_user&.admin?
  end
end
```

#### Route Configuration
```ruby
# config/routes/api_v1.rb
namespace :api do
  namespace :v1 do
    resources :products do
      member do
        post :duplicate
        patch :archive
      end
      
      collection do
        get :search
        get :archived
      end
    end
  end
end
```

### Workflow 2: Nested Resources

```ruby
# config/routes/api_v1.rb
namespace :api do
  namespace :v1 do
    resources :portfolios do
      resources :projects, shallow: true do
        resources :technologies
      end
    end
  end
end

# Generates routes:
# GET    /api/v1/portfolios/:portfolio_id/projects
# POST   /api/v1/portfolios/:portfolio_id/projects
# GET    /api/v1/projects/:id
# PATCH  /api/v1/projects/:id
# DELETE /api/v1/projects/:id
```

#### Nested Controller
```ruby
# app/controllers/api/v1/projects_controller.rb
module Api
  module V1
    class ProjectsController < ApplicationController
      before_action :set_portfolio, only: [:index, :create]
      before_action :set_project, only: [:show, :update, :destroy]

      def index
        @projects = @portfolio.projects.includes(:technologies)
        render json: @projects, each_serializer: ProjectSerializer
      end

      def create
        @project = @portfolio.projects.build(project_params)
        
        if @project.save
          render json: @project, 
                 serializer: ProjectSerializer,
                 status: :created
        else
          render_validation_errors(@project)
        end
      end

      private

      def set_portfolio
        @portfolio = Portfolio.find(params[:portfolio_id])
      rescue ActiveRecord::RecordNotFound
        render_not_found('Portfolio')
      end

      def set_project
        @project = Project.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render_not_found('Project')
      end
    end
  end
end
```

### Workflow 3: Advanced Features

#### Search and Filtering
```ruby
# app/controllers/concerns/searchable.rb
module Searchable
  extend ActiveSupport::Concern

  included do
    scope :search, ->(query) {
      where("name ILIKE :q OR description ILIKE :q", q: "%#{query}%")
    }
  end
end

# app/controllers/api/v1/products_controller.rb
def index
  @products = Product.all
  @products = @products.search(params[:q]) if params[:q].present?
  @products = @products.where(category: params[:category]) if params[:category]
  @products = @products.order(sort_column => sort_direction)
  @products = @products.page(params[:page])
  
  render json: {
    data: serialize_collection(@products),
    meta: {
      pagination: pagination_meta(@products),
      filters: active_filters
    }
  }
end

private

def sort_column
  Product.column_names.include?(params[:sort]) ? params[:sort] : 'created_at'
end

def sort_direction
  %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
end
```

#### Batch Operations
```ruby
# app/controllers/api/v1/products_controller.rb
def batch_update
  @products = Product.where(id: params[:ids])
  
  ActiveRecord::Base.transaction do
    @products.each do |product|
      product.update!(batch_params)
    end
  end
  
  render json: @products, each_serializer: ProductSerializer
rescue ActiveRecord::RecordInvalid => e
  render_validation_errors(e.record)
end

def batch_destroy
  Product.where(id: params[:ids]).destroy_all
  head :no_content
end

private

def batch_params
  params.require(:product).permit(:category, :status)
end
```

## 🔐 Authentication & Authorization

### JWT Authentication Workflow
```ruby
# app/controllers/api/v1/authentication_controller.rb
module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_request, only: [:login]

      def login
        @user = User.find_by(email: login_params[:email])
        
        if @user&.authenticate(login_params[:password])
          token = JsonWebToken.encode(user_id: @user.id)
          render json: {
            token: token,
            user: UserSerializer.new(@user)
          }
        else
          render_unauthorized('Invalid credentials')
        end
      end

      def logout
        # Invalidate token (add to blacklist)
        current_token.invalidate!
        head :no_content
      end

      private

      def login_params
        params.require(:auth).permit(:email, :password)
      end
    end
  end
end
```

### Authorization with Pundit
```ruby
# app/policies/product_policy.rb
class ProductPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    user.present? && (record.user == user || user.admin?)
  end

  def destroy?
    update?
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user
        scope.published.or(scope.where(user: user))
      else
        scope.published
      end
    end
  end
end

# app/controllers/api/v1/products_controller.rb
def index
  @products = policy_scope(Product)
  authorize @products
  render json: @products
end

def update
  authorize @product
  # ... update logic
end
```

## 📝 API Documentation

### OpenAPI/Swagger Setup
```ruby
# Gemfile
gem 'rswag'

# config/initializers/rswag_api.rb
Rswag::Api.configure do |c|
  c.swagger_root = Rails.root.to_s + '/swagger'
end

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

### API Documentation Example
```ruby
# spec/requests/api/v1/products_spec.rb
require 'swagger_helper'

RSpec.describe 'api/v1/products', type: :request do
  path '/api/v1/products' do
    get('list products') do
      tags 'Products'
      produces 'application/json'
      parameter name: :page, in: :query, type: :integer, required: false
      parameter name: :per_page, in: :query, type: :integer, required: false
      parameter name: :q, in: :query, type: :string, required: false

      response(200, 'successful') do
        schema type: :object,
               properties: {
                 data: {
                   type: :array,
                   items: { '$ref' => '#/components/schemas/Product' }
                 },
                 meta: { '$ref' => '#/components/schemas/PaginationMeta' }
               }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end
```

## 🧪 Testing API Endpoints

### Request Specs
```ruby
# spec/requests/api/v1/products_spec.rb
require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
  let(:user) { create(:user) }
  let(:headers) { authenticated_headers(user) }

  describe "GET /api/v1/products" do
    let!(:products) { create_list(:product, 3) }

    it "returns paginated products" do
      get api_v1_products_path, headers: headers
      
      expect(response).to have_http_status(:success)
      expect(json_response[:data].size).to eq(3)
      expect(json_response).to have_key(:meta)
    end

    it "filters products by search query" do
      product = create(:product, name: "Special Product")
      
      get api_v1_products_path, params: { q: "Special" }, headers: headers
      
      expect(json_response[:data].size).to eq(1)
      expect(json_response[:data][0][:name]).to eq("Special Product")
    end
  end

  describe "POST /api/v1/products" do
    let(:valid_attributes) {
      { product: { name: "New Product", price: 99.99 } }
    }

    context "with valid parameters" do
      it "creates a new product" do
        expect {
          post api_v1_products_path, 
               params: valid_attributes, 
               headers: headers
        }.to change(Product, :count).by(1)
        
        expect(response).to have_http_status(:created)
        expect(json_response[:name]).to eq("New Product")
      end
    end

    context "with invalid parameters" do
      it "returns validation errors" do
        post api_v1_products_path, 
             params: { product: { name: "" } }, 
             headers: headers
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response[:errors]).to be_present
      end
    end
  end
end
```

### Integration Tests
```ruby
# spec/integration/product_workflow_spec.rb
require 'rails_helper'

RSpec.describe "Product Workflow", type: :request do
  let(:user) { create(:user) }
  let(:headers) { authenticated_headers(user) }

  it "completes full CRUD workflow" do
    # Create
    post api_v1_products_path, 
         params: { product: { name: "Test Product" } },
         headers: headers
    
    expect(response).to have_http_status(:created)
    product_id = json_response[:id]
    
    # Read
    get api_v1_product_path(product_id), headers: headers
    expect(response).to have_http_status(:success)
    
    # Update
    patch api_v1_product_path(product_id),
          params: { product: { name: "Updated Product" } },
          headers: headers
    
    expect(response).to have_http_status(:success)
    expect(json_response[:name]).to eq("Updated Product")
    
    # Delete
    delete api_v1_product_path(product_id), headers: headers
    expect(response).to have_http_status(:no_content)
    
    # Verify deletion
    get api_v1_product_path(product_id), headers: headers
    expect(response).to have_http_status(:not_found)
  end
end
```

## 🔧 Common Patterns

### Error Handling
```ruby
# app/controllers/concerns/error_handler.rb
module ErrorHandler
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
    rescue_from ActionController::ParameterMissing, with: :bad_request
  end

  private

  def not_found(exception)
    render json: {
      error: {
        message: exception.message,
        code: 'not_found'
      }
    }, status: :not_found
  end

  def unprocessable_entity(exception)
    render json: {
      error: {
        message: 'Validation failed',
        code: 'validation_failed',
        details: exception.record.errors.full_messages
      }
    }, status: :unprocessable_entity
  end

  def bad_request(exception)
    render json: {
      error: {
        message: exception.message,
        code: 'bad_request'
      }
    }, status: :bad_request
  end
end
```

### Response Helpers
```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  include ErrorHandler

  private

  def render_success(data, serializer: nil, status: :ok)
    options = { json: data, status: status }
    options[:serializer] = serializer if serializer
    render options
  end

  def render_validation_errors(record)
    render json: {
      error: {
        message: 'Validation failed',
        code: 'validation_failed',
        details: record.errors.full_messages
      }
    }, status: :unprocessable_entity
  end

  def render_not_found(resource_type)
    render json: {
      error: {
        message: "#{resource_type} not found",
        code: 'not_found'
      }
    }, status: :not_found
  end

  def render_unauthorized(message = 'Unauthorized')
    render json: {
      error: {
        message: message,
        code: 'unauthorized'
      }
    }, status: :unauthorized
  end

  def pagination_meta(collection)
    {
      current_page: collection.current_page,
      next_page: collection.next_page,
      prev_page: collection.prev_page,
      total_pages: collection.total_pages,
      total_count: collection.total_count
    }
  end
end
```

### Caching
```ruby
# app/controllers/api/v1/products_controller.rb
def index
  cache_key = ['v1', 'products', params.to_unsafe_h.sort].join('/')
  
  @products = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
    Product.includes(:category)
           .page(params[:page])
           .to_a
  end
  
  render json: @products
end

def show
  fresh_when(@product, public: true)
  render json: @product if stale?(@product)
end
```

## 📊 Performance Optimization

### N+1 Query Prevention
```ruby
# Bad
def index
  @products = Product.all
  render json: @products  # Will trigger N+1 for associations
end

# Good
def index
  @products = Product.includes(:category, :tags, :user)
  render json: @products
end

# With serializer optimization
class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name
  
  has_one :category
  has_many :tags
  
  # Prevent N+1 in serializer
  def tags
    object.tags.loaded? ? object.tags : object.tags.to_a
  end
end
```

### Database Query Optimization
```ruby
# app/models/product.rb
class Product < ApplicationRecord
  # Efficient counting
  scope :with_counts, -> {
    left_joins(:reviews, :likes)
    .group(:id)
    .select('products.*, 
             COUNT(DISTINCT reviews.id) as reviews_count,
             COUNT(DISTINCT likes.id) as likes_count')
  }
  
  # Efficient existence checking
  scope :with_associations, -> {
    includes(:category, :tags).references(:categories, :tags)
  }
end
```

## 🔗 Next Steps

- Continue to [Testing Workflows](./03-testing-workflows.md)
- Review [Domain-Driven Design](./04-domain-driven-design.md)
- Explore [Authentication Workflows](./05-authentication.md)

## 📚 Resources

- [Rails API Documentation](https://api.rubyonrails.org/)
- [JSON:API Specification](https://jsonapi.org/)
- [REST API Best Practices](https://restfulapi.net/)
- [OpenAPI Specification](https://swagger.io/specification/)