# 📋 Plan de Reorganización de Documentación

## 🎯 Objetivo
Reorganizar la estructura de documentación del proyecto Portfolio as a Service para mejorar la escalabilidad, mantenibilidad y accesibilidad de la información.

## 📁 Reorganización de docs/product

### Estructura Actual (Problemática)
```
docs/
├── product/
│   ├── backlog/
│   ├── epics/
│   ├── product-requirements.md
│   ├── roadmap/
│   └── user-stories/
├── resources/   # ⚠️ Mal ubicado
│   ├── archive/
│   └── external-audits/
└── sprints/     # Mezclado con product
```

### Nueva Estructura Propuesta
```
docs/
├── product/
│   ├── 01-requirements/
│   │   ├── PRD.md (renamed from product-requirements.md)
│   │   ├── vision.md
│   │   └── success-metrics.md
│   ├── 02-roadmap/
│   │   ├── README.md
│   │   ├── milestones.md
│   │   └── release-plan.md
│   ├── 03-epics/
│   │   ├── active/
│   │   │   ├── master-stabilization.md
│   │   │   └── sub-epics/
│   │   │       ├── 001-documentation.md
│   │   │       ├── 002-testing-cicd.md
│   │   │       ├── 003-authentication.md
│   │   │       ├── 004-standardization.md
│   │   │       └── 005-production.md
│   │   └── completed/
│   ├── 04-backlog/
│   │   ├── product-backlog.md
│   │   ├── technical-debt.md
│   │   └── icebox.md
│   └── 05-user-stories/
│       ├── current-sprint/
│       │   └── sprint-002/
│       │       ├── 002-001-rspec-setup.md
│       │       ├── 002-002-backend-tests.md
│       │       └── tasks/
│       ├── ready/
│       ├── draft/
│       └── completed/
├── sprints/
│   ├── active/
│   │   └── sprint-002/
│   ├── completed/
│   │   └── sprint-001/
│   └── reports/
├── resources/
│   ├── templates/
│   ├── archive/
│   └── external-audits/
└── development/
```

## 🚀 Acciones de Migración

### 1. Archivos a Mover
```bash
# Product Requirements
mv docs/product/product-requirements.md docs/product/01-requirements/PRD.md

# Epics - Renombrar para mejor organización
mv docs/product/epics/ docs/product/03-epics/active/
mkdir -p docs/product/03-epics/completed/

# User Stories - Organizar por estado
mkdir -p docs/product/05-user-stories/{current-sprint,ready,draft,completed}
mv docs/product/user-stories/story-002-*.md docs/product/05-user-stories/current-sprint/sprint-002/

# Backlog
mv docs/product/backlog/TECHNICAL-DEBT-BACKLOG.md docs/product/04-backlog/technical-debt.md

# Resources - Mover a ubicación correcta
mv docs/resources/archive/ docs/resources/archive/
mv docs/resources/external-audits/ docs/resources/external-audits/

# Archivos obsoletos para eliminar
rm TASK-005-Integration-Tests-COMPLETE.md
rm TASK-005-QA-Enhancements-COMPLETE.md
# O moverlos a:
mv TASK-005-*.md docs/sprints/completed/sprint-001/tasks/
```

### 2. Archivos README a Crear

#### docs/product/README.md
```markdown
# Product Documentation

## Structure
- **01-requirements/** - Product requirements and vision
- **02-roadmap/** - Product roadmap and release planning
- **03-epics/** - Epic definitions and tracking
- **04-backlog/** - Product and technical backlogs
- **05-user-stories/** - User stories by status

## Quick Links
- [Current Sprint Stories](./05-user-stories/current-sprint/)
- [Product Roadmap](./02-roadmap/README.md)
- [Active Epics](./03-epics/active/)
```

#### docs/product/03-epics/README.md
```markdown
# Epics Management

## Active Epics
- [Master Stabilization](./active/master-stabilization.md)

## Naming Convention
- Master epics: `{name}.md`
- Sub-epics: `{number}-{name}.md`

## Status Tracking
Move completed epics to `completed/` directory with completion date.
```

#### docs/product/05-user-stories/README.md
```markdown
# User Stories

## Organization
- **current-sprint/** - Stories in active sprint
- **ready/** - Stories ready for next sprint
- **draft/** - Stories being refined
- **completed/** - Delivered stories

## Story Format
`{epic-number}-{story-number}-{brief-name}.md`

Example: `002-001-rspec-setup.md`
```

## 📝 Beneficios de la Reorganización

### 1. **Claridad Estructural**
- Separación clara entre product, development, y sprints
- Jerarquía numérica facilita navegación
- Estados explícitos para stories y epics

### 2. **Escalabilidad**
- Estructura preparada para crecimiento
- Fácil archivado de items completados
- Separación de concerns

### 3. **Mejor Colaboración**
- Cada rol sabe dónde encontrar/guardar información
- Menos conflictos de merge
- Documentación autodescriptiva

### 4. **Automatización**
- Estructura predecible para scripts
- Fácil generación de reportes
- Compatible con herramientas de gestión

## ⚠️ Consideraciones

### Archivos Obsoletos Identificados
1. `TASK-005-Integration-Tests-COMPLETE.md` - Mover a sprints/completed
2. `TASK-005-QA-Enhancements-COMPLETE.md` - Mover a sprints/completed
3. Stories antiguas sin actividad - Archivar en completed/

### Dependencias
- Actualizar referencias en scripts CI/CD
- Actualizar paths en agentes BMad
- Actualizar bookmarks del equipo

## 🔄 Plan de Implementación

### Fase 1: Preparación (Inmediato)
1. Crear nuevas carpetas
2. Backup actual: `tar -czf docs-backup-$(date +%Y%m%d).tar.gz docs/`

### Fase 2: Migración (1 día)
1. Mover archivos según plan
2. Crear READMEs de navegación
3. Actualizar referencias

### Fase 3: Validación (1 día)
1. Verificar todos los links
2. Actualizar documentación
3. Comunicar al equipo

### Fase 4: Limpieza (Continuo)
1. Eliminar archivos obsoletos
2. Archivar items completados
3. Mantener estructura

## 📊 Métricas de Éxito
- [ ] 100% archivos organizados según nueva estructura
- [ ] 0 links rotos después de migración
- [ ] Reducción 50% tiempo búsqueda documentos
- [ ] 100% equipo capacitado en nueva estructura

---

**Estado**: PROPUESTO  
**Fecha**: 2025-01-25  
**Autor**: System Architect  
**Aprobación Pendiente**: Product Owner, Scrum Master