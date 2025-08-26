# 🧩 Sección 1: Título del Proyecto

## DevDreaming

Ecosistema modular para desarrolladores modernos: blog técnico, portafolio, autenticación avanzada y diseño adaptable.

⚙️ Stack: Ruby on Rails · React · OAuth2 · Rodauth · Docker · Tailwind · PostgreSQL · AWS-ready

## 🧩 Sección 2: Resumen Ejecutivo

DevDreaming es una plataforma fullstack diseñada como entorno de exhibición técnica personal y validación profesional. Combina una arquitectura limpia, autenticación moderna, diseño visual y modularidad escalable.

Pensado para startups, reclutadores o CTOs que buscan comprender el potencial real de un desarrollador sin intermediarios.

Cuenta con:
• Sección de blog técnico para compartir artículos o publicaciones profesionales
• Portafolio de proyectos y experiencias
• Panel administrativo (próximamente)
• Implementación avanzada de seguridad y componentes reutilizables

## 🧩 Sección 3: Características Clave

- 🔐 Autenticación Moderna con Rodauth + OAuth2
  Sistema seguro y escalable, integrable con cuentas externas.
- 🧱 Componentes Reutilizables Frontend (React + ViewComponents)
  Diseño modular con Storybook para visualización y pruebas aisladas.
- 🖥️ Diseño Responsive & UI profesional (Tailwind + Atomic CSS)
  Soporte para dark/light theme, fuentes personalizadas, layouts adaptativos.
- 🧠 Arquitectura limpia y escalable (Rails + Concerns + Service Objects)
  Separación clara entre lógica, vistas y datos, fácil de mantener y extender.
- 🗂️ Panel administrativo embebido (en progreso)
  Preparado para dashboards o backoffices sin herramientas externas.
- 📄 Blog técnico integrado
  Publicación de artículos con sistema de categorías, tags y diseño elegante.
- ☁️ Listo para producción en AWS / Heroku / Docker
  Configuración CI/CD y dockerizada para fácil despliegue y mantenimiento.

## 🧩 Sección 4: Instalación Local y Requerimientos Técnicos

🔧 Requisitos

- Ruby 3.2+
- Node.js 18+
- PostgreSQL
- Redis
- Yarn
- Docker (opcional)
- AWS CLI (opcional)

📦 Instalación Local (modo desarrollo)

```bash
# 1. Clonar el repositorio
git clone git@github.com:angel-szymczak/devdreaming.git
cd devdreaming

# 2. Instalar dependencias
bundle install
yarn install

# 3. Configurar variables de entorno
cp .env.example .env
# Editar valores en .env con tus credenciales locales

# 4. Crear y migrar base de datos
rails db:setup

# 5. Levantar la app
bin/dev
```

🚀 Despliegue en Producción

- Se proveen archivos Dockerfile, docker-compose.yml y Procfile.
- Compatible con AWS (Elastic Beanstalk o ECS), Heroku o servidores personalizados.
- Instrucciones específicas se encuentran en docs/deploy.md (en progreso).

## 🧩 Phase 3 – Build Your Own System

Goal: Demonstrate full technical autonomy and architectural vision.

✅ Key Achievements:
• You built an integrated fullstack app using Ruby on Rails and React in a single project.
• Set up and documented the full stack from scratch: authentication, frontend, navigation, business logic, and scalable structure.
• Implemented security best practices (Rodauth, OAuth2, JWT), session control, custom validations, and password recovery.
• Added portfolio/articles CRUD and a real-time alert system with no page reload.
• The repository is private and ready to be shared with CTOs, CEOs, or investors.

🎯 Result:

A working, scalable system showing your senior-level skills and technical branding capacity.
