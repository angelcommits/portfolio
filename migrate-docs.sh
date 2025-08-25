#!/bin/bash
# migrate-docs.sh - Script de reorganización de documentación
# Fecha: 2025-01-25
# Propósito: Reorganizar estructura de docs/ para mejor escalabilidad

set -e  # Exit on error

echo "════════════════════════════════════════════════════════════════"
echo "📁 REORGANIZACIÓN DE DOCUMENTACIÓN - Portfolio as a Service"
echo "════════════════════════════════════════════════════════════════"

# Variables
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="docs-backup-${TIMESTAMP}.tar.gz"

# Función para confirmar acción
confirm() {
    read -p "❓ $1 [y/N]: " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

echo ""
echo "⚠️  ADVERTENCIA: Este script reorganizará toda la estructura de documentación"
echo "📦 Se creará un backup en: ${BACKUP_FILE}"
echo ""

if ! confirm "¿Deseas continuar?"; then
    echo "❌ Operación cancelada"
    exit 0
fi

# ============================================================
# PASO 1: BACKUP
# ============================================================
echo ""
echo "📦 Paso 1: Creando backup..."
tar -czf "${BACKUP_FILE}" docs/ README-backend.md TASK-005-*.md 2>/dev/null || true
echo "✅ Backup creado: ${BACKUP_FILE}"

# ============================================================
# PASO 2: CREAR NUEVA ESTRUCTURA
# ============================================================
echo ""
echo "📁 Paso 2: Creando nueva estructura de directorios..."

# Product structure
mkdir -p docs/product/01-requirements
mkdir -p docs/product/02-roadmap
mkdir -p docs/product/03-epics/active/sub-epics
mkdir -p docs/product/03-epics/completed
mkdir -p docs/product/04-backlog
mkdir -p docs/product/05-user-stories/current-sprint/sprint-002/tasks
mkdir -p docs/product/05-user-stories/ready
mkdir -p docs/product/05-user-stories/draft
mkdir -p docs/product/05-user-stories/completed

# Sprint structure
mkdir -p docs/sprints/active/sprint-002
mkdir -p docs/sprints/completed/sprint-001/tasks
mkdir -p docs/sprints/reports

# API docs
mkdir -p docs/api

# Resources (mantener existente)
mkdir -p docs/resources/templates
mkdir -p docs/resources/archive
mkdir -p docs/resources/external-audits

echo "✅ Estructura de directorios creada"

# ============================================================
# PASO 3: MOVER ARCHIVOS
# ============================================================
echo ""
echo "🚚 Paso 3: Moviendo archivos a nuevas ubicaciones..."

# 3.1 - Mover README-backend.md
if [ -f "README-backend.md" ]; then
    mv README-backend.md docs/api/
    echo "  ✓ README-backend.md → docs/api/"
fi

# 3.2 - Mover archivos TASK-005
if [ -f "TASK-005-Integration-Tests-COMPLETE.md" ]; then
    mv TASK-005-Integration-Tests-COMPLETE.md docs/sprints/completed/sprint-001/tasks/
    echo "  ✓ TASK-005-Integration-Tests-COMPLETE.md → sprints/completed/"
fi

if [ -f "TASK-005-QA-Enhancements-COMPLETE.md" ]; then
    mv TASK-005-QA-Enhancements-COMPLETE.md docs/sprints/completed/sprint-001/tasks/
    echo "  ✓ TASK-005-QA-Enhancements-COMPLETE.md → sprints/completed/"
fi

# 3.3 - Reorganizar Product Requirements
if [ -f "docs/product/product-requirements.md" ]; then
    mv docs/product/product-requirements.md docs/product/01-requirements/PRD.md
    echo "  ✓ product-requirements.md → 01-requirements/PRD.md"
fi

# 3.4 - Mover Roadmap
if [ -d "docs/product/roadmap" ]; then
    cp -r docs/product/roadmap/* docs/product/02-roadmap/ 2>/dev/null || true
    rm -rf docs/product/roadmap
    echo "  ✓ roadmap/* → 02-roadmap/"
fi

# 3.5 - Reorganizar Epics
if [ -d "docs/product/epics" ]; then
    # Mover master epic
    if [ -f "docs/product/epics/master-stabilization.md" ]; then
        mv docs/product/epics/master-stabilization.md docs/product/03-epics/active/
        echo "  ✓ master-stabilization.md → 03-epics/active/"
    fi
    
    # Mover sub-epics y renombrar
    for file in docs/product/epics/sub-epic-*.md; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            # Remover "sub-epic-" del nombre
            newname=${filename#sub-epic-}
            mv "$file" "docs/product/03-epics/active/sub-epics/$newname"
            echo "  ✓ $filename → 03-epics/active/sub-epics/$newname"
        fi
    done
    
    # Eliminar directorio vacío
    rmdir docs/product/epics 2>/dev/null || true
fi

# 3.6 - Reorganizar Backlog
if [ -d "docs/product/backlog" ]; then
    if [ -f "docs/product/backlog/TECHNICAL-DEBT-BACKLOG.md" ]; then
        mv docs/product/backlog/TECHNICAL-DEBT-BACKLOG.md docs/product/04-backlog/technical-debt.md
        echo "  ✓ TECHNICAL-DEBT-BACKLOG.md → 04-backlog/technical-debt.md"
    fi
    rmdir docs/product/backlog 2>/dev/null || true
fi

# 3.7 - Reorganizar User Stories
if [ -d "docs/product/user-stories" ]; then
    # Mover stories del sprint 002
    for file in docs/product/user-stories/story-002-*.md; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            mv "$file" "docs/product/05-user-stories/current-sprint/sprint-002/"
            echo "  ✓ $filename → current-sprint/sprint-002/"
        fi
    done
    
    # Mover carpeta de tasks
    if [ -d "docs/product/user-stories/story-002-002-tasks" ]; then
        mv docs/product/user-stories/story-002-002-tasks/* docs/product/05-user-stories/current-sprint/sprint-002/tasks/ 2>/dev/null || true
        rmdir docs/product/user-stories/story-002-002-tasks 2>/dev/null || true
        echo "  ✓ story-002-002-tasks/* → current-sprint/sprint-002/tasks/"
    fi
    
    # Eliminar directorio vacío
    rmdir docs/product/user-stories 2>/dev/null || true
fi

# 3.8 - Mover sprint files existentes
if [ -d "docs/sprint" ]; then
    cp -r docs/sprint/* docs/sprints/active/sprint-002/ 2>/dev/null || true
    echo "  ✓ sprint/* → sprints/active/sprint-002/"
fi

# 3.9 - Mover reports existentes
if [ -d "docs/sprints/reports" ]; then
    for file in docs/sprints/reports/*.md; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            echo "  ✓ reports/$filename (ya en ubicación correcta)"
        fi
    done
fi

echo "✅ Archivos movidos exitosamente"

# ============================================================
# PASO 4: CREAR ARCHIVOS README
# ============================================================
echo ""
echo "📝 Paso 4: Creando archivos README de navegación..."

# README principal de product
cat > docs/product/README.md << 'EOF'
# 📋 Product Documentation

## 📁 Estructura Organizacional

```
product/
├── 01-requirements/    # Requisitos del producto y visión
├── 02-roadmap/        # Roadmap y planificación de releases
├── 03-epics/          # Definición y tracking de épicas
├── 04-backlog/        # Backlogs de producto y técnico
└── 05-user-stories/   # Historias de usuario por estado
```

## 🔗 Enlaces Rápidos

- [PRD - Product Requirements](./01-requirements/PRD.md)
- [Roadmap Actual](./02-roadmap/README.md)
- [Épicas Activas](./03-epics/active/)
- [Sprint Actual](./05-user-stories/current-sprint/)
- [Backlog de Producto](./04-backlog/product-backlog.md)
- [Deuda Técnica](./04-backlog/technical-debt.md)

## 📊 Estado Actual

- **Sprint Activo**: Sprint 2 - Testing & CI/CD
- **Epic en Progreso**: Master Stabilization
- **Stories Completadas**: 0/8 en Sprint 2

## 🔄 Flujo de Trabajo

1. **Requirements** → Define qué construir
2. **Roadmap** → Planifica cuándo construir
3. **Epics** → Agrupa funcionalidad relacionada
4. **User Stories** → Define trabajo específico
5. **Backlog** → Prioriza trabajo pendiente

## 📝 Convenciones

- Stories: `{epic-number}-{story-number}-{name}.md`
- Epics: `{number}-{name}.md` para sub-epics
- Estados: draft → ready → current → completed
EOF

# README de epics
cat > docs/product/03-epics/README.md << 'EOF'
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
EOF

# README de user stories
cat > docs/product/05-user-stories/README.md << 'EOF'
# 📖 User Stories

## Organización por Estado

```
05-user-stories/
├── current-sprint/   # Sprint activo
├── ready/           # Listas para próximo sprint
├── draft/           # En refinamiento
└── completed/       # Entregadas
```

## Sprint Actual: Sprint 2

### Stories en Progreso
- [002-001 RSpec Setup](./current-sprint/sprint-002/story-002-001-rspec-setup.md)
- [002-002 Backend Tests](./current-sprint/sprint-002/story-002-002-backend-tests.md) 🔄
- [002-003 Jest Setup](./current-sprint/sprint-002/story-002-003-jest-setup.md)
- [002-004 Frontend Tests](./current-sprint/sprint-002/story-002-004-frontend-tests.md)

## Formato de Story

```
{epic-number}-{story-number}-{brief-name}.md
```

Ejemplo: `002-001-rspec-setup.md`
- Epic 002: Testing & CI/CD
- Story 001: Primera story del epic
- Nombre: Setup de RSpec

## Estados de Story

- **Draft**: En definición
- **Ready**: Lista para desarrollo
- **InProgress**: En desarrollo
- **Review**: En revisión de código
- **Done**: Completada y desplegada
EOF

# README de backlog
cat > docs/product/04-backlog/README.md << 'EOF'
# 📦 Backlog Management

## Tipos de Backlog

### [Product Backlog](./product-backlog.md)
Items de funcionalidad priorizados por valor de negocio

### [Technical Debt](./technical-debt.md)
Deuda técnica identificada y priorizada

### [Icebox](./icebox.md)
Ideas y features para futuro (no priorizadas)

## Priorización

- **P0**: Crítico - Bloqueador para producción
- **P1**: Alto - Necesario para MVP
- **P2**: Medio - Mejora significativa
- **P3**: Bajo - Nice to have

## Proceso

1. Items entran al Icebox
2. Se refinan y estiman
3. Se priorizan al Product Backlog
4. Se asignan a Sprints
5. Se mueven a User Stories
EOF

# Crear archivos vacíos necesarios
touch docs/product/01-requirements/vision.md
touch docs/product/01-requirements/success-metrics.md
touch docs/product/02-roadmap/milestones.md
touch docs/product/02-roadmap/release-plan.md
touch docs/product/04-backlog/product-backlog.md
touch docs/product/04-backlog/icebox.md

echo "✅ Archivos README creados"

# ============================================================
# PASO 5: LIMPIEZA
# ============================================================
echo ""
echo "🧹 Paso 5: Limpiando directorios vacíos..."

# Eliminar directorios vacíos
find docs -type d -empty -delete 2>/dev/null || true

# Eliminar directorio sprint antiguo si existe
[ -d "docs/sprint" ] && rm -rf docs/sprint

echo "✅ Limpieza completada"

# ============================================================
# PASO 6: REPORTE FINAL
# ============================================================
echo ""
echo "════════════════════════════════════════════════════════════════"
echo "✅ REORGANIZACIÓN COMPLETADA EXITOSAMENTE"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "📊 Resumen:"
echo "  - Archivos .md en docs/: $(find docs -name "*.md" -type f | wc -l)"
echo "  - Directorios creados: $(find docs -type d | wc -l)"
echo "  - Backup guardado en: ${BACKUP_FILE}"
echo ""
echo "📁 Nueva estructura:"
echo ""
tree docs -d -L 3 2>/dev/null || find docs -type d | head -20
echo ""
echo "⚠️  Próximos pasos:"
echo "  1. Revisar la nueva estructura en docs/"
echo "  2. Actualizar referencias rotas en el código"
echo "  3. Commitear cambios:"
echo "     git add ."
echo "     git commit -m 'refactor: reorganize documentation structure for scalability'"
echo "  4. Actualizar bookmarks del equipo"
echo "  5. Comunicar cambios al equipo"
echo ""
echo "🔄 Para revertir cambios:"
echo "  tar -xzf ${BACKUP_FILE}"
echo ""
echo "✨ ¡Documentación lista para escalar!"
echo "════════════════════════════════════════════════════════════════"