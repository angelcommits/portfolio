# 📋 Product Documentation

**Date**: August 25, 2025  
**Current Sprint**: Sprint 2 - Testing & CI/CD  
**Week**: 2-3 of 7-week stabilization plan

## 📁 Estructura Híbrida

```
product/
├── 01-requirements/    # PRD, visión, métricas de éxito
├── 02-roadmap/        # Roadmap y planificación de releases  
├── 03-epics/          # Épicas con referencias a stories
│   ├── active/        # Épicas en progreso
│   │   └── {epic}/    # Cada épica contiene:
│   │       ├── README.md     # Definición del epic
│   │       ├── stories.md    # Referencias a user stories
│   │       └── backlog.md    # Backlog específico del epic
│   └── completed/     # Épicas completadas
├── 04-backlog/        # Backlog general y deuda técnica
└── 05-user-stories/   # Stories organizadas por estado sprint
    ├── current-sprint/
    ├── ready/
    ├── draft/
    └── completed/
```

## 🔗 Enlaces Rápidos

### Current Focus
- [Sprint 2 Stories](./05-user-stories/current-sprint/sprint-002/)
- [Testing Epic (002)](./03-epics/active/002-testing-cicd/)
- [Sprint Status](../sprints/active/sprint-002/)

### Planning
- [Product Requirements (PRD)](./01-requirements/PRD.md)
- [Roadmap](./02-roadmap/)
- [Master Epic Status](./03-epics/active/)

### Backlogs
- [Product Backlog](./04-backlog/product-backlog.md)
- [Technical Debt](./04-backlog/technical-debt.md)
- [Icebox](./04-backlog/icebox.md)

## 📊 Current Status

### Sprint 2 Progress
- **Started**: August 19, 2025
- **Target**: 80% test coverage
- **Current**: 15% coverage
- **Stories**: 0/8 completed

### Master Stabilization Timeline
| Phase | Week | Dates | Status |
|-------|------|-------|--------|
| Documentation | 1 | Aug 12-18 | ✅ Completed |
| Testing & CI/CD | 2-3 | Aug 19-Sep 1 | 🔄 Current |
| Authentication | 4 | Sep 2-8 | ⏳ Pending |
| Standardization | 5-6 | Sep 9-22 | ⏳ Pending |
| Production | 7 | Sep 23-29 | ⏳ Pending |

## 🔄 Workflow

1. **Epic Definition** → Define scope in `03-epics/`
2. **Backlog Refinement** → Items in epic's `backlog.md`
3. **Story Creation** → Move to `05-user-stories/draft/`
4. **Sprint Planning** → Move to `05-user-stories/ready/`
5. **Sprint Execution** → Move to `05-user-stories/current-sprint/`
6. **Completion** → Move to `05-user-stories/completed/`

---
*Last Updated: August 25, 2025*
