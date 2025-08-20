# 🏗️ Arquitectura Backend Actualizada para GPT System con Rodauth + OLAMA

## 📁 Estructura de Carpetas (Rails Project)

```
app/
├── domains/
│   └── gpt/
│       ├── knowledge/
│       ├── sessions/
│       ├── resources/
│       ├── tags/
│       └── users/
├── models/
│   └── gpt/
│       ├── session.rb
│       ├── message.rb
│       ├── resource.rb
│       ├── tag.rb
│       └── user.rb
├── services/
│   └── gpt/
│       ├── inference/           # Invocación a LLM (OLAMA)
│       ├── evaluation/
│       ├── knowledge/
│       └── user_context/
├── adapters/
│   ├── api/
│   │   ├── v1/
│   │   └── base_controller.rb
│   ├── notification/           # Email, SMS, Webhooks, etc.
│   ├── storage/                # Acceso abstracto a sistemas de almacenamiento (local o S3)
│   │   ├── local_client.rb     # Manejo ActiveRecord como backend de storage
│   └── inference/              # Aquí vivirá ollama_adapter.rb
├── ollama/                     # Scripts y configuración OLAMA local
│   ├── config/
│   │   └── ollama_config.yml
│   ├── scripts/
│   │   └── start_ollama.sh
│   └── README.md
```

---

## 👥 User y Autenticación

- Usás **Rodauth**, lo cual significa que `account_id` será tu referencia principal de usuario.
- En tu modelo `User`, se mapeará 1:1 a un `account_id`.
- Los roles (`operator`, `bot`) serán manejados por una columna extra en `users.role`.
- El operador tiene acceso total. El bot (MisitioBot/ReceptorBot) está limitado a ciertos recursos y queries.

---

## 📡 Storage y rol en la arquitectura

- El `adapter/storage` actúa como un **repositorio abstracto**.
- Puede tener implementaciones como:
  - `LocalClient` → Mapea a ActiveRecord para persistencia local
  - `S3Client` → Subida/bajada de archivos en buckets
- Todo acceso externo a archivos o datos estructurados debería pasar por aquí para mantener separación de capas.

---

## 🤖 OLAMA como motor LLM local

- Instalás OLAMA y corrés el modelo (ej: code-llama) localmente
- Lo tratás como un servicio en `adapters/inference/ollama_adapter.rb`
- Tu dominio (`services/gpt/inference/`) lo invoca sin saber si es OLAMA o ChatGPT (¡lo podés switchear!)

---

## 🧩 Ventajas de esta arquitectura

- 100% alineada a DDD
- Totalmente desacoplada (OLAMA, Storage, Notification)
- Lista para escalar con múltiples usuarios y bots
- Seguridad y trazabilidad garantizada por Rodauth
- Adaptable para nuevas interfaces (chatbots, frontend, terminal)

---
