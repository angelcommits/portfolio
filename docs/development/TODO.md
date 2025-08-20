# Phase 1: Analysis y Diagnosys

📝 Custom

1. change boilerplate-app por portfolio


## Task 01: Current state Deep Analysis

🚨 Immediate Priorities

1. Replace SQLite → PostgreSQL for production readiness
2. Implement API authentication → Security critical
3. Expand test suite → Target 80% coverage
4. Complete DDD patterns → Repositories, value objects
5. Add monitoring → APM, logging, metrics

# 🎯 SuperClaude Commands - Portfolio Backend Workbook

*Instrucciones secuenciales basadas en análisis del proyecto y roadmap existente.*

---

## 📋 **Fase 1: Setup y Infraestructura**

### Tarea 001: Setup Automático del Proyecto
- **Prompt**: `/sc:implement "automated project setup script" --type infrastructure --framework rails --persona backend --with-tests`
- **Persona**: backend
- **Resultado Esperado**: 
  - Script `bin/setup` completamente funcional
  - Validación de dependencias (Ruby, Docker, PostgreSQL)
  - Configuración automática de `.env` desde template
- **Commit**: `feat: add automated project bootstrap script [SC #001]`

### Tarea 002: Configuración GitHub Actions
- **Prompt**: `/sc:implement "CI/CD pipeline with GitHub Actions" --type cicd --framework rails --persona devops --delegate files`
- **Persona**: devops  
- **Resultado Esperado**:
  - Pipeline completo CI/CD
  - Tests automáticos en PRs
  - Deploy staging/production
- **Commit**: `feat: implement comprehensive CI/CD pipeline [SC #002]`

### Tarea 003: Documentación Setup
- **Prompt**: `/sc:implement ".docs/setup.md comprehensive guide" --type documentation --persona scribe --format markdown`
- **Persona**: scribe
- **Resultado Esperado**:
  - Guía paso a paso de instalación
  - Troubleshooting común
  - Configuración multi-plataforma
- **Commit**: `docs: create comprehensive setup documentation [SC #003]`

---

## 📋 **Fase 2: Autenticación y Autorización**

### Tarea 004: Implementar Sistema OAuth2 + JWT
- **Prompt**: `/sc:implement ".docs/workbook/  │ │  003.00 | Implementar Autenticación con Rodauth + OAuth (configurable por entorno).md" --type authentication --framework rails --persona security --c7`
- **Persona**: security
- **Resultado Esperado**:
  - Rodauth configurado con JWT
  - OAuth2 providers integrados
  - Middleware de autenticación
- **Commit**: `feat: implement OAuth2 + JWT authentication system [SC #004]`

### Tarea 005: Modelo Account + User
- **Prompt**: `/sc:implement ".docs/workbook/002 | User Account Model.md" --type model --framework rails --persona backend --with-tests`
- **Persona**: backend
- **Resultado Esperado**:
  - Modelos Account y User con relaciones
  - Validaciones personalizadas
  - Factory Bot configurations
- **Commit**: `feat: create Account and User models with relationships [SC #005]`

### Tarea 006: Sistema de Roles con Pundit
- **Prompt**: `/sc:implement ".docs/workbook/004 | Pundit Authorization.md" --type authorization --framework rails --persona security --delegate auto`
- **Persona**: security
- **Resultado Esperado**:
  - Policies para cada dominio
  - Role-based access control
  - Tests de autorización
- **Commit**: `feat: implement role-based authorization with Pundit [SC #006]`

### Tarea 007: Registro y Validaciones
- **Prompt**: `/sc:implement ".docs/workbook/005 | User Registration.md" --type feature --framework rails --persona backend --with-tests`
- **Persona**: backend
- **Resultado Esperado**:
  - Sistema completo de registro
  - Validaciones custom
  - Email confirmation workflow
- **Commit**: `feat: implement user registration with validations [SC #007]`

---

## 📋 **Fase 3: Arquitectura DDD Core**

### Tarea 008: Diseño Arquitectura Site Domain
- **Prompt**: `/sc:design "Site domain bounded context architecture" --type architecture --format spec --iterative --persona architect`
- **Persona**: architect
- **Resultado Esperado**:
  - Diagrama de bounded contexts
  - Aggregate design documents
  - Migration plan MVC→DDD
- **Commit**: `docs: design Site domain architecture with DDD patterns [SC #008]`

### Tarea 009: Implementar Site::Hero Aggregate
- **Prompt**: `/sc:implement "Site::Hero aggregate with DDD patterns" --type domain --framework rails --persona architect --c7 --sequential`
- **Persona**: architect
- **Resultado Esperado**:
  - Hero como aggregate root
  - Domain services para business logic
  - Repository pattern implementation
- **Commit**: `refactor: implement Site::Hero aggregate with DDD [SC #009]`

### Tarea 010: Portfolio Bounded Context
- **Prompt**: `/sc:implement "Portfolio bounded context separation" --type refactor --framework rails --persona architect --delegate auto --concurrency 5`
- **Persona**: architect
- **Resultado Esperado**:
  - Portfolio como contexto independiente
  - Clear boundaries entre dominios
  - Shared kernel definido
- **Commit**: `refactor: extract Portfolio bounded context [SC #010]`

### Tarea 011: Value Objects Implementation
- **Prompt**: `/sc:implement "Contact and SocialLinks value objects" --type domain --framework rails --persona backend --with-tests`
- **Persona**: backend
- **Resultado Esperado**:
  - Value objects inmutables
  - Encapsulation de business rules
  - Type safety mejorado
- **Commit**: `feat: implement Contact and SocialLinks value objects [SC #011]`

---

## 📋 **Fase 4: API y Serialización**

### Tarea 012: API V1 Core Endpoints
- **Prompt**: `/sc:implement "API v1 endpoints with serialization" --type api --framework rails --persona backend --c7 --sequential`
- **Persona**: backend
- **Resultado Esperado**:
  - REST endpoints completos
  - ActiveModel::Serializer setup
  - Versioning strategy
- **Commit**: `feat: implement API v1 core endpoints with serialization [SC #012]`

### Tarea 013: Sistema de Paginación
- **Prompt**: `/sc:implement "pagination and filtering system" --type feature --framework rails --persona backend --delegate files`
- **Persona**: backend
- **Resultado Esperado**:
  - Kaminari integration
  - Query object pattern
  - Performance optimized
- **Commit**: `feat: add pagination and filtering to API endpoints [SC #013]`

### Tarea 014: Portfolio CRUD API
- **Prompt**: `/sc:implement ".docs/workbook/014 | Portfolio CRUD.md" --type api --framework rails --persona backend --with-tests`
- **Persona**: backend
- **Resultado Esperado**:
  - Complete CRUD operations
  - Proper HTTP status codes
  - Input validation
- **Commit**: `feat: implement Portfolio CRUD API endpoints [SC #014]`

### Tarea 015: Sistema de Alertas API
- **Prompt**: `/sc:implement ".docs/workbook/015 | Alert System.md" --type feature --framework rails --persona backend --delegate auto`
- **Persona**: backend
- **Resultado Esperado**:
  - Internal notification system
  - Real-time updates capability
  - User preference management
- **Commit**: `feat: implement internal alerts and notifications system [SC #015]`

---

## 📋 **Fase 5: Testing y Calidad**

### Tarea 016: RSpec Infrastructure
- **Prompt**: `/sc:implement "RSpec test suite with full coverage" --type testing --framework rspec --persona analyzer --c7`
- **Persona**: analyzer
- **Resultado Esperado**:
  - RSpec setup completo
  - FactoryBot configurations
  - Test helpers y matchers
- **Commit**: `test: setup comprehensive RSpec testing infrastructure [SC #016]`

### Tarea 017: Contract Testing
- **Prompt**: `/sc:implement "contract testing with rswag" --type testing --framework rspec --persona backend --delegate files`
- **Persona**: backend
- **Resultado Esperado**:
  - rswag gem integrado
  - OpenAPI documentation automática
  - API contract validation
- **Commit**: `test: implement contract testing with rswag [SC #017]`

### Tarea 018: Coverage y Performance
- **Prompt**: `/sc:improve "test coverage and performance optimization" --type optimization --persona analyzer --delegate auto`
- **Persona**: analyzer
- **Resultado Esperado**:
  - SimpleCov integration
  - Performance benchmarks
  - Code quality metrics
- **Commit**: `test: improve coverage and performance optimization [SC #018]`

---

## 📋 **Fase 6: Features Avanzadas**

### Tarea 019: Navegación Condicional
- **Prompt**: `/sc:implement ".docs/workbook/007 | Conditional Navigation.md" --type feature --framework rails --persona frontend --magic`
- **Persona**: frontend
- **Resultado Esperado**:
  - Navigation based on session state
  - Dynamic menu rendering
  - Responsive design patterns
- **Commit**: `feat: implement conditional navigation system [SC #019]`

### Tarea 020: Verificación Email
- **Prompt**: `/sc:implement ".docs/workbook/009 | Email Verification.md" --type feature --framework rails --persona backend --c7`
- **Persona**: backend
- **Resultado Esperado**:
  - Email verification workflow
  - Token-based confirmation
  - Mailer templates
- **Commit**: `feat: implement email verification for new users [SC #020]`

### Tarea 021: Password Recovery
- **Prompt**: `/sc:implement ".docs/workbook/010 | Password Recovery.md" --type feature --framework rails --persona security --with-tests`
- **Persona**: security
- **Resultado Esperado**:
  - Secure password reset flow
  - Time-limited tokens
  - Security audit trail
- **Commit**: `feat: implement secure password recovery system [SC #021]`

### Tarea 022: Multi-Device Logout
- **Prompt**: `/sc:implement ".docs/workbook/012 | Multi-Device Logout.md" --type feature --framework rails --persona security --delegate auto`
- **Persona**: security
- **Resultado Esperado**:
  - Session management across devices
  - JWT token invalidation
  - Security dashboard
- **Commit**: `feat: implement multi-device session management [SC #022]`

### Tarea 023: User Profile Panel
- **Prompt**: `/sc:implement ".docs/workbook/013 | User Profile Panel.md" --type feature --framework rails --persona frontend --magic --c7`
- **Persona**: frontend
- **Resultado Esperado**:
  - Complete profile management
  - Personal data updates
  - Privacy settings
- **Commit**: `feat: implement comprehensive user profile panel [SC #023]`

---

## 📋 **Fase 7: SuperClaude Integration**

### Tarea 024: Workbook Parser
- **Prompt**: `/sc:implement "SuperClaude workbook task parser" --type ai-integration --framework rails --persona architect --all-mcp`
- **Persona**: architect
- **Resultado Esperado**:
  - Markdown workbook parser
  - Task queue integration
  - Execution context builder
- **Commit**: `feat: implement SuperClaude workbook parser [SC #024]`

### Tarea 025: AI Task Queue
- **Prompt**: `/sc:implement "automated task execution system" --type automation --framework rails --persona backend --delegate auto --concurrency 7`
- **Persona**: backend
- **Resultado Esperado**:
  - Background job processing
  - Task dependency management
  - Execution monitoring
- **Commit**: `feat: implement AI-driven task automation system [SC #025]`

### Tarea 026: LLM Agent Interface
- **Prompt**: `/sc:implement "LLM agent integration interface" --type ai-integration --framework rails --persona architect --all-mcp --sequential`
- **Persona**: architect
- **Resultado Esperado**:
  - SuperClaude API integration
  - Workflow execution engine
  - Error handling and recovery
- **Commit**: `feat: implement LLM agent integration interface [SC #026]`

---

## 📋 **Fase 8: Optimización y Escalabilidad**

### Tarea 027: Performance Optimization
- **Prompt**: `/sc:improve "database queries and caching strategy" --type optimization --framework rails --persona backend --c7`
- **Persona**: backend
- **Resultado Esperado**:
  - Query optimization
  - Redis caching layer
  - N+1 query elimination
- **Commit**: `perf: optimize database queries and implement caching [SC #027]`

### Tarea 028: Security Hardening
- **Prompt**: `/sc:analyze "security vulnerabilities and hardening" --type security --framework rails --persona security --output security-audit`
- **Persona**: security
- **Resultado Esperado**:
  - Security audit report
  - Vulnerability fixes
  - Penetration testing setup
- **Commit**: `security: implement comprehensive security hardening [SC #028]`

### Tarea 029: Multi-Tenancy Setup
- **Prompt**: `/sc:implement "multi-tenant architecture foundation" --type architecture --framework rails --persona architect --delegate auto`
- **Persona**: architect
- **Resultado Esperado**:
  - Tenant isolation strategy
  - Database partitioning
  - Subdomain routing
- **Commit**: `feat: implement multi-tenancy architecture foundation [SC #029]`

### Tarea 030: Monitoring y Observability
- **Prompt**: `/sc:implement "monitoring and observability stack" --type infrastructure --framework rails --persona devops --delegate files`
- **Persona**: devops
- **Resultado Esperado**:
  - Application metrics
  - Log aggregation
  - Health check endpoints
- **Commit**: `feat: implement comprehensive monitoring stack [SC #030]`

---

## 🚀 **Comandos de Ejecución Inmediata**

### Primer Sprint (Semana 1-2)
```bash
# Setup inicial
/sc:implement "automated project setup script" --type infrastructure --framework rails --persona backend --with-tests

# CI/CD
/sc:implement "CI/CD pipeline with GitHub Actions" --type cicd --framework rails --persona devops --delegate files

# Documentación
/sc:implement ".docs/setup.md comprehensive guide" --type documentation --persona scribe --format markdown
```

### Segundo Sprint (Semana 3-4)
```bash
# Autenticación base
/sc:implement ".docs/workbook/001 | OAuth2 + Pundit.md" --type authentication --framework rails --persona security --c7

# Modelos core
/sc:implement ".docs/workbook/002 | User Account Model.md" --type model --framework rails --persona backend --with-tests

# Autorización
/sc:implement ".docs/workbook/004 | Pundit Authorization.md" --type authorization --framework rails --persona security --delegate auto
```

### Tercer Sprint (Semana 5-6)
```bash
# Arquitectura DDD
/sc:design "Site domain bounded context architecture" --type architecture --format spec --iterative --persona architect

# Implementación DDD
/sc:implement "Site::Hero aggregate with DDD patterns" --type domain --framework rails --persona architect --c7 --sequential

# API Core
/sc:implement "API v1 endpoints with serialization" --type api --framework rails --persona backend --c7 --sequential
```

---

## 📊 **Métricas de Progreso**

- **Total de Tareas**: 30
- **Fases**: 8  
- **Estimación Total**: 12-16 semanas
- **Complejidad Promedio**: Media-Alta

### Dependencias Críticas
1. **Tarea 001-003**: Fundación del proyecto
2. **Tarea 004-007**: Autenticación completa antes de features
3. **Tarea 008-011**: DDD antes de APIs complejas
4. **Tarea 024-026**: AI integration después de core estable

### Paralelización Posible
- Tareas de testing (016-018) paralelas a desarrollo
- Features avanzadas (019-023) independientes entre sí
- Optimización (027-030) en sprints finales

---

**Nota**: Cada tarea incluye tests automáticos y documentación. 
Los commits siguen Conventional Commits para trazabilidad completa.
