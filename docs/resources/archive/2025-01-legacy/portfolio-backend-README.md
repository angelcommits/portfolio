# 🚀 Backend API Modular — Portfolio as a Service

Este proyecto es un backend desarrollado en **Ruby on Rails**, orientado a servir como motor de datos para **portfolios web multitenencia**, basado en arquitectura modular y extensible.

Está pensado como **plantilla base** para escalar múltiples verticales que usen la misma estructura: API-first, desacoplada, segura y preparada para integraciones con agentes inteligentes y despliegues multicloud.

---

## 📌 Propósito del Proyecto

- Servir como backend para frontends en **Next.js (React + Tailwind)**.
- Proveer endpoints para **rehidratar componentes del cliente web** (imágenes, texto, metadata).
- Gestionar **autenticación, roles y permisos**.
- Contener un **modo de operación monolítico** para administradores u operadores (vía panel tipo Abo).
- Preparado para **multi-tenant / multi-dominio**.
- Diseñado para escalar a integraciones con IA y automación basada en tareas (`docs/workbook`).

---

## 🧱 Stack Tecnológico

- **Lenguaje / Framework**: Ruby 3.3, Rails 7.x
- **Gestión de versiones**: ASDF
- **Arquitectura**: Modular + MVC + DDD (en evolución)
- **API**: REST (implementada), GraphQL / gRPC (planeado)
- **BD**: PostgreSQL (Docker en local, RDS en prod), SQLite en test
- **Autenticación**: Rodauth + JWT (OmniAuth planeado)
- **Autorización**: Pundit (tentativo)
- **Infraestructura**: Docker, Docker Compose, Makefile
- **Documentación API**: Swagger + rswag (planeado)
- **Testing**: RSpec, Capybara (Cucumber posible), cobertura pendiente
- **CI/CD**: pendiente (GitHub Actions, Jenkins planeado)
- **LLM Agents**: SuperClaude (boceto de inferidor presente)

---

## 🗂️ Estructura del Proyecto

```bash
.docs/
└── workbook/            # ~120 tareas declaradas
app/
├── controllers/
├── models/
├── views/
├── services/
├── contracts/
├── domain/              # ValueObjects, Aggregates
├── repositories/
├── llm/                 # Agente IA / inferidor
config/
db/
lib/
entrypoints/             # Scripts de inicio Docker
.env
Dockerfile
Makefile

🔍 La estructura mantiene el estándar Rails, pero se extiende con módulos DDD y contextos para dominios bien definidos.

⸻

🧰 Setup Rápido (pendiente de automatización)

git clone https://github.com/mi-org/mi-backend.git
cd mi-backend
cp .env.example .env
asdf install
bundle install
make up        # o docker compose up
docker-compose run web rails db:setup

🔧 Un script bin/setup está pendiente de implementación para facilitar el proceso.

⸻

🧪 Testing
	•	RSpec para unitarios e integración
	•	Capybara para features (navegación)
	•	SimpleCov a integrar para cobertura
	•	rswag a integrar para tests contractuales
	•	🔜 Automatización por carpeta vía guard

⸻

🔐 Seguridad
	•	Rodauth para login/register/passwords
	•	JWT para autenticación API
	•	OmniAuth para redes sociales (planificado)
	•	Rails credentials + .env para secretos
	•	Vault (planeado) para producción
	•	Control de acceso: por roles (a definir)

⸻

🌐 API
	•	Expuesta en /api/v1/...
	•	Versionado vía path y módulos internos
	•	REST implementado, GraphQL y gRPC planificados
	•	Documentación OpenAPI con Swagger (en construcción)

⸻

🧠 IA + Automatización
	•	Boceto de inferidor para agentes IA (ej. SuperClaude)
	•	Planificado: integración para ejecutar tareas desde docs/workbook
	•	Comandos posibles: generar specs, seeds, endpoints, documentación, refactors

⸻

📘 Documentación y Archivos Relevantes
	•	README.md ← este documento
	•	docs/setup.md ← guía de instalación (a crear)
	•	ARCHITECTURE.md ← diseño modular DDD (a crear)
	•	INTERNAL_GUIDE.md ← protocolos internos (a crear)
	•	docs/workbook/ ← lista completa de tareas (~120)

⸻

📦 Objetivo como Plantilla Base

Este backend está diseñado como plantilla base escalable. Su arquitectura modular permite ser usada para:
	•	Proyectos multitenant
	•	Integraciones IA
	•	SaaS simples o paneles admin
	•	Proyectos con despliegue cloud (AWS/GCP/Azure)
	•	Casos con necesidad de control granular, dominios independientes y despliegue desacoplado

⸻

🧭 Próximos Pasos Sugeridos
	1.	Crear bin/setup y docs/setup.md.
	2.	Integrar GitHub Actions para lint + test.
	3.	Activar Swagger + rswag desde specs.
	4.	Consolidar dominios en módulos consistentes.
	5.	Agregar guard, simplecov, y bullet.
	6.	Desarrollar CLI mínimo para health y demo local.
	7.	Conectar con agentes IA para ejecución desde docs/workbook.

---

lo que quiero de vos es que: ademas de cual es el plan "inicial" de tareas pendientes (.docs/workbook), inmediatas, o en TODO para resolver los requisitos , son las instrucciones que deberia ejecutar SuperClaude ejecutar una aa una las tareas y completar tu plan de requisitos
