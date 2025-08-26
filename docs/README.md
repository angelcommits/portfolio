# 📚 Portfolio Project - Master Documentation Index

> **Central hub for all project documentation - Reorganized 2025-08-24**

## 🎯 Quick Navigation

### 🚀 Essential Documents
- **[Quick Reference](./QUICK_REFERENCE.md)** - Commands, troubleshooting, quick solutions
- **[Sprint Status Dashboard](./STATUS-DASHBOARD.md)** - Current sprint progress
- **[Product Requirements](./product/product-requirements.md)** - Product specifications
- **[Development Setup](./workflows/01-development-setup.md)** - Environment configuration

## 📚 Documentation Categories

This documentation hub contains comprehensive technical, product, and development documentation for the **Portfolio as a Service** project.

### 📁 Documentation Structure

| Category | Description | Key Documents |
|----------|-------------|---------------|
| **[🏗️ Architecture](./architecture/)** | System design, DDD, database schemas | [DDD Contexts](./architecture/domain-driven-design/contexts.md) • [DB Schema](./architecture/database/schema.md) |
| **[📦 Product](./product/)** | Epics, user stories, backlog | [Master Epic](./product/epics/master-stabilization.md) • [User Stories](./product/user-stories/) |
| **[🏃 Sprints](./sprints/)** | Sprint planning, standups, reports | [Current Sprint](./sprints/current/) • [Completed Tasks](./sprints/completed/) |
| **[🧪 Testing](./testing/)** | Test guides, QA reviews | [Auth Testing](./testing/auth-testing-guide.md) • [QA Reviews](./testing/qa-reviews/) |
| **[💻 Development](./development/)** | Setup, implementation guides | [Setup](./development/01%20SETUP.md) • [Implementation](./development/02%20Implementation/) |
| **[🔄 Workflows](./workflows/)** | Git flow, development processes | [Git Flow](./workflow/GIT-FLOW-STRATEGY.md) • [DDD Pattern](./workflows/04-domain-driven-design-pattern.md) |
| **[🌐 API](./api/)** | API documentation and specs | [API Docs](./api/README.md) |
| **[📚 Resources](./resources/)** | Templates, archives, audits | [Templates](./resources/templates/) • [Archive](./resources/archive/) |

## 🎯 Current Sprint: STORY-002-002 Backend Tests

### Active Development
- **Story**: Implement Critical Backend Tests
- **Goal**: Achieve >80% test coverage
- **Status**: 15% coverage → 80% target
- **Branch**: `task/story-002-002-model-tests`

### Sprint Progress
- ✅ Test infrastructure analyzed
- ✅ Story model created
- 🔄 Fixing failing tests
- ⏳ Creating model factories
- ⏳ Writing comprehensive tests

### Documentation Reorganization Status
- ✅ **Phase 1**: Structure created
- ✅ **Phase 2**: Sprint docs moved from spec/
- ✅ **Phase 3**: Architecture docs centralized
- ✅ **Phase 4**: Product docs organized
- ✅ **Phase 5**: Obsolete files cleaned
- ✅ **Phase 6**: Master index created
- 🔄 **Phase 7**: Conventions being established

## 🚀 Quick Start by Role

### 👨‍💻 For Developers
1. **[Project Overview](./workflows/00-project-overview.md)** - Understand the project mission and architecture
2. **[Development Setup](./workflows/01-development-setup.md)** - Configure your development environment
3. **[API Development](./workflows/02-api-development.md)** - Learn API development patterns
4. **[Testing Workflows](./workflows/03-testing-workflows.md)** - Understand testing strategies

### 📋 For Product Managers
1. **[Master Epic](./product/epic-master-stabilization.md)** - Current stabilization roadmap
2. **[Brownfield PRD](./product/brownfield-prd.md)** - Product requirements for stabilization
3. **[Sub-Epics](./product/)** - Detailed epic documentation
4. **[Implementation Progress](./implementation/)** - Feature implementation status

### ⚙️ For DevOps Engineers
1. **[Development Setup](./development/01%20SETUP.md)** - Environment configuration
2. **[Architecture Overview](./architecture/brownfield-architecture.md)** - Technical architecture
3. **[Implementation Plan](./development/03%20Implementation%20Plan.md)** - Infrastructure roadmap
4. **[Quality Reports](./audit/)** - System quality assessments

### 🎨 For Designers & Frontend
1. **[Project Overview](./workflows/00-project-overview.md)** - Project context and goals
2. **[API Development](./workflows/02-api-development.md)** - API integration patterns
3. **[Implementation Guides](./implementation/core/)** - Frontend-related implementations
4. **[Development Setup](./workflows/01-development-setup.md)** - Environment setup

## 🏗️ System Components

### 🔧 Backend (Rails API)
- **Location**: `portfolio-backend/`
- **Framework**: Ruby on Rails 8.0.1
- **Status**: 🔄 Stabilization phase - Authentication migration in progress
- **Documentation**: [Architecture](./architecture/INDEX.md) | [Implementation](./implementation/core/)

### 🎨 Frontend (Next.js)
- **Location**: `portfolio-frontend/`
- **Framework**: Next.js with React
- **Status**: ✅ Functional - Requires authentication integration
- **Documentation**: [Workflows](./workflows/02-api-development.md)

### 📱 SMS Service (Twilio)
- **Location**: `sms-consumer/`
- **Purpose**: SMS/WhatsApp messaging service
- **Status**: 🧪 Experimental sandbox environment
- **Documentation**: [Implementation](./implementation/future/)

## 📊 Quick Status

### Testing Coverage Progress
| Component | Current | Target | Status |
|-----------|---------|--------|--------|
| Models | ~40% | >90% | 🔄 In Progress |
| Controllers | 0% | >80% | 🔴 Blocked |
| Services | ~5% | >85% | 🔴 Not Started |
| **Overall** | ~15% | >80% | 🔄 Active Development |

### Recent Documentation Updates (2025-08-24)
- ✅ Moved all sprint docs from `spec/` to proper locations
- ✅ Centralized architecture documentation
- ✅ Organized product management docs
- ✅ Created comprehensive index structure
- ✅ Cleaned obsolete files and backups

## 🛠️ Technology Stack

### Core Technologies
- **Backend**: Ruby on Rails 8.0.1 with modern Rails features
- **Frontend**: Next.js with React and TypeScript
- **Database**: PostgreSQL 14+ (production), SQLite (development)
- **Cache**: Redis with Solid Cache for Rails 8
- **Authentication**: Rodauth (migrating from Devise)

### Development & Operations
- **Testing**: RSpec, FactoryBot, Jest, Cypress
- **CI/CD**: GitHub Actions (in development)
- **Deployment**: Docker with Kamal
- **Background Jobs**: Solid Queue
- **Monitoring**: DataDog integration (planned)
- **Code Quality**: RuboCop, Brakeman, ESLint

## 📋 Documentation Standards

### Documentation Format
- **Format**: Markdown (.md) for all documentation
- **Structure**: Consistent header hierarchy (H1-H6)
- **Code Blocks**: Language-tagged code blocks with syntax highlighting
- **Links**: Relative links within docs, absolute for external resources
- **Navigation**: Comprehensive index files for each category

### Code Standards
- **Backend**: RuboCop, Rails best practices, Brakeman security scanning
- **Frontend**: ESLint, Prettier, TypeScript strict mode
- **Commits**: Conventional Commits specification
- **Branches**: `feature/*`, `bugfix/*`, `hotfix/*`, `docs/*`
- **Testing**: TDD approach with comprehensive test coverage

## 🤝 Contributing

### Documentation Contributions
1. **New Features**: Include comprehensive documentation with all new functionality
2. **Updates**: Update relevant indexes when adding new documents
3. **Standards**: Follow established templates and formatting standards
4. **Synchronization**: Keep documentation synchronized with code changes
5. **Review**: All documentation changes require peer review

### Code Contributions
1. **Setup**: Follow the [Development Setup Guide](./workflows/01-development-setup.md)
2. **Patterns**: Review [API Development Workflows](./workflows/02-api-development.md)
3. **Testing**: Implement comprehensive tests following [Testing Workflows](./workflows/03-testing-workflows.md)
4. **Quality**: Ensure code passes all quality gates and standards

## 📞 Support & Contact

### Getting Help
1. **Quick Issues**: Check [Quick Reference Guide](./QUICK_REFERENCE.md)
2. **Setup Problems**: Review [Development Setup](./workflows/01-development-setup.md)
3. **Implementation Questions**: Consult [Implementation Guides](./implementation/)
4. **Architecture Queries**: Reference [Architecture Documentation](./architecture/)

### Project Information
- **Project Owner**: Angel Szymczak
- **Repository**: `/portfolio/`
- **Documentation**: `/docs/`
- **Issues**: Create GitHub Issues for bug reports and feature requests

## 🔗 Essential Links

### Key Documents
- **[Master Documentation Index](./INDEX.md)** - Complete documentation overview
- **[Master Stabilization Epic](./product/epic-master-stabilization.md)** - Current project roadmap
- **[Brownfield Architecture](./architecture/brownfield-architecture.md)** - Technical architecture blueprint
- **[Quick Reference Guide](./QUICK_REFERENCE.md)** - Essential commands and troubleshooting

### External Resources
- **[Ruby on Rails 8.0 Guides](https://guides.rubyonrails.org/)** - Rails framework documentation
- **[Next.js Documentation](https://nextjs.org/docs)** - Frontend framework guides
- **[Rodauth Documentation](https://rodauth.jeremyevans.net/)** - Authentication framework
- **[PostgreSQL Documentation](https://www.postgresql.org/docs/)** - Database documentation

---

**Last Updated**: January 20, 2025  
**Documentation Version**: 2.0.0  
**Project Phase**: Master Stabilization Epic - Phase 3 (Quality Improvements)  
**Status**: Active development with comprehensive documentation