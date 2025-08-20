# Portfolio as a Service - Documentation Hub

## 📚 Documentación Principal

Bienvenido al centro de documentación del proyecto **Portfolio as a Service**. Este directorio contiene toda la documentación técnica, de producto y desarrollo del sistema.

## 🗂️ Estructura de Documentación

```
docs/
├── product/           # Documentación de producto
│   ├── brownfield-prd.md      # PRD de estabilización actual
│   └── roadmap.md             # Roadmap del producto
├── architecture/      # Documentación técnica
│   ├── brownfield-architecture.md  # Arquitectura de estabilización
│   ├── backend.md             # Detalles del backend Rails
│   └── frontend.md            # Detalles del frontend Next.js
├── api/              # Documentación de APIs
│   ├── swagger.yaml           # Especificación OpenAPI
│   └── postman.json          # Colección Postman
└── development/      # Guías de desarrollo
    ├── setup.md              # Configuración del ambiente
    ├── testing.md            # Estrategia de testing
    └── deployment.md         # Procedimientos de deployment
```

## 🎯 Estado Actual del Proyecto

### Fase: Estabilización Pre-Producción

El proyecto se encuentra en proceso de estabilización para alcanzar un estado production-ready. Los documentos principales que definen este proceso son:

1. **[Product Requirements Document (PRD)](./product/brownfield-prd.md)** - Define los requerimientos y plan de estabilización
2. **[Architecture Document](./architecture/brownfield-architecture.md)** - Blueprint técnico para la implementación

### Objetivos Principales

- ✅ Consolidación de documentación (en progreso)
- ⏳ Reparación de CI/CD pipeline
- ⏳ Implementación completa de tests
- ⏳ Finalización de autenticación con Rodauth
- ⏳ Estandarización de arquitectura
- ⏳ Preparación para producción

## 🚀 Quick Start

### Para Desarrolladores

1. **Setup inicial**: Ver [development/setup.md](./development/setup.md)
2. **Arquitectura**: Revisar [architecture/brownfield-architecture.md](./architecture/brownfield-architecture.md)
3. **Testing**: Consultar [development/testing.md](./development/testing.md)

### Para Product Managers

1. **Visión del producto**: [product/brownfield-prd.md](./product/brownfield-prd.md)
2. **Roadmap**: [product/roadmap.md](./product/roadmap.md)
3. **User Stories**: [product/user-stories.md](./product/user-stories.md)

### Para DevOps

1. **Deployment**: [development/deployment.md](./development/deployment.md)
2. **Infraestructura**: [architecture/infrastructure.md](./architecture/infrastructure.md)
3. **CI/CD**: `.github/workflows/` en el directorio raíz

## 📋 Componentes del Sistema

### Backend (Rails API)
- **Ubicación**: `portfolio-backend/`
- **Framework**: Rails 8.0.1
- **Documentación**: [architecture/backend.md](./architecture/backend.md)
- **Estado**: En estabilización

### Frontend (Next.js)
- **Ubicación**: `portfolio-frontend/`
- **Framework**: Next.js
- **Documentación**: [architecture/frontend.md](./architecture/frontend.md)
- **Estado**: Funcional, requiere integración de auth

### Módulo SMS (Twilio)
- **Ubicación**: `sms-consumer/`
- **Propósito**: Servicio de mensajería SMS/WhatsApp
- **Estado**: Sandbox/Experimental

## 🔄 Plan de Migración

El proyecto está siguiendo un plan de 7 semanas para alcanzar producción:

| Fase | Duración | Estado | Descripción |
|------|----------|--------|-------------|
| 1. Documentación | 1 semana | 🟡 En progreso | Consolidación de docs |
| 2. Testing & CI/CD | 2 semanas | ⏳ Pendiente | Reparación de tests |
| 3. Autenticación | 1 semana | ⏳ Pendiente | Completar Rodauth |
| 4. Refactoring | 2 semanas | ⏳ Pendiente | Estandarización |
| 5. Producción | 1 semana | ⏳ Pendiente | Preparación final |

## 🛠️ Stack Tecnológico

### Core
- **Backend**: Ruby on Rails 8.0.1
- **Frontend**: Next.js
- **Database**: PostgreSQL 14+
- **Cache**: Redis / Solid Cache

### Herramientas
- **Testing**: RSpec, Jest, Cypress
- **CI/CD**: GitHub Actions
- **Deployment**: Docker, Kamal
- **Monitoring**: Por definir

## 📝 Convenciones

### Documentación
- Usar Markdown para todos los docs
- Seguir estructura definida
- Mantener índices actualizados
- Incluir diagramas cuando sea relevante

### Código
- **Backend**: RuboCop + Rails best practices
- **Frontend**: ESLint + Prettier
- **Commits**: Conventional Commits
- **Branches**: feature/*, bugfix/*, hotfix/*

## 🤝 Contribución

1. Toda nueva funcionalidad debe incluir documentación
2. Actualizar este README cuando se agreguen nuevos docs
3. Seguir los templates establecidos
4. Mantener la documentación sincronizada con el código

## 📞 Contacto y Soporte

- **Owner**: Angel Szymczak
- **Repositorio**: portfolio/
- **Issues**: Crear en GitHub Issues

## 🔗 Enlaces Útiles

### Documentos Clave
- [PRD de Estabilización](./product/brownfield-prd.md)
- [Arquitectura Técnica](./architecture/brownfield-architecture.md)
- [Setup Guide](./development/setup.md)

### Referencias Externas
- [Rails Guides](https://guides.rubyonrails.org/)
- [Next.js Docs](https://nextjs.org/docs)
- [Rodauth Documentation](https://rodauth.jeremyevans.net/)

---

*Última actualización: 2025-01-19*
*Versión de documentación: 0.1.0*