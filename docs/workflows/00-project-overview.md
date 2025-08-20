# Portfolio Backend - Project Overview & Quick Start Guide

## 🎯 Project Mission

The Portfolio Backend is a modern Ruby on Rails 8.0.1 application designed to power a professional portfolio and personal brand website. Built with scalability, maintainability, and developer experience in mind, it serves as both a showcase of technical expertise and a production-ready platform.

## 🏗️ Architecture Overview

### Technology Stack
- **Backend**: Ruby on Rails 8.0.1
- **Frontend**: React with Vite bundling
- **Database**: SQLite (dev) / PostgreSQL (prod)
- **Authentication**: Rodauth
- **Authorization**: Pundit (planned)
- **Testing**: RSpec + Factory Bot
- **API**: RESTful v1 with serialization
- **AI Integration**: Ollama adapter for LLM capabilities

### Architectural Patterns
- **Hybrid Architecture**: MVC transitioning to Domain-Driven Design (DDD)
- **Modular Domains**: Clear bounded contexts for different business areas
- **API-First Design**: Versioned REST API for frontend consumption
- **Component-Based UI**: ViewComponent + React hybrid approach

### Domain Structure
```
domains/
├── site/        # Core portfolio functionality
├── portfolio/   # Projects and technologies
├── blog/        # Article management
├── iam/         # Identity & Access Management
└── inference/   # AI/LLM integration
```

## 🚀 Quick Start Guide

### Prerequisites
- Ruby 3.3.0+ (via rbenv or asdf)
- Node.js 20+ (for frontend tooling)
- SQLite3 (development)
- Redis (optional, for caching)
- Git

### 15-Minute Setup

1. **Clone and Enter Directory**
   ```bash
   git clone [repository-url]
   cd portfolio-backend
   ```

2. **Install Dependencies**
   ```bash
   # Install Ruby gems
   bundle install
   
   # Install Node packages
   npm install
   ```

3. **Setup Database**
   ```bash
   # Create and migrate database
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. **Configure Environment**
   ```bash
   # Copy example env file
   cp .env.example .env
   
   # Generate credentials
   EDITOR=vim rails credentials:edit
   ```

5. **Start Development Server**
   ```bash
   # Start Rails and Vite in one command
   bin/dev
   ```

6. **Verify Installation**
   - Backend API: http://localhost:3000/api/v1/health
   - Frontend: http://localhost:3000
   - Rails Console: `rails console`

## 📁 Project Structure

```
portfolio-backend/
├── app/
│   ├── controllers/     # Request handling
│   ├── models/          # ActiveRecord models
│   ├── domains/         # DDD bounded contexts
│   ├── services/        # Business logic
│   ├── serializers/     # API response formatting
│   ├── components/      # ViewComponents
│   └── frontend/        # React components
├── config/
│   ├── routes/          # Modular routing
│   └── initializers/    # App configuration
├── spec/                # RSpec tests
├── db/                  # Database files
└── .docs/               # Documentation
```

## 🔑 Key Features

### Current Features
- **Multi-domain Architecture**: Modular design for scalability
- **API Versioning**: Future-proof API design
- **Modern Frontend**: React + Vite for optimal DX
- **Authentication Ready**: Rodauth integration
- **Test Infrastructure**: RSpec setup with factories

### In Development
- **DDD Migration**: Transitioning to full Domain-Driven Design
- **API Documentation**: OpenAPI/Swagger specs
- **CI/CD Pipeline**: GitHub Actions automation
- **Performance Monitoring**: APM integration

### Planned Features
- **SuperClaude Integration**: AI-powered development assistance
- **GraphQL API**: Alternative to REST endpoints
- **Real-time Features**: ActionCable integration
- **Multi-tenancy**: Organization support

## 🎯 Development Philosophy

### Core Principles
1. **Developer Experience First**: Fast feedback loops, clear patterns
2. **Production-Ready**: Security, performance, and reliability built-in
3. **Modular Design**: Easy to extend and maintain
4. **Test-Driven**: Comprehensive test coverage
5. **Documentation-Driven**: Clear guides for every workflow

### Code Standards
- **Ruby Style**: RuboCop with custom rules
- **JavaScript**: ESLint + Prettier
- **Git Flow**: Feature branches with PR reviews
- **Commit Convention**: Conventional commits

## 🔗 Quick Links

- [Development Setup](./01-development-setup.md)
- [API Development Guide](./02-api-development.md)
- [Testing Workflows](./03-testing-workflows.md)
- [Deployment Guide](./04-deployment.md)
- [Contributing Guidelines](./05-contributing.md)

## 📊 Project Metrics

### Current State
- **Rails Version**: 8.0.1
- **Ruby Version**: 3.3.0+
- **Test Coverage**: Setting up
- **API Endpoints**: 15+ RESTful routes
- **Domains**: 5 bounded contexts

### Performance Targets
- **API Response**: <100ms average
- **Page Load**: <3s on 3G
- **Test Suite**: <5 minutes
- **Deploy Time**: <10 minutes

## 🆘 Getting Help

### Resources
- **Project Docs**: `.docs/workbook/`
- **API Docs**: Coming soon
- **Issue Tracker**: GitHub Issues
- **Discussion**: GitHub Discussions

### Common Issues
1. **Bundle Install Fails**: Check Ruby version with `ruby -v`
2. **Database Errors**: Run `rails db:reset`
3. **Port in Use**: Change port with `PORT=3001 bin/dev`
4. **Asset Compilation**: Clear with `rails assets:clobber`

## 🎉 Next Steps

1. Complete the [Development Setup](./01-development-setup.md)
2. Explore the [API Development Guide](./02-api-development.md)
3. Review [Testing Workflows](./03-testing-workflows.md)
4. Check [Contributing Guidelines](./05-contributing.md)

Welcome to the Portfolio Backend project! 🚀