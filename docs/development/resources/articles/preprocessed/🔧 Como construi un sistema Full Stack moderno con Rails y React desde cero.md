🔧 Cómo construí un sistema Full Stack moderno con Rails y React desde cero

Introducción:
En este artículo comparto cómo encaré el diseño y desarrollo de un sistema fullstack que utiliza Ruby on Rails como backend y React como frontend embebido, todo bajo una arquitectura modular y lista para escalar.

¿Por qué elegí este stack?
Ruby on Rails sigue siendo un framework poderoso para construir APIs robustas, mientras que React permite crear interfaces ricas, responsivas y flexibles del lado del cliente. Decidí separarlos conceptualmente dentro de un mismo proyecto, dándole a React su propio dominio de responsabilidad, sin forzar integración a través de ViewComponents.

Decisión sobre ViewComponents:
Aunque el proyecto incluye estructuras compatibles con ViewComponents, decidí no usarlos en esta implementación para evitar conflictos de nomenclatura entre Ruby y React. Al separar responsabilidades, mantengo la lógica de presentación completamente del lado del cliente, mejorando la flexibilidad del código.

SEO en entornos client-side:
Una de las desventajas del rendering del lado del cliente es el SEO. Lo estoy resolviendo con React Helmet, configurando metadatos de forma dinámica desde los componentes y controlando eventos con useEffect. Esto permite optimizar la visibilidad sin sacrificar la velocidad de desarrollo.

Reflexión arquitectónica:
Si el proyecto fuese completamente en Rails, optaría por ViewComponents y posiblemente herramientas como Plex, para aplicar un diseño orientado a interfaces múltiples (HTML, JSON, protobuf). Sin embargo, cuando la interfaz cliente es compleja o futura, prefiero React por su escalabilidad y curva de aprendizaje amigable para nuevos miembros del equipo.

Stack técnico utilizado:
• Ruby on Rails (API mode)
• React + Vite
• Autenticación: Rodauth + OAuth2 + JWT
• Infraestructura: Docker + PostgreSQL
• Estilos: CSS Modules + Tailwind
• SEO: React Helmet
• Testing: RSpec, Jest

Conclusión:
Este proyecto me ayudó a consolidar una estructura que considero replicable, entendible y moderna. Estoy abierto a recibir feedback técnico y conectar con otros desarrolladores que trabajen con stacks similares.
