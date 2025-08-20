### 🗺️ Roadmap Completo de Implementación GPT System

```markdown
1. Configurar estructura DDD en proyecto Rails bajo módulo `GPT`.
2. Implementar Rodauth con modelo `User` enlazado por `account_id`.
3. Definir roles `operator` y `bot` para control de acceso.
4. Crear modelos: `Session`, `Message`, `Resource`, `Tag`, `User` (ActiveRecord).
5. Crear migraciones correspondientes para los modelos.
6. Diseñar endpoints RESTful iniciales (`/api/v1/gpt/...`).
7. Establecer estructura de carpetas para servicios, adaptadores, dominios.
8. Configurar capa `adapters/inference/ollama_adapter.rb` para invocar OLAMA.
9. Preparar estructura de OLAMA dentro del repo (`ollama/`).
10. Instalar y probar modelo `code-llama` con OLAMA localmente.
11. Crear cliente HTTP Rails para comunicarse con OLAMA (`ollama_client.rb`).
12. Integrar invocación LLM en `GPT::InferenceService`.
13. Diseñar lógica para elección dinámica entre OLAMA local y API externa GPT.
14. Implementar `LocalClient` en `adapters/storage` para manejar ActiveRecord.
15. Agregar `S3Client` opcional para almacenamiento en la nube.
16. Crear adaptadores de notificación para email, SMS, etc.
17. Integrar sistema de etiquetas para categorizar conocimiento y recursos.
18. Desarrollar dashboard React basado en Atomic Design.
19. Implementar buscador por recursos y etiquetas.
20. Diseñar y aplicar flujo de ingestión de archivos (.md, .pdf) manual y automático.
21. Desarrollar watcher para carpeta sincronizada con Obsidian (Sync/rsync).
22. Incorporar sistema de sesiones conversacionales (`Session + Message`).
23. Crear comandos GPT: `/modo`, `/recordar`, `/evaluar_riesgo`, `/buscar`, `/test`, `/iniciar_tdd`, etc.
24. Definir interfaces para futuros canales: Telegram, Discord, Slack, etc.
25. Separar frontend público (`www`) del sistema privado (`ops`).
26. Proteger área `ops` con autenticación Twilio 2FA.
27. Planificar futura validación avanzada (Trezor, cifrado, blockchain logs).
```
