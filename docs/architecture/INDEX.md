# Architecture Documentation Index

## 🎯 Overview

This directory contains comprehensive architectural documentation for the Portfolio as a Service project. It includes system design documents, technical specifications, and architecture patterns used throughout the application.

## 📁 Directory Structure

- **`auth/`** - Authentication and authorization architecture
- **`ai-integration/`** - AI/LLM integration patterns and specifications
- **`brownfield-architecture.md`** - Current system stabilization architecture

## 🏗️ Core Architecture Documents

### System Architecture
- **[Brownfield Architecture](./brownfield-architecture.md)** - Current stabilization approach and technical blueprint for migrating to production-ready state

### Authentication & Security
- **[Authentication Summary](./auth/01%20summary.md)** - Overview of authentication system design
- **[Authentication Architecture](./auth/02%20architecture.md)** - Detailed authentication architecture with Rodauth
- **[Multi-Channel Design](./auth/multi-channel-design.md)** - Multi-channel authentication patterns
- **[OAuth Integration Design](./auth/oauth-integration-design.md)** - OAuth 2.0 integration architecture
- **[OTP System Design](./auth/otp-system-design.md)** - One-Time Password system architecture

### AI & LLM Integration
- **[DDD Rails Backend Structure](./ai-integration/000%20Estructura_DDD_Rails_Backend.md)** - Domain-Driven Design structure for Rails backend
- **[GPT Integration Structure](./ai-integration/001%20Estructura_DDD_Rails_Backend_GPT.md)** - GPT integration within DDD architecture
- **[OLLAMA Integration](./ai-integration/002%20Explicacion_Arquitectura_e_Integracion_OLLAMA.md)** - OLLAMA architecture and integration explanation
- **[GPT Implementation Checklist](./ai-integration/003%20Checklist_Implementacion_GPT_Completo.md)** - Complete GPT implementation checklist
- **[Updated Backend Architecture](./ai-integration/004%20Arquitectura_Backend_Actualizada_GPT_Rails_OLAMA.md)** - Updated backend architecture with GPT and OLLAMA
- **[GPT System Roadmap](./ai-integration/005%20Roadmap_Completo_GPT_System.md)** - Complete GPT system implementation roadmap

## 🏛️ Architectural Patterns

### Domain-Driven Design (DDD)
The system follows Domain-Driven Design principles with the following structure:

```
app/
├── adapters/          # External service adapters
├── contexts/          # Bounded contexts
├── controllers/       # HTTP interface layer
├── models/           # Domain models and entities
├── services/         # Domain services
├── use_cases/        # Application use cases
└── policies/         # Authorization policies
```

### Authentication Architecture
- **Primary**: Rodauth for modern Ruby authentication
- **OAuth**: Configurable OAuth providers (Google, GitHub, etc.)
- **MFA**: Multi-factor authentication with TOTP and SMS
- **Sessions**: JWT tokens with refresh token support
- **Authorization**: Pundit policies with role-based access control

### Data Architecture
- **Primary Database**: PostgreSQL with Active Record
- **Development**: SQLite for local development
- **Caching**: Redis with Solid Cache for Rails 8
- **Background Jobs**: Solid Queue for async processing
- **File Storage**: Active Storage with S3 in production

### API Architecture
- **REST API**: Standard RESTful endpoints
- **GraphQL**: GraphQL API with subscriptions
- **WebSockets**: ActionCable with AnyCable for scaling
- **Webhooks**: Native Rails webhooks with Karafka/Redpanda

## 🔒 Security Architecture

### Authentication Flow
1. **Primary Auth**: Rodauth with configurable features
2. **OAuth Integration**: Social login support
3. **MFA Support**: TOTP and SMS verification
4. **Session Management**: JWT with refresh tokens
5. **Password Security**: Argon2 hashing with secure defaults

### Authorization Model
- **Policy-Based**: Pundit policies for resource access control
- **Role-Based**: Rolify for user role management
- **Row-Level Security**: PostgreSQL RLS for data isolation
- **API Security**: JWT validation and rate limiting

### Data Protection
- **Encryption**: Database encryption at rest
- **Transport Security**: TLS 1.3 for all communications
- **Secret Management**: Rails credentials with environment-specific keys
- **Audit Logging**: Comprehensive audit trail for security events

## 🌐 Integration Architecture

### External Services
- **AI/LLM**: OLLAMA and GPT integration through adapters
- **Email**: Action Mailer with configurable providers
- **SMS/WhatsApp**: Twilio integration for notifications
- **File Storage**: S3-compatible storage with Active Storage
- **Monitoring**: DataDog integration for metrics and logging

### Message Queue Architecture
- **Background Jobs**: Solid Queue for reliable job processing
- **Real-time**: ActionCable for WebSocket connections
- **Event Streaming**: Karafka/Redpanda for event-driven architecture
- **Webhooks**: Secure webhook delivery with HMAC signatures

## 🚀 Deployment Architecture

### Infrastructure
- **Containerization**: Docker with multi-stage builds
- **Orchestration**: Kamal for deployment automation
- **Database**: PostgreSQL 14+ with connection pooling
- **Cache**: Redis for session storage and caching
- **CDN**: Asset delivery through CDN with Active Storage

### CI/CD Pipeline
- **Testing**: RSpec, FactoryBot, and Cypress
- **Quality**: RuboCop, Brakeman security scanning
- **Deployment**: GitHub Actions with automated testing
- **Infrastructure**: Terraform/Pulumi for infrastructure as code

### Monitoring & Observability
- **Application Monitoring**: DataDog APM
- **Log Aggregation**: Centralized logging with Lograge
- **Metrics**: Prometheus and Grafana for system metrics
- **Error Tracking**: Integrated error monitoring and alerting

## 📊 Performance Architecture

### Caching Strategy
- **Application Cache**: Solid Cache with Redis backend
- **Fragment Caching**: Rails fragment caching for views
- **HTTP Caching**: ETags and conditional requests
- **Database**: Query optimization and connection pooling

### Scaling Considerations
- **Horizontal Scaling**: Stateless application design
- **Database Scaling**: Read replicas and connection pooling
- **Background Jobs**: Queue scaling with Solid Queue
- **WebSockets**: AnyCable for WebSocket scaling

## 🔄 Migration Architecture

### Brownfield Approach
The current architecture follows a brownfield migration strategy:

1. **Stabilization Phase**: Fix existing issues and improve quality
2. **Testing Phase**: Comprehensive test coverage implementation
3. **Authentication Phase**: Complete Rodauth migration
4. **Standardization Phase**: Code quality and architectural improvements
5. **Production Phase**: Final production readiness

### Data Migration
- **Schema Evolution**: Incremental database migrations
- **Data Integrity**: Validation and rollback capabilities
- **Zero Downtime**: Blue-green deployment strategies
- **Backup Strategy**: Automated backups with point-in-time recovery

## 📚 Related Documentation

### Implementation Guides
- **[Core Implementation](../implementation/core/)** - Step-by-step implementation guides
- **[Future Features](../implementation/future/)** - Advanced feature implementations

### Development Resources
- **[Workflows](../workflows/)** - Development processes and best practices
- **[Development Setup](../development/)** - Environment setup and configuration

### Product Documentation
- **[Product Requirements](../product/)** - Business requirements and specifications
- **[Epic Documentation](../product/epic-master-stabilization.md)** - Current project roadmap

## 🛠️ Architecture Decisions

### Technology Stack
- **Backend**: Ruby on Rails 8.0.1 with modern Rails features
- **Database**: PostgreSQL 14+ for reliability and performance
- **Frontend**: Next.js with React for modern web applications
- **Authentication**: Rodauth for flexible authentication patterns
- **Deployment**: Docker + Kamal for simplified deployment

### Design Principles
1. **Domain-Driven Design**: Clear domain boundaries and models
2. **Security by Design**: Security considerations in every architectural decision
3. **Performance First**: Caching and optimization built into the architecture
4. **Scalability**: Horizontal scaling capabilities from the start
5. **Maintainability**: Clear separation of concerns and testable design

## 🔍 Architecture Reviews

### Current Status
- **Phase**: Master Stabilization Epic - Documentation Quality Improvements
- **Focus**: Architecture documentation consolidation and standardization
- **Next**: Testing infrastructure and CI/CD improvements

### Review Schedule
- **Weekly**: Architecture review sessions during active development
- **Monthly**: Comprehensive architecture assessment
- **Quarterly**: Technology stack and pattern review

---

**Last Updated**: January 20, 2025  
**Architecture Version**: 2.0.0  
**Review Status**: Active development phase