# 📚 Epics Management

## Estructura

```
03-epics/
├── active/           # Épicas en progreso
│   ├── master-stabilization.md
│   └── sub-epics/   # Sub-épicas del master
└── completed/       # Épicas completadas
```

## Épicas Activas

### Master Epic
- [Master Stabilization](./active/master-stabilization.md) - 7 semanas hasta producción

### Sub-Epics
1. [Documentation](./active/sub-epics/001-documentation.md) ✅
2. [Testing & CI/CD](./active/sub-epics/002-testing-cicd.md) 🔄
3. [Authentication](./active/sub-epics/003-authentication.md) ⏳
4. [Standardization](./active/sub-epics/004-standardization.md) ⏳
5. [Production](./active/sub-epics/005-production.md) ⏳

## Convención de Nombres

- Master epics: `{name}.md`
- Sub-epics: `{number}-{name}.md`
- Estado: Mover a `completed/` con fecha al finalizar
