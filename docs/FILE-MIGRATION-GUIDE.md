# 📁 Guía de Migración de Archivos

## 🎯 Archivos Específicos a Reorganizar

### 1. README-backend.md
**Ubicación Actual**: `/portfolio/README-backend.md`  
**Nueva Ubicación**: `/portfolio/docs/api/README-backend.md`  
**Razón**: Documentación de API debe estar en su propia sección

```bash
# Comando de migración
mkdir -p docs/api
mv README-backend.md docs/api/README-backend.md

# Actualizar referencias
grep -r "README-backend.md" . --exclude-dir=.git | \
  xargs sed -i 's|README-backend.md|docs/api/README-backend.md|g'
```

### 2. Archivos TASK-005
**Archivos**:
- `TASK-005-Integration-Tests-COMPLETE.md`
- `TASK-005-QA-Enhancements-COMPLETE.md`

**Nueva Ubicación**: `/portfolio/docs/sprints/completed/sprint-001/tasks/`  
**Razón**: Son reportes de tareas completadas del Sprint 1

```bash
# Comando de migración
mkdir -p docs/sprints/completed/sprint-001/tasks
mv TASK-005-Integration-Tests-COMPLETE.md docs/sprints/completed/sprint-001/tasks/
mv TASK-005-QA-Enhancements-COMPLETE.md docs/sprints/completed/sprint-001/tasks/

# Crear índice
cat > docs/sprints/completed/sprint-001/tasks/README.md << 'EOF'
# Sprint 1 - Completed Tasks

## TASK-005: Integration & QA
- [Integration Tests Report](./TASK-005-Integration-Tests-COMPLETE.md)
- [QA Enhancements Report](./TASK-005-QA-Enhancements-COMPLETE.md)

**Completion Date**: August 24, 2025
**Coverage Achieved**: 95/100 QA Score
EOF
```

### 3. Reorganización de docs/product

#### 3.1 Product Requirements
```bash
# Crear nueva estructura
mkdir -p docs/product/01-requirements

# Mover y renombrar
mv docs/product/product-requirements.md docs/product/01-requirements/PRD.md

# Crear archivos complementarios
touch docs/product/01-requirements/vision.md
touch docs/product/01-requirements/success-metrics.md
```

#### 3.2 Roadmap
```bash
# Mantener ubicación pero mejorar estructura
mkdir -p docs/product/02-roadmap
mv docs/product/roadmap/* docs/product/02-roadmap/

# Crear archivos adicionales
touch docs/product/02-roadmap/milestones.md
touch docs/product/02-roadmap/release-plan.md
```

#### 3.3 Epics
```bash
# Crear estructura de epics
mkdir -p docs/product/03-epics/active/sub-epics
mkdir -p docs/product/03-epics/completed

# Mover epics activos
mv docs/product/epics/master-stabilization.md docs/product/03-epics/active/
mv docs/product/epics/sub-epic-*.md docs/product/03-epics/active/sub-epics/

# Renombrar para consistencia
cd docs/product/03-epics/active/sub-epics/
for file in sub-epic-*.md; do
  new_name=$(echo $file | sed 's/sub-epic-//')
  mv "$file" "$new_name"
done
```

#### 3.4 Backlog
```bash
# Crear estructura de backlog
mkdir -p docs/product/04-backlog

# Mover archivos existentes
mv docs/product/backlog/TECHNICAL-DEBT-BACKLOG.md docs/product/04-backlog/technical-debt.md

# Crear archivos adicionales
touch docs/product/04-backlog/product-backlog.md
touch docs/product/04-backlog/icebox.md
```

#### 3.5 User Stories
```bash
# Crear estructura por estado
mkdir -p docs/product/05-user-stories/{current-sprint/sprint-002,ready,draft,completed}

# Mover stories actuales
mv docs/product/user-stories/story-002-*.md docs/product/05-user-stories/current-sprint/sprint-002/
mv docs/product/user-stories/story-002-002-tasks docs/product/05-user-stories/current-sprint/sprint-002/tasks

# Crear README para cada sección
for dir in current-sprint ready draft completed; do
  echo "# User Stories - ${dir^}" > docs/product/05-user-stories/$dir/README.md
done
```

### 4. Resources y Archive
```bash
# Ya están en ubicación correcta, solo verificar
ls -la docs/resources/archive/
ls -la docs/resources/external-audits/

# Si no existen, crear
mkdir -p docs/resources/{archive,external-audits,templates}
```

## 🔄 Script de Migración Completo

```bash
#!/bin/bash
# migrate-docs.sh

echo "📦 Creating backup..."
tar -czf docs-backup-$(date +%Y%m%d-%H%M%S).tar.gz docs/ README-backend.md TASK-005-*.md

echo "📁 Creating new structure..."
# Product structure
mkdir -p docs/product/{01-requirements,02-roadmap,04-backlog}
mkdir -p docs/product/03-epics/{active/sub-epics,completed}
mkdir -p docs/product/05-user-stories/{current-sprint/sprint-002,ready,draft,completed}

# Sprint structure
mkdir -p docs/sprints/{active/sprint-002,completed/sprint-001/tasks,reports}

# API docs
mkdir -p docs/api

echo "🚚 Moving files..."
# Move README-backend
[ -f README-backend.md ] && mv README-backend.md docs/api/

# Move TASK-005 files
[ -f TASK-005-Integration-Tests-COMPLETE.md ] && \
  mv TASK-005-Integration-Tests-COMPLETE.md docs/sprints/completed/sprint-001/tasks/
[ -f TASK-005-QA-Enhancements-COMPLETE.md ] && \
  mv TASK-005-QA-Enhancements-COMPLETE.md docs/sprints/completed/sprint-001/tasks/

# Move product files
[ -f docs/product/product-requirements.md ] && \
  mv docs/product/product-requirements.md docs/product/01-requirements/PRD.md

# Move epics
if [ -d docs/product/epics ]; then
  mv docs/product/epics/master-stabilization.md docs/product/03-epics/active/ 2>/dev/null
  mv docs/product/epics/sub-epic-*.md docs/product/03-epics/active/sub-epics/ 2>/dev/null
fi

# Move backlog
if [ -f docs/product/backlog/TECHNICAL-DEBT-BACKLOG.md ]; then
  mv docs/product/backlog/TECHNICAL-DEBT-BACKLOG.md docs/product/04-backlog/technical-debt.md
fi

# Move user stories
if [ -d docs/product/user-stories ]; then
  mv docs/product/user-stories/story-002-*.md \
     docs/product/05-user-stories/current-sprint/sprint-002/ 2>/dev/null
  [ -d docs/product/user-stories/story-002-002-tasks ] && \
    mv docs/product/user-stories/story-002-002-tasks \
       docs/product/05-user-stories/current-sprint/sprint-002/tasks
fi

echo "📝 Creating README files..."
# Create navigation READMEs
cat > docs/product/README.md << 'EOF'
# Product Documentation

## 📁 Structure
- **01-requirements/** - Product requirements and vision documents
- **02-roadmap/** - Product roadmap and release planning
- **03-epics/** - Epic definitions and tracking
- **04-backlog/** - Product and technical backlogs
- **05-user-stories/** - User stories organized by status

## 🔗 Quick Links
- [Current Sprint Stories](./05-user-stories/current-sprint/)
- [Product Roadmap](./02-roadmap/)
- [Active Epics](./03-epics/active/)
- [Product Backlog](./04-backlog/product-backlog.md)
EOF

echo "🧹 Cleaning up empty directories..."
find docs -type d -empty -delete

echo "✅ Migration complete!"
echo "📊 Summary:"
find docs -type f -name "*.md" | wc -l
echo " markdown files organized"

echo ""
echo "⚠️  Next steps:"
echo "1. Review the new structure in docs/"
echo "2. Update any broken references in code"
echo "3. Commit changes: git add . && git commit -m 'refactor: reorganize documentation structure'"
echo "4. Update team bookmarks and documentation"
```

## 📋 Checklist de Validación Post-Migración

- [ ] Backup creado exitosamente
- [ ] README-backend.md movido a docs/api/
- [ ] TASK-005 archivos movidos a sprints/completed
- [ ] Product requirements renombrado a PRD.md
- [ ] Epics reorganizados en active/completed
- [ ] User stories organizadas por estado
- [ ] Backlog reestructurado
- [ ] READMEs de navegación creados
- [ ] Links internos actualizados
- [ ] CI/CD paths actualizados
- [ ] Equipo notificado del cambio

## 🚨 Rollback Plan

Si algo sale mal:
```bash
# Restaurar desde backup
tar -xzf docs-backup-[timestamp].tar.gz
git checkout -- .
```

---

**Estado**: LISTO PARA EJECUTAR  
**Fecha**: 2025-01-25  
**Riesgo**: Bajo (con backup)