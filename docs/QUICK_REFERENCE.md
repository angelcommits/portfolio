# Quick Reference Guide

## 🚀 Essential Commands

### Development Environment

```bash
# Start Rails backend
cd portfolio-backend
bundle install
rails db:migrate
rails server

# Start Next.js frontend
cd portfolio-frontend
npm install
npm run dev

# Start both with Docker
docker-compose up
```

### Database Operations

```bash
# Create and setup database
rails db:create
rails db:migrate
rails db:seed

# Reset database
rails db:drop db:create db:migrate db:seed

# Run specific migration
rails db:migrate:up VERSION=20250119000001
```

### Testing Commands

```bash
# Run all tests
rspec

# Run specific test
rspec spec/controllers/api_controller_spec.rb

# Run with coverage
RAILS_ENV=test rspec --format documentation

# Frontend tests
npm test
npm run test:e2e
```

### Git Workflow

```bash
# Create feature branch
git checkout -b feature/your-feature-name

# Commit with conventional format
git add .
git commit -m "feat: add new feature"
# Types: feat, fix, docs, style, refactor, test, chore

# Push and create PR
git push -u origin feature/your-feature-name
```

## 📁 Key File Locations

### Backend Structure
```
portfolio-backend/
├── app/
│   ├── controllers/    # API endpoints
│   ├── models/         # Domain models
│   ├── services/       # Business logic
│   ├── serializers/    # JSON formatting
│   └── policies/       # Authorization
├── config/
│   ├── routes.rb       # API routes
│   ├── database.yml    # DB config
│   └── initializers/   # App config
├── db/
│   ├── migrate/        # Migrations
│   └── schema.rb       # Current schema
└── spec/              # Test files
```

### Frontend Structure
```
portfolio-frontend/
├── src/
│   ├── components/     # React components
│   ├── pages/         # Next.js pages
│   ├── services/      # API calls
│   ├── hooks/         # Custom hooks
│   └── utils/         # Helpers
├── public/            # Static files
└── tests/            # Test files
```

### Documentation
```
docs/
├── architecture/      # System design
├── implementation/    # Task guides
│   ├── core/         # 001-035 (current)
│   └── future/       # 036-120 (planned)
├── workflows/        # Dev processes
└── product/         # Requirements
```

## 🔧 Common Workflows

### 1. Add New API Endpoint

```ruby
# 1. Add route (config/routes.rb)
namespace :api do
  namespace :v1 do
    resources :items
  end
end

# 2. Create controller (app/controllers/api/v1/items_controller.rb)
class Api::V1::ItemsController < ApiController
  def index
    items = Item.all
    render json: items
  end
end

# 3. Add tests (spec/controllers/api/v1/items_controller_spec.rb)
# 4. Update API documentation
```

### 2. Add Database Migration

```bash
# Generate migration
rails generate migration AddFieldToModel field:type

# Edit migration file
# Run migration
rails db:migrate

# Test rollback
rails db:rollback
```

### 3. Implement New Feature

1. Create feature branch
2. Write tests first (TDD)
3. Implement feature
4. Run tests
5. Update documentation
6. Create pull request

## 🐛 Troubleshooting

### Common Issues

#### Database Connection Error
```bash
# Check PostgreSQL is running
pg_ctl status

# Start PostgreSQL
pg_ctl start

# Check database.yml configuration
# Verify DATABASE_URL in .env
```

#### Bundle Install Fails
```bash
# Update bundler
gem update bundler

# Clear bundle cache
rm -rf vendor/bundle
bundle install --path vendor/bundle
```

#### Port Already in Use
```bash
# Find process using port 3000
lsof -i :3000

# Kill process
kill -9 <PID>

# Or use different port
rails server -p 3001
```

#### Test Database Issues
```bash
# Reset test database
RAILS_ENV=test rails db:drop db:create db:migrate

# Clear test logs
rm log/test.log
```

#### Docker Issues
```bash
# Rebuild containers
docker-compose down
docker-compose build --no-cache
docker-compose up

# Clear Docker cache
docker system prune -a
```

## 🔑 Environment Variables

### Required (.env file)
```bash
# Database
DATABASE_URL=postgresql://user:pass@localhost/portfolio_dev

# Redis
REDIS_URL=redis://localhost:6379

# Rails
RAILS_MASTER_KEY=<your-key>
SECRET_KEY_BASE=<your-secret>

# API Keys (optional)
SENDGRID_API_KEY=<key>
TWILIO_ACCOUNT_SID=<sid>
TWILIO_AUTH_TOKEN=<token>
```

## 📚 Useful Links

### Project Documentation
- [Master Index](./INDEX.md)
- [Development Setup](./development/01%20SETUP.md)
- [API Development](./workflows/02-api-development.md)
- [Testing Guide](./workflows/03-testing-workflows.md)

### External Resources
- [Rails Guides](https://guides.rubyonrails.org/)
- [Next.js Docs](https://nextjs.org/docs)
- [RSpec Docs](https://rspec.info/)
- [Docker Docs](https://docs.docker.com/)

## 💡 Tips & Best Practices

### Code Quality
- Run RuboCop before committing: `rubocop -a`
- Check security with Brakeman: `brakeman`
- Maintain >80% test coverage
- Use conventional commit messages

### Performance
- Use `includes` to avoid N+1 queries
- Implement caching for expensive operations
- Use background jobs for long-running tasks
- Monitor with `rails console` and `rails dbconsole`

### Security
- Never commit secrets or API keys
- Use strong parameters in controllers
- Implement proper authentication/authorization
- Keep dependencies updated: `bundle update`

---

*Quick Reference Guide v1.0.0*
*Last Updated: 2025-01-20*