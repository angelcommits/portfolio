# Bounded Contexts

## Identity Context
Gestiona autenticación, autorización y usuarios.

### Casos de uso:
- `RegisterUser`: Registro de nuevos usuarios
- `AuthenticateUser`: Login de usuarios
- `UpdateProfile`: Actualización de perfil

### Eventos:
- `UserRegistered`
- `UserAuthenticated`
- `ProfileUpdated`

## Portfolio Context
Gestiona proyectos y showcase profesional.

### Agregados:
- `Project`: Proyecto del portfolio
- `Technology`: Tecnologías utilizadas

### Value Objects:
- `ProjectStatus`: Estados del proyecto
- `TechnologyCategory`: Categorías de tecnología
