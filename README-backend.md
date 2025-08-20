# 🚀 Portfolio Backend API - Production-Ready Rails Platform

## Project Overview

A professional, production-ready Rails API backend designed to power **Portfolio as a Service** platforms. Built with modularity, scalability, and modern development practices in mind.

### 🎯 Core Purpose

- **API-First Architecture**: RESTful backend serving Next.js frontends
- **Multi-Tenant Ready**: Support for multiple portfolios with custom domains
- **Authentication Complete**: Rodauth + JWT with OAuth2 integration
- **Enterprise Features**: Background jobs, caching, real-time updates
- **AI-Ready**: Prepared for LLM agent integrations
- **Production Optimized**: Docker, CI/CD, monitoring, and scaling ready

---

## 🛠️ Technology Stack

### Core Technologies
- **Language**: Ruby 3.3.0
- **Framework**: Rails 8.0.1
- **API**: RESTful (implemented), GraphQL (planned)
- **Database**: PostgreSQL (production), SQLite (development/test)
- **Authentication**: Rodauth + JWT tokens
- **Authorization**: Pundit + Rolify
- **Background Jobs**: Solid Queue
- **Caching**: Solid Cache + Redis
- **Real-time**: ActionCable + AnyCable

### Development Tools
- **Testing**: RSpec, Capybara, Factory Bot
- **Code Quality**: RuboCop, Brakeman, SimpleCov
- **Documentation**: Swagger/OpenAPI (rswag)
- **Version Management**: ASDF
- **Containerization**: Docker + Docker Compose
- **CI/CD**: GitHub Actions (in repair)

### Frontend Integration
- **Primary**: Next.js + React + Tailwind CSS
- **Components**: ViewComponents for server-side rendering
- **Assets**: Vite for bundling
- **API Client**: Axios with interceptors

---

## 📁 Project Structure

```
portfolio-backend/
├── app/
│   ├── controllers/     # API endpoints & routing
│   ├── models/          # Domain models & business logic
│   ├── services/        # Business operations
│   ├── serializers/     # API response formatting
│   ├── policies/        # Authorization rules
│   ├── misc/           # Rodauth configuration
│   └── frontend/       # ViewComponents
├── config/
│   ├── routes.rb       # API route definitions
│   ├── database.yml    # DB configuration
│   └── initializers/   # Rails configuration
├── db/
│   ├── migrate/        # Database migrations
│   └── schema.rb       # Current DB schema
├── docs/
│   ├── workbook/       # 120+ implementation tasks
│   ├── auth/           # Authentication architecture
│   ├── roadmap/        # Project planning
│   └── workflow/       # Development processes
├── spec/               # Test suite
└── lib/               # Custom libraries & tasks
```

---

## ⚡ Quick Start

### Prerequisites

```bash
# Required
- Ruby 3.3.0+
- PostgreSQL 14+
- Redis 6+
- Node.js 18+
- Yarn 1.22+

# Optional
- Docker & Docker Compose
- ASDF for version management
```

### Installation

```bash
# Clone repository
git clone [repository-url]
cd portfolio-backend

# Install dependencies
bundle install
yarn install

# Setup database
rails db:create db:migrate db:seed

# Configure environment
cp .env.example .env
# Edit .env with your settings

# Start development server
rails server
# API available at http://localhost:3000
```

### Docker Setup

```bash
# Build and start services
docker-compose up --build

# Run migrations
docker-compose exec web rails db:migrate

# Access at http://localhost:3000
```

---

## 🔑 Key Features

### ✅ Implemented
- **Multi-tenant Architecture**: Subdomain-based portfolio isolation
- **JWT Authentication**: Secure token-based auth with refresh tokens
- **Role-Based Access**: Admin, Editor, Viewer roles with Pundit
- **RESTful API**: Complete CRUD for portfolios, projects, articles
- **File Uploads**: Active Storage with S3 support
- **Background Processing**: Solid Queue for async jobs
- **Email System**: ActionMailer with SendGrid integration

### 🚧 In Progress
- **Testing Suite**: RSpec tests being repaired (SUB-EPIC-002)
- **CI/CD Pipeline**: GitHub Actions configuration (SUB-EPIC-002)
- **API Documentation**: Swagger/OpenAPI specs
- **Admin Panel**: Embedded dashboard for management

### 📋 Planned
- **GraphQL API**: Alternative to REST endpoints
- **WebSocket Support**: Real-time updates via ActionCable
- **OAuth2 Providers**: Google, GitHub, LinkedIn login
- **Webhook System**: Event notifications
- **AI Integration**: LLM agent support
- **Analytics**: Usage tracking and reporting

---

## 📊 API Documentation

### Authentication Endpoints

```
POST   /api/v1/auth/register
POST   /api/v1/auth/login
POST   /api/v1/auth/logout
POST   /api/v1/auth/refresh
POST   /api/v1/auth/forgot-password
POST   /api/v1/auth/reset-password
```

### Portfolio Endpoints

```
GET    /api/v1/portfolios
POST   /api/v1/portfolios
GET    /api/v1/portfolios/:id
PATCH  /api/v1/portfolios/:id
DELETE /api/v1/portfolios/:id
```

### Project Endpoints

```
GET    /api/v1/portfolios/:portfolio_id/projects
POST   /api/v1/portfolios/:portfolio_id/projects
GET    /api/v1/projects/:id
PATCH  /api/v1/projects/:id
DELETE /api/v1/projects/:id
```

Full API documentation available at `/api-docs` when Swagger is configured.

---

## 🧪 Testing

```bash
# Run all tests
rspec

# Run specific test file
rspec spec/controllers/api_controller_spec.rb

# Run with coverage
RAILS_ENV=test rspec --format documentation

# Run system tests
rspec spec/system
```

---

## 🚀 Deployment

### Environment Variables

```bash
# Required
DATABASE_URL=postgresql://...
REDIS_URL=redis://...
RAILS_MASTER_KEY=...
SECRET_KEY_BASE=...

# Optional
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
SENDGRID_API_KEY=...
SENTRY_DSN=...
```

### Production Deployment

```bash
# Using Kamal (recommended)
kamal setup
kamal deploy

# Using Docker
docker build -t portfolio-backend .
docker run -p 3000:3000 portfolio-backend

# Traditional deployment
bundle exec rails assets:precompile
bundle exec rails db:migrate
bundle exec puma -C config/puma.rb
```

---

## 📚 Documentation

### Available Documentation

- **[Setup Guide](01%20SETUP.md)**: Detailed installation instructions
- **[Internal Guide](02%20INTERNAL_GUIDE.md)**: Development workflows
- **[Implementation Plan](03%20Implementation%20Plan.md)**: Project roadmap
- **[Authentication](auth/)**: Auth system architecture
- **[Workbook](workbook/)**: 120+ implementation tasks
- **[Workflows](workflow/)**: Development processes

### Documentation Consolidation

Currently undergoing documentation consolidation (SUB-EPIC-001). Legacy docs available in `docs.backup.2025-01-20/`.

---

## 🔒 Security

- **Authentication**: Rodauth with bcrypt password hashing
- **Authorization**: Pundit policies for resource access
- **API Security**: JWT tokens with expiration and refresh
- **Rate Limiting**: Rack::Attack configuration
- **CORS**: Configured for frontend domains
- **SQL Injection**: Parameterized queries throughout
- **XSS Protection**: Content Security Policy headers
- **HTTPS**: Enforced in production

---

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Write tests for your changes
4. Ensure all tests pass (`rspec`)
5. Commit changes (`git commit -m 'Add AmazingFeature'`)
6. Push to branch (`git push origin feature/AmazingFeature`)
7. Open Pull Request

### Code Standards

- Follow Ruby style guide (enforced by RuboCop)
- Write tests for all new features
- Update documentation as needed
- Keep commits atomic and well-described

---

## 📈 Project Status

### Current Phase: Stabilization (7 weeks)

- **Week 1**: Documentation Consolidation ✅
- **Week 2-3**: Testing & CI/CD Pipeline 🚧
- **Week 4**: Authentication Completion
- **Week 5-6**: Code Standardization
- **Week 7**: Production Deployment

### Metrics

- **Test Coverage**: Target >80%
- **API Response**: Target <500ms
- **Uptime Goal**: 99.9%
- **Documentation**: 100% API coverage

---

## 📝 License

[License Type] - See LICENSE file for details

---

## 👥 Team

- **Tech Lead**: Overall architecture and coordination
- **Backend Developer**: Rails API development
- **Frontend Developer**: Next.js integration
- **DevOps Engineer**: Infrastructure and deployment
- **QA Engineer**: Testing and quality assurance

---

## 📞 Support

- **Documentation**: See `/docs` directory
- **Issues**: GitHub Issues
- **Email**: [support-email]
- **Slack**: [slack-channel]

---

*Last Updated: 2025-01-20*
*Version: 1.0.0*
*Status: In Development (Stabilization Phase)*