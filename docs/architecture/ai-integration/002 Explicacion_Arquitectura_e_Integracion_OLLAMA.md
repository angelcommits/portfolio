# 📚 Explicación Arquitectónica y Plan de Integración OLAMA

## 1. 📦 ¿Qué son los `adapters/` en DDD?

En Domain-Driven Design, los `adapters` representan **interfaces tecnológicas concretas** para,
los "puertos" definidos en tu dominio.
Actúan como puentes entre la lógica pura de negocio y las tecnologías externas. Ejemplos:

- `adapters/api/`: Interfaz de entrada. Define cómo los clientes externos (como tu frontend React o MiSitioBot) interactúan con el sistema. Implementan controladores que renderizan respuestas en JSON, HTML, XML, etc.
- `adapters/storage/`: Interfaz de salida. Aquí implementás cómo guardar o recuperar archivos desde S3, disco, Google Cloud, etc., sin acoplarlo directamente a tu lógica de negocio.
- `adapters/notification/`: También interfaz de salida. Define adaptadores para enviar emails, mensajes de texto (Twilio), WhatsApp, webhooks, etc.

**Importante**: Esto te da flexibilidad para cambiar la implementación sin tocar el dominio.

---

## 2. 👥 ¿Cómo representa `User` los distintos roles?

Tu modelo `User` puede representar:

- `Operador`: Vos mismo, interactuando a fondo con el sistema. Tenés acceso total.
- `ReceptorBot`: El bot que recepciona consultas del público. Tiene acceso restringido a un subconjunto de la base de conocimientos.

En el futuro, podrías agregar:

- `Cliente`: Personas externas a quienes les des acceso controlado al sistema.
- `Sistema`: Automatismos que actúan como usuarios técnicos.

**La clave** es usar roles (`:operator`, `:bot`, `:client`) y, si hace falta, trabajar con bases de datos lógicas o físicas separadas para evitar fugas de información.

---

## 3. 🧠 Integración de OLAMA como motor local

### 📁 Estructura recomendada

```
ollama/
├── models/
│   └── code-llama (u otro modelo)
├── scripts/
│   └── start_ollama.sh
├── config/
│   └── ollama_config.yml
```

### ⚙️ Flujo de integración

1. **Arrancás OLAMA como servicio local**:

   ```bash
   ollama run code-llama
   ```

2. **Desde tu backend Rails**, hacés requests HTTP a localhost:

   ```http
   POST http://localhost:11434/api/generate
   Content-Type: application/json

   {
     "model": "code-llama",
     "prompt": "Escribí un test en Ruby para esta función..."
   }
   ```

3. **Tu backend actúa como middleware**: puede decidir si usa OLAMA local o una API externa (ChatGPT) según contexto, prioridad o sensibilidad.

4. **Guardás en tu DB** tanto la pregunta como la respuesta, como parte de tu sesión.

---

## ✅ Plan de acción siguiente

1. Instalar OLAMA (si no está activo)
2. Descargar modelo como `code-llama` o `mistral`
3. Probar localmente desde terminal
4. Implementar cliente HTTP simple en Rails (`ollama_client.rb`)
5. Conectar a `GPT::InferenceService` en tu dominio
6. Probar flujo completo desde backend
