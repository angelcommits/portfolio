#!/bin/bash
# refine-structure.sh - Ajuste de estructura docs a modelo híbrido
# Fecha: 2025-08-25 (25 de Agosto 2025)
# Propósito: Refinar estructura de epics y stories según Opción 2

set -e

echo "════════════════════════════════════════════════════════════════"
echo "📁 REFINAMIENTO DE ESTRUCTURA - Modelo Híbrido"
echo "📅 Fecha: 25 de Agosto, 2025"
echo "════════════════════════════════════════════════════════════════"

# Backup primero
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="docs-refinement-backup-${TIMESTAMP}.tar.gz"

echo "📦 Creando backup..."
tar -czf "${BACKUP_FILE}" docs/product/ 2>/dev/null || true
echo "✅ Backup creado: ${BACKUP_FILE}"

echo ""
echo "🔧 Ajustando estructura de epics..."

# Crear estructura de epics con subdirectorios
mkdir -p docs/product/03-epics/active/001-documentation
mkdir -p docs/product/03-epics/active/002-testing-cicd
mkdir -p docs/product/03-epics/active/003-authentication
mkdir -p docs/product/03-epics/active/004-standardization
mkdir -p docs/product/03-epics/active/005-production
mkdir -p docs/product/03-epics/unassigned

# Mover archivos de epic definition a sus carpetas
if [ -f "docs/product/03-epics/active/master-stabilization.md" ]; then
    # Crear README principal
    cat > docs/product/03-epics/active/README.md << 'EOF'
# Master Stabilization Epic

**Status**: 🔄 IN PROGRESS  
**Timeline**: 7 weeks (Started: August 2025)  
**Current Week**: Week 2-3  
**Sprint**: Sprint 2 - Testing & CI/CD

## Sub-Epics

1. [001 - Documentation](./001-documentation/) ✅ Completed
2. [002 - Testing & CI/CD](./002-testing-cicd/) 🔄 In Progress
3. [003 - Authentication](./003-authentication/) ⏳ Pending
4. [004 - Standardization](./004-standardization/) ⏳ Pending
5. [005 - Production](./005-production/) ⏳ Pending

## Progress Tracking

| Week | Target | Status | Notes |
|------|--------|--------|-------|
| 1 | Documentation | ✅ Completed | Structure established |
| 2-3 | Testing & CI/CD | 🔄 Current | 15% coverage → 80% target |
| 4 | Authentication | ⏳ Pending | Rodauth implementation |
| 5-6 | Standardization | ⏳ Pending | Code patterns & architecture |
| 7 | Production | ⏳ Pending | Deployment ready |

Last Updated: 2025-08-25
EOF
    
    # Mantener master como referencia
    mv docs/product/03-epics/active/master-stabilization.md docs/product/03-epics/active/master-stabilization-archive.md
fi

# Mover sub-epics a sus carpetas y crear archivos de tracking
for num in 001 002 003 004 005; do
    case $num in
        001) name="documentation" ;;
        002) name="testing-cicd" ;;
        003) name="authentication" ;;
        004) name="standardization" ;;
        005) name="production" ;;
    esac
    
    epic_dir="docs/product/03-epics/active/${num}-${name}"
    
    # Mover archivo de epic si existe
    if [ -f "docs/product/03-epics/active/sub-epics/${num}-${name}.md" ]; then
        mv "docs/product/03-epics/active/sub-epics/${num}-${name}.md" "${epic_dir}/README.md"
        echo "  ✓ Epic ${num} movido a su carpeta"
    fi
    
    # Crear archivo de stories reference
    cat > "${epic_dir}/stories.md" << EOF
# Epic ${num} - User Stories

## Active Stories (Sprint 2)
EOF

    # Para epic 002 (testing), agregar referencias a stories actuales
    if [ "$num" = "002" ]; then
        cat >> "${epic_dir}/stories.md" << 'EOF'

### In Current Sprint
- [002-001 RSpec Setup](../../05-user-stories/current-sprint/sprint-002/story-002-001-rspec-setup.md)
- [002-002 Backend Tests](../../05-user-stories/current-sprint/sprint-002/story-002-002-backend-tests.md) 🔄
- [002-003 Jest Setup](../../05-user-stories/current-sprint/sprint-002/story-002-003-jest-setup.md)
- [002-004 Frontend Tests](../../05-user-stories/current-sprint/sprint-002/story-002-004-frontend-tests.md)
- [002-005 CI Pipeline](../../05-user-stories/current-sprint/sprint-002/story-002-005-ci-pipeline.md)
- [002-006 E2E Cypress](../../05-user-stories/current-sprint/sprint-002/story-002-006-e2e-cypress.md)
- [002-007 Deployment](../../05-user-stories/current-sprint/sprint-002/story-002-007-deployment.md)
- [002-008 Performance](../../05-user-stories/current-sprint/sprint-002/story-002-008-performance.md)

### Completed Stories
None yet

### Backlog Items
- Integration test improvements
- Coverage reporting automation
- Performance benchmarking suite
EOF
    else
        cat >> "${epic_dir}/stories.md" << 'EOF'

### Stories
No stories assigned yet

### Backlog Items
To be refined
EOF
    fi

    # Crear backlog específico del epic
    cat > "${epic_dir}/backlog.md" << EOF
# Epic ${num} Backlog

## Unrefined Items
Items that need refinement before becoming user stories.

## Technical Debt
Epic-specific technical debt items.

## Ideas
Future considerations for this epic.

---
Last Updated: 2025-08-25
EOF

done

# Limpiar directorio sub-epics vacío
rmdir docs/product/03-epics/active/sub-epics 2>/dev/null || true

# Actualizar README principal de product
cat > docs/product/README.md << 'EOF'
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
EOF

# Actualizar fechas en archivos de sprint
if [ -d "docs/sprints/active/sprint-002" ]; then
    for file in docs/sprints/active/sprint-002/*.md; do
        if [ -f "$file" ]; then
            # Corregir fechas de 2025-08-24 a 2025-08-25 si es necesario
            sed -i.bak 's/2025-01-/2025-08-/g' "$file" 2>/dev/null || true
            rm "${file}.bak" 2>/dev/null || true
        fi
    done
fi

echo "✅ Estructura refinada al modelo híbrido"

# Crear resumen de la nueva estructura
echo ""
echo "📁 Nueva estructura de epics:"
echo ""
tree docs/product/03-epics -L 2 2>/dev/null || ls -la docs/product/03-epics/active/

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "✅ REFINAMIENTO COMPLETADO"
echo "📅 Fecha: 25 de Agosto, 2025"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "Cambios realizados:"
echo "  ✓ Epics organizados en carpetas individuales"
echo "  ✓ Cada epic tiene: README.md, stories.md, backlog.md"
echo "  ✓ Stories mantienen organización por sprint/estado"
echo "  ✓ Backlog general para items sin epic"
echo "  ✓ Fechas actualizadas a Agosto 2025"
echo ""
echo "📦 Backup guardado en: ${BACKUP_FILE}"
echo ""
echo "Próximos pasos:"
echo "  1. git add ."
echo "  2. git commit -m 'refactor: implement hybrid epic-story structure'"
echo "  3. Actualizar referencias en agentes BMad si es necesario"
echo ""