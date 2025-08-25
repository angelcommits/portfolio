# 🏃 Comandos del Flujo de Trabajo Scrum

## 📋 Tabla de Contenidos

1. [Configuración Inicial](#configuración-inicial)
2. [Ceremonias Scrum](#ceremonias-scrum)
3. [Gestión de Historias](#gestión-de-historias)
4. [Desarrollo TDD](#desarrollo-tdd)
5. [Testing y QA](#testing-y-qa)
6. [CI/CD y Deployment](#cicd-y-deployment)
7. [Comandos con Agentes BMad](#comandos-con-agentes-bmad)

---

## 🚀 Configuración Inicial

### Setup del Proyecto
```bash
# Clonar repositorio
git clone [repository-url]
cd portfolio-backend

# Instalar dependencias
bundle install
yarn install

# Setup de base de datos
rails db:create db:migrate db:seed

# Configurar ambiente
cp .env.example .env
# Editar .env con configuraciones

# Verificar setup
rails db:migrate:status
bundle exec rspec --init
```

### Configurar Git Flow
```bash
# Inicializar git flow
git flow init

# Crear rama de desarrollo
git checkout -b develop

# Configurar hooks
cp .github/hooks/pre-commit .git/hooks/
chmod +x .git/hooks/pre-commit
```

---

## 📅 Ceremonias Scrum

### 1. Sprint Planning
```bash
# Crear nuevo sprint
SPRINT_NUM=2
mkdir -p docs/sprints/sprint-${SPRINT_NUM}

# Crear backlog del sprint
cat > docs/sprints/sprint-${SPRINT_NUM}/backlog.md << EOF
# Sprint ${SPRINT_NUM} Backlog
Date: $(date +%Y-%m-%d)
Duration: 2 weeks
Goal: [Sprint Goal]

## User Stories
- [ ] Story 002-001: RSpec Setup (8 pts)
- [ ] Story 002-002: Backend Tests (13 pts)
- [ ] Story 002-003: Jest Setup (5 pts)

## Capacity: 40 points
## Committed: 26 points
EOF

# Commitear plan
git add .
git commit -m "docs: sprint ${SPRINT_NUM} planning complete"
```

### 2. Daily Standup
```bash
# Crear standup diario
DATE=$(date +%Y-%m-%d)
cp docs/resources/templates/daily-standup-template.md \
   docs/sprints/active/sprint-${SPRINT_NUM}/standup-${DATE}.md

# Verificar blockers
echo "=== BLOCKERS ==="
grep -r "BLOCKER\|BLOCKED" docs/product/user-stories/ --include="*.md"

# Ver progreso del sprint
echo "=== SPRINT PROGRESS ==="
grep -r "Status:" docs/product/05-user-stories/current-sprint/ --include="*.md"

# Actualizar burndown (si tienes script)
rails runner "Sprint.current.update_burndown" 2>/dev/null || \
  echo "Manual burndown update needed"
```

### 3. Sprint Review
```bash
# Generar reporte del sprint
SPRINT_NUM=2
cat > docs/sprints/sprint-${SPRINT_NUM}/review.md << EOF
# Sprint ${SPRINT_NUM} Review
Date: $(date +%Y-%m-%d)

## Completed Stories
$(grep -l "Status: Done" docs/product/05-user-stories/current-sprint/sprint-${SPRINT_NUM}/*.md)

## Demo Items
- Feature 1: [Description]
- Feature 2: [Description]

## Metrics
- Velocity: X points
- Stories Completed: X/Y
- Test Coverage: X%
EOF

# Preparar demo
git checkout staging
git merge develop
cap staging deploy  # O tu comando de deploy

# Generar métricas
bundle exec rails stats
bundle exec rspec --format documentation > sprint-test-report.txt
```

### 4. Sprint Retrospective
```bash
# Crear documento de retrospectiva
SPRINT_NUM=2
cp docs/resources/templates/retrospective-template.md \
   docs/sprints/sprint-${SPRINT_NUM}/retrospective.md

# Analizar métricas del sprint
echo "=== SPRINT METRICS ==="
echo "Commits: $(git rev-list --count --since='2 weeks ago' HEAD)"
echo "PRs Merged: $(gh pr list --state merged --limit 100 | grep -c "ago")"
echo "Test Coverage: $(grep -o '[0-9]*\.[0-9]*%' coverage/.last_run.json 2>/dev/null || echo 'N/A')"

# Cerrar sprint
git checkout main
git merge --no-ff develop -m "chore: close sprint ${SPRINT_NUM}"
git tag -a "v0.${SPRINT_NUM}.0" -m "Sprint ${SPRINT_NUM} release"
git push origin main --tags
```

---

## 📝 Gestión de Historias

### Crear Nueva Historia
```bash
# Con Scrum Master Agent (BMad)
# Activar SM agent y crear historia
echo "Activando Scrum Master agent..."
# En tu herramienta de IA: /bmad:agents:sm draft

# Manualmente
EPIC_NUM=002
STORY_NUM=001
STORY_NAME="rspec-setup"

cat > docs/product/05-user-stories/draft/${EPIC_NUM}-${STORY_NUM}-${STORY_NAME}.md << EOF
# Story ${EPIC_NUM}.${STORY_NUM}: ${STORY_NAME}

**Status**: Draft
**Epic**: ${EPIC_NUM}
**Points**: TBD

## Story
As a [role]
I want [feature]
So that [benefit]

## Acceptance Criteria
- [ ] AC1
- [ ] AC2
- [ ] AC3

## Tasks
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

## Dev Notes
[Technical context]

## Testing
[Test approach]
EOF
```

### Mover Historia a Desarrollo
```bash
# Cambiar estado de historia
STORY_FILE="docs/product/05-user-stories/current-sprint/sprint-002/002-001-rspec-setup.md"

# Actualizar estado
sed -i 's/Status: Draft/Status: InProgress/' ${STORY_FILE}

# Crear rama de feature
git checkout -b feature/story-002-001-rspec-setup

# Commitear cambio
git add ${STORY_FILE}
git commit -m "chore: start story 002-001 rspec setup"
```

### Validar Historia
```bash
# Con BMad Scrum Master
# /bmad:agents:sm story-checklist

# Checklist manual
echo "=== STORY VALIDATION ==="
STORY_FILE="docs/product/05-user-stories/current-sprint/sprint-002/002-001-rspec-setup.md"

echo "Checking: ${STORY_FILE}"
echo -n "Has Acceptance Criteria: "
grep -q "Acceptance Criteria" ${STORY_FILE} && echo "✅" || echo "❌"

echo -n "Has Tasks: "
grep -q "Tasks" ${STORY_FILE} && echo "✅" || echo "❌"

echo -n "Has Dev Notes: "
grep -q "Dev Notes" ${STORY_FILE} && echo "✅" || echo "❌"

echo -n "Has Testing: "
grep -q "Testing" ${STORY_FILE} && echo "✅" || echo "❌"
```

---

## 💻 Desarrollo TDD

### Ciclo TDD Completo
```bash
# 1. Escribir test que falla
FEATURE="user_authentication"
cat > spec/features/${FEATURE}_spec.rb << 'EOF'
require 'rails_helper'

RSpec.describe "UserAuthentication", type: :feature do
  it "allows user to login with valid credentials" do
    user = create(:user, email: "test@example.com", password: "password123")
    
    visit login_path
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password123"
    click_button "Login"
    
    expect(page).to have_content("Welcome")
    expect(current_path).to eq(dashboard_path)
  end
end
EOF

# 2. Ver test fallar (RED)
bundle exec rspec spec/features/${FEATURE}_spec.rb

# 3. Implementar código mínimo (GREEN)
rails generate controller Sessions new create destroy
rails generate model User email:string password_digest:string

# Editar controlador y modelo...

# 4. Hacer pasar el test
bundle exec rspec spec/features/${FEATURE}_spec.rb

# 5. Refactorizar (REFACTOR)
bundle exec rubocop -a app/controllers/sessions_controller.rb
bundle exec rubocop -a app/models/user.rb

# 6. Verificar que todo sigue pasando
bundle exec rspec

# 7. Commit con mensaje semántico
git add .
git commit -m "feat(auth): implement user login functionality

- Add Sessions controller with login/logout
- Add User model with secure password
- Add feature specs for authentication flow
- Story: 002-001"
```

### Desarrollo con BMad Developer Agent
```bash
# Activar Developer agent
# /bmad:agents:dev develop-story

# El agent ejecutará:
# 1. Leer primera tarea
# 2. Implementar tarea y subtareas
# 3. Escribir tests
# 4. Ejecutar validaciones
# 5. Marcar checkbox [x] si pasa
# 6. Actualizar File List
# 7. Repetir hasta completar

# Para explicación detallada
# /bmad:agents:dev explain
```

---

## 🧪 Testing y QA

### Suite de Testing Completa
```bash
# Preparar ambiente de test
RAILS_ENV=test rails db:migrate

# 1. Unit Tests
echo "=== UNIT TESTS ==="
bundle exec rspec spec/models/ --format documentation
bundle exec rspec spec/services/ --format documentation

# 2. Integration Tests
echo "=== INTEGRATION TESTS ==="
bundle exec rspec spec/requests/ --format documentation
bundle exec rspec spec/integration/ --format documentation

# 3. System Tests (E2E)
echo "=== SYSTEM TESTS ==="
bundle exec rspec spec/system/ --format documentation

# 4. Frontend Tests (si aplica)
echo "=== FRONTEND TESTS ==="
yarn test
yarn cypress:run

# 5. Coverage Report
echo "=== COVERAGE REPORT ==="
COVERAGE=true bundle exec rspec
open coverage/index.html

# 6. Linting y Code Quality
echo "=== CODE QUALITY ==="
bundle exec rubocop
bundle exec brakeman --no-pager
bundle exec rails_best_practices .
yarn eslint . --ext .js,.jsx,.ts,.tsx
```

### QA con BMad Agent
```bash
# Activar QA agent para review
# /bmad:agents:qa review-story 002-001

# El QA agent verificará:
# - Acceptance criteria cumplidos
# - Tests adecuados
# - Code coverage
# - Standards compliance
# - Documentation
```

### Regression Testing
```bash
# Ejecutar suite completa de regresión
cat > bin/regression-test << 'EOF'
#!/bin/bash
echo "🧪 Running Full Regression Suite"

# Backend tests
bundle exec rspec

# Frontend tests
yarn test --watchAll=false

# E2E tests
yarn cypress:run

# Security scan
bundle exec brakeman

# Performance check
ab -n 100 -c 10 http://localhost:3000/api/health

echo "✅ Regression testing complete"
EOF

chmod +x bin/regression-test
./bin/regression-test
```

---

## 🚀 CI/CD y Deployment

### GitHub Actions CI
```bash
# Verificar CI localmente
act -j test  # Requiere nektos/act instalado

# Trigger manual workflow
gh workflow run ci.yml

# Ver status
gh run list --limit 5
gh run view  # Interactivo

# Ver logs de un job específico
gh run view [run-id] --log
```

### Pre-commit Checks
```bash
# Crear script de pre-commit
cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
echo "Running pre-commit checks..."

# Linting
bundle exec rubocop --parallel

# Tests rápidos
bundle exec rspec spec/models/ --fail-fast

# Security
bundle exec brakeman --quiet --no-pager

echo "Pre-commit checks passed ✅"
EOF

chmod +x .git/hooks/pre-commit
```

### Pull Request Flow
```bash
# Crear PR
STORY_NUM="002-001"
git push -u origin feature/story-${STORY_NUM}

gh pr create \
  --title "Story ${STORY_NUM}: Implement RSpec setup" \
  --body "## Description
  Implements story ${STORY_NUM}
  
  ## Checklist
  - [ ] Tests passing
  - [ ] Code reviewed
  - [ ] Documentation updated
  
  ## Story
  [Link to story file]" \
  --assignee @me \
  --label "story,testing"

# Review PR
gh pr checks  # Ver CI status
gh pr diff    # Ver cambios
gh pr review --comment -b "LGTM! 🚀"

# Merge cuando esté listo
gh pr merge --squash --delete-branch
```

### Deployment
```bash
# Staging deployment
cap staging deploy
cap staging deploy:migrate

# Verificar health
curl https://staging.example.com/health

# Production deployment (con aprobación)
echo "⚠️  Production deployment - requires approval"
read -p "Deploy to production? [y/N] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    cap production deploy
    cap production deploy:migrate
    
    # Smoke tests
    curl https://api.example.com/health
    rails runner "HealthCheck.run" RAILS_ENV=production
fi

# Rollback si necesario
cap production deploy:rollback
```

---

## 🤖 Comandos con Agentes BMad

### Activar Agentes
```bash
# En tu herramienta de IA, usar estos comandos:

# Scrum Master - Gestión de historias
/bmad:agents:sm help
/bmad:agents:sm draft           # Crear nueva historia
/bmad:agents:sm story-checklist # Validar historia
/bmad:agents:sm correct-course  # Manejar cambios

# Developer - Implementación
/bmad:agents:dev help
/bmad:agents/dev develop-story  # Implementar historia
/bmad:agents/dev review-qa      # Aplicar fixes de QA
/bmad:agents:dev run-tests      # Ejecutar tests

# QA - Quality Assurance
/bmad:agents:qa help
/bmad:agents:qa review          # Revisar implementación
/bmad:agents:qa test-plan       # Crear plan de pruebas

# Architect - Arquitectura
/bmad:agents:architect help
/bmad:agents:architect review   # Revisar arquitectura
/bmad:agents:architect design   # Diseñar solución

# Product Owner
/bmad:agents:po help
/bmad:agents:po prioritize      # Priorizar backlog
/bmad:agents:po accept          # Aceptar historias
```

### Workflow Completo con Agentes
```bash
# 1. Planning (PO + SM)
/bmad:agents:po prioritize-backlog
/bmad:agents:sm draft

# 2. Development (Dev)
git checkout -b feature/story-X
/bmad:agents:dev develop-story

# 3. Testing (QA)
/bmad:agents:qa review
/bmad:agents:dev review-qa  # Si hay fixes

# 4. Review (Architect + SM)
/bmad:agents:architect review
/bmad:agents:sm story-checklist

# 5. Acceptance (PO)
/bmad:agents:po accept
```

---

## 📊 Métricas y Reportes

### Generar Métricas del Sprint
```bash
# Velocity
echo "=== SPRINT VELOCITY ==="
COMPLETED=$(grep -l "Status: Done" docs/product/05-user-stories/current-sprint/sprint-*/*.md | wc -l)
echo "Stories Completed: ${COMPLETED}"

# Test Coverage Trend
echo "=== COVERAGE TREND ==="
for report in coverage/coverage-*.json; do
    date=$(basename $report .json | cut -d- -f2-)
    coverage=$(jq '.metrics.covered_percent' $report)
    echo "$date: $coverage%"
done

# Code Quality
bundle exec rubocop --format json > tmp/rubocop.json
echo "=== CODE QUALITY ==="
echo "Offenses: $(jq '.summary.offense_count' tmp/rubocop.json)"

# Performance
echo "=== PERFORMANCE ==="
ab -n 100 -c 10 -g tmp/perf.tsv http://localhost:3000/api/health
gnuplot tmp/perf.plot  # Si tienes gnuplot configurado
```

### Dashboard de Proyecto
```bash
# Crear dashboard simple
cat > bin/project-dashboard << 'EOF'
#!/bin/bash
clear
echo "═══════════════════════════════════════════════════════"
echo "          📊 PORTFOLIO PROJECT DASHBOARD"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "📅 SPRINT: $(ls -d docs/sprints/active/* | tail -1 | xargs basename)"
echo "📈 VELOCITY: $(grep -l "Status: Done" docs/product/05-user-stories/current-sprint/*/*.md 2>/dev/null | wc -l) stories"
echo "🧪 COVERAGE: $(grep -o '[0-9]*\.[0-9]*' coverage/.last_run.json 2>/dev/null || echo 'N/A')%"
echo "🐛 ISSUES: $(gh issue list --limit 100 | wc -l) open"
echo "🔀 PRs: $(gh pr list | wc -l) pending"
echo ""
echo "═══════════════════════════════════════════════════════"
EOF

chmod +x bin/project-dashboard
./bin/project-dashboard
```

---

## 🔧 Comandos Útiles Adicionales

### Gestión de Dependencias
```bash
# Ruby/Rails
bundle outdated
bundle update --conservative
bundle audit check --update

# JavaScript/Node
yarn outdated
yarn upgrade-interactive --latest
yarn audit
```

### Database Management
```bash
# Backup
pg_dump -h localhost -U postgres portfolio_development > backup.sql

# Restore
psql -h localhost -U postgres portfolio_development < backup.sql

# Migrations
rails generate migration AddFieldToModel field:type
rails db:migrate
rails db:rollback STEP=1
rails db:migrate:status
```

### Debugging
```bash
# Rails console
rails console
rails console --sandbox  # No persiste cambios

# Logs
tail -f log/development.log
tail -f log/test.log | grep -E "ERROR|FAIL"

# Debugging en código
# Agregar en Gemfile: gem 'pry-rails'
# En código: binding.pry
```

### Performance
```bash
# Profiling
bundle exec derailed bundle:mem
bundle exec derailed bundle:objects

# Benchmarking
rails runner "Benchmark.bm { |x| x.report { 1000.times { User.all.to_a } } }"

# Query analysis
rails runner "ActiveRecord::Base.logger = Logger.new(STDOUT); User.all.to_a"
```

---

**Última Actualización**: 2025-01-25  
**Versión**: 1.0.0  
**Mantenido por**: DevOps Team