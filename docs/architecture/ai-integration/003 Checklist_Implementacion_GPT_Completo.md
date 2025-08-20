# Checklist de Implementación Completa GPT + Infraestructura Personalizada (2025-05-09)

## 🔧 Backend (Rails con DDD)
- [ ] Crear estructura DDD en `app/domains`, `app/services`, `app/adapters`
- [ ] Configurar autenticación con Rodauth y roles de acceso
- [ ] Crear modelos `Session`, `Message`, `Resource`, `Tag`, `User`
- [ ] Implementar endpoints RESTful para carga y consulta de conocimiento
- [ ] Agregar validación de seguridad (Twilio 2FA como MVP)
- [ ] Preparar exportador de markdown para integración con Obsidian
- [ ] Guardar archivos como `ActiveStorage` o en almacenamiento externo (ej: S3)

## 🧠 Sistema de Conocimiento y Persistencia
- [ ] Establecer formato de recursos (markdown, pdf, .txt)
- [ ] Integrar watcher de carpeta sincronizada (ej: Obsidian Vault local)
- [ ] Automatizar carga de archivos nuevos vía job background (Sidekiq)
- [ ] Etiquetar conocimiento por tema, lenguaje, proyecto
- [ ] Implementar historial de cambios o versiones de recursos

## 🖥️ Frontend React (Atomic Design)
- [ ] Estructurar carpetas: `/atoms`, `/molecules`, `/organisms`, `/templates`, `/pages`
- [ ] Crear dashboard de usuario: carga, historial, progreso
- [ ] Incluir módulo de chat embebido (API o iframe GPT)
- [ ] Incluir buscador de conocimientos y tags
- [ ] Proteger rutas sensibles con validación de sesión

## 🔌 Integraciones Externas
- [ ] Obsidian Sync (local ↔ remoto)
- [ ] Twilio SMS para validación y alertas
- [ ] Webhooks internos para actualización de recursos
- [ ] OLAMA: reactivar copiloto en Vim
- [ ] Validar servidor óptimo para OLAMA: probar `llama-cpp`, `mistral`, `code-llama`
- [ ] Establecer conexión entre OLAMA y tu sistema para respuestas técnicas offline

## 🤖 Interfaz GPT personalizada
- [ ] Diseñar comandos `/modo`, `/evaluar_riesgo`, `/recordar`, `/buscar`
- [ ] Crear lógica para evaluar impacto técnico, económico, estratégico
- [ ] Sincronizar respuestas GPT con base de conocimiento interna (opcional)
- [ ] Agregar sistema de tags y filtros para ideas y decisiones

## 🛡️ Seguridad y despliegue
- [ ] Separar entorno público y privado (ej: `public.tuweb.com` y `ops.tuweb.com`)
- [ ] Limitar IPs o autenticar usuarios internos
- [ ] Desplegar en servidor privado, VPS o cloud soberano
- [ ] Plan futuro: validación con Trezor, cifrado de respuestas, blockchain para logs

