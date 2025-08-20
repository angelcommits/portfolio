# Development Environment Setup Workflow

## 🎯 Overview

This guide provides comprehensive workflows for setting up the Portfolio Backend development environment across different platforms and scenarios. Follow these steps to ensure a consistent, productive development experience.

## 📋 Prerequisites Checklist

### Required Software
- [ ] **Ruby 3.3.0+** (via version manager)
- [ ] **Node.js 20+** (for frontend tooling)
- [ ] **Git 2.40+** (for version control)
- [ ] **SQLite3** (development database)
- [ ] **Redis** (optional, for caching/jobs)
- [ ] **PostgreSQL 15+** (for production parity)

### Recommended Tools
- [ ] **rbenv** or **asdf** (Ruby version management)
- [ ] **nvm** or **volta** (Node version management)
- [ ] **Docker Desktop** (containerized development)
- [ ] **VS Code** or **RubyMine** (IDE)
- [ ] **Postman** or **Insomnia** (API testing)

## 🚀 Setup Workflows

### Workflow 1: macOS Development Setup

```bash
# 1. Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install development tools
brew install git postgresql@15 redis sqlite3 imagemagick

# 3. Install rbenv and Ruby
brew install rbenv ruby-build
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
source ~/.zshrc
rbenv install 3.3.0
rbenv global 3.3.0

# 4. Install Node.js via nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.zshrc
nvm install 20
nvm use 20

# 5. Clone repository
git clone [repository-url]
cd portfolio-backend

# 6. Install dependencies
bundle install
npm install

# 7. Setup database
rails db:create db:migrate db:seed

# 8. Configure environment
cp .env.example .env
# Edit .env with your settings

# 9. Start services
brew services start postgresql@15
brew services start redis

# 10. Run development server
bin/dev
```

### Workflow 2: Ubuntu/Debian Setup

```bash
# 1. Update system packages
sudo apt update && sudo apt upgrade -y

# 2. Install dependencies
sudo apt install -y curl git build-essential libssl-dev libreadline-dev \
  zlib1g-dev sqlite3 libsqlite3-dev postgresql postgresql-contrib \
  redis-server imagemagick libmagickwand-dev

# 3. Install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

# 4. Install ruby-build
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# 5. Install Ruby
rbenv install 3.3.0
rbenv global 3.3.0

# 6. Install Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# 7. Setup project
git clone [repository-url]
cd portfolio-backend
bundle install
npm install

# 8. Database setup
sudo -u postgres createuser -s $(whoami)
rails db:create db:migrate db:seed

# 9. Start services
sudo systemctl start postgresql redis-server

# 10. Run server
bin/dev
```

### Workflow 3: Docker Development Setup

```bash
# 1. Install Docker Desktop
# Download from https://www.docker.com/products/docker-desktop

# 2. Clone repository
git clone [repository-url]
cd portfolio-backend

# 3. Build Docker environment
docker-compose build

# 4. Setup database
docker-compose run web rails db:create db:migrate db:seed

# 5. Start all services
docker-compose up

# 6. Access application
# API: http://localhost:3000
# PostgreSQL: localhost:5432
# Redis: localhost:6379
```

## 🔧 Configuration Workflows

### Environment Variables Setup

```bash
# 1. Copy example file
cp .env.example .env

# 2. Generate secret keys
rails secret  # Copy output

# 3. Edit .env file
DATABASE_URL=sqlite3:db/development.sqlite3
REDIS_URL=redis://localhost:6379/0
SECRET_KEY_BASE=[your-generated-secret]
RAILS_MASTER_KEY=[from-credentials]

# 4. Setup credentials
EDITOR=vim rails credentials:edit
```

### Database Configuration

```yaml
# config/database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV['DATABASE_USERNAME'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>
  host: <%= ENV['DATABASE_HOST'] || 'localhost' %>

development:
  <<: *default
  database: portfolio_development

test:
  <<: *default
  database: portfolio_test

production:
  <<: *default
  database: portfolio_production
```

### VS Code Setup

```json
// .vscode/settings.json
{
  "ruby.useLanguageServer": true,
  "ruby.format": "rubocop",
  "ruby.lint": {
    "rubocop": true
  },
  "editor.formatOnSave": true,
  "editor.rulers": [80, 120],
  "files.associations": {
    "*.erb": "erb"
  },
  "emmet.includeLanguages": {
    "erb": "html"
  }
}
```

### Git Configuration

```bash
# 1. Configure Git
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# 2. Setup Git hooks
bundle exec overcommit --install

# 3. Configure aliases
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
```

## 🔍 Verification Workflows

### Health Check Script

```bash
#!/bin/bash
# scripts/health_check.sh

echo "🔍 Checking development environment..."

# Check Ruby
if command -v ruby &> /dev/null; then
    echo "✅ Ruby $(ruby -v | awk '{print $2}')"
else
    echo "❌ Ruby not installed"
fi

# Check Node
if command -v node &> /dev/null; then
    echo "✅ Node $(node -v)"
else
    echo "❌ Node not installed"
fi

# Check Rails
if bundle exec rails -v &> /dev/null; then
    echo "✅ Rails $(bundle exec rails -v)"
else
    echo "❌ Rails not installed"
fi

# Check Database
if rails db:version &> /dev/null; then
    echo "✅ Database connected"
else
    echo "❌ Database connection failed"
fi

# Check Redis
if redis-cli ping &> /dev/null; then
    echo "✅ Redis running"
else
    echo "⚠️  Redis not running (optional)"
fi
```

### Development Server Checklist

```bash
# 1. Start all services
bin/dev

# 2. Verify endpoints
curl http://localhost:3000/api/v1/health  # Should return 200 OK

# 3. Check Rails console
rails console
> User.count  # Should work without errors
> exit

# 4. Run tests
bundle exec rspec

# 5. Check asset compilation
rails assets:precompile
```

## 🛠️ Troubleshooting Workflows

### Common Issues Resolution

#### Bundle Install Failures
```bash
# Fix: Clear bundle cache
rm -rf vendor/bundle
bundle install --path vendor/bundle

# Fix: Update bundler
gem install bundler
bundle update --bundler
```

#### Database Connection Issues
```bash
# Fix: Reset database
rails db:drop db:create db:migrate db:seed

# Fix: Check PostgreSQL status
brew services list  # macOS
sudo systemctl status postgresql  # Linux
```

#### Port Conflicts
```bash
# Fix: Kill process on port
lsof -ti:3000 | xargs kill -9

# Fix: Use different port
PORT=3001 bin/dev
```

#### Asset Compilation Errors
```bash
# Fix: Clear cache
rails assets:clobber
rm -rf tmp/cache
npm rebuild
```

## 📊 Development Best Practices

### Daily Workflow
1. **Pull latest changes**: `git pull origin main`
2. **Update dependencies**: `bundle install && npm install`
3. **Run migrations**: `rails db:migrate`
4. **Start server**: `bin/dev`
5. **Run tests**: `bundle exec rspec`

### Branch Workflow
```bash
# 1. Create feature branch
git checkout -b feature/your-feature-name

# 2. Make changes and commit
git add .
git commit -m "feat: add new feature"

# 3. Push branch
git push origin feature/your-feature-name

# 4. Create pull request
# Use GitHub/GitLab UI
```

### Database Management
```bash
# Create migration
rails generate migration AddFieldToModel field:type

# Run specific migration
rails db:migrate:up VERSION=20240101120000

# Rollback migration
rails db:rollback STEP=1

# Reset database
rails db:drop db:create db:migrate db:seed
```

## 🔗 Next Steps

- Continue to [API Development Workflow](./02-api-development.md)
- Review [Testing Workflows](./03-testing-workflows.md)
- Explore [Frontend Integration](./04-frontend-integration.md)

## 📚 Additional Resources

- [Ruby on Rails Guides](https://guides.rubyonrails.org/)
- [rbenv Documentation](https://github.com/rbenv/rbenv)
- [Docker Documentation](https://docs.docker.com/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)