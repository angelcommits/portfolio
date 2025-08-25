#!/bin/bash
# qa-cleanup.sh - QA-identified cleanup actions
# Date: 2025-08-25
# Purpose: Move completed stories and reorganize sprint reports

set -e

echo "════════════════════════════════════════════════════════════════"
echo "🧹 QA CLEANUP - Moving Completed Stories & Reports"
echo "📅 Date: August 25, 2025"
echo "════════════════════════════════════════════════════════════════"

# Create backup first
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
BACKUP_FILE="qa-cleanup-backup-${TIMESTAMP}.tar.gz"

echo "📦 Creating backup..."
tar -czf "${BACKUP_FILE}" docs/product/05-user-stories/ docs/sprints/ 2>/dev/null || true
echo "✅ Backup created: ${BACKUP_FILE}"

echo ""
echo "📁 Step 1: Creating completed stories directory..."
mkdir -p docs/product/05-user-stories/completed/sprint-002

echo ""
echo "🚚 Step 2: Moving completed stories..."

# Move completed stories
completed_stories=(
    "story-002-001-rspec-setup.md"
    "story-002-003-jest-setup.md"
    "story-002-005-ci-pipeline.md"
    "story-002-007-deployment.md"
)

for story in "${completed_stories[@]}"; do
    if [ -f "docs/product/05-user-stories/current-sprint/sprint-002/${story}" ]; then
        mv "docs/product/05-user-stories/current-sprint/sprint-002/${story}" \
           "docs/product/05-user-stories/completed/sprint-002/"
        echo "  ✓ Moved ${story} to completed/"
    fi
done

echo ""
echo "🚚 Step 3: Reorganizing sprint reports..."

# Move misplaced TASK reports
if [ -f "docs/sprints/completed/TASK-004-COMPLETION-REPORT.md" ]; then
    mv docs/sprints/completed/TASK-004-COMPLETION-REPORT.md \
       docs/sprints/completed/sprint-001/tasks/
    echo "  ✓ Moved TASK-004-COMPLETION-REPORT to sprint-001/tasks/"
fi

if [ -f "docs/sprints/completed/TASK-005-INTEGRATION-STRATEGY.md" ]; then
    mv docs/sprints/completed/TASK-005-INTEGRATION-STRATEGY.md \
       docs/sprints/completed/sprint-001/tasks/
    echo "  ✓ Moved TASK-005-INTEGRATION-STRATEGY to sprint-001/tasks/"
fi

# Rename inconsistent task folders to match convention
if [ -d "docs/sprints/completed/task-002" ]; then
    mkdir -p docs/sprints/completed/sprint-001/task-002
    mv docs/sprints/completed/task-002/* docs/sprints/completed/sprint-001/task-002/ 2>/dev/null || true
    rmdir docs/sprints/completed/task-002 2>/dev/null || true
    echo "  ✓ Moved task-002 to sprint-001/task-002/"
fi

if [ -d "docs/sprints/completed/task-003" ]; then
    mkdir -p docs/sprints/completed/sprint-001/task-003
    mv docs/sprints/completed/task-003/* docs/sprints/completed/sprint-001/task-003/ 2>/dev/null || true
    rmdir docs/sprints/completed/task-003 2>/dev/null || true
    echo "  ✓ Moved task-003 to sprint-001/task-003/"
fi

if [ -d "docs/sprints/completed/task-004" ]; then
    mkdir -p docs/sprints/completed/sprint-001/task-004
    mv docs/sprints/completed/task-004/* docs/sprints/completed/sprint-001/task-004/ 2>/dev/null || true
    rmdir docs/sprints/completed/task-004 2>/dev/null || true
    echo "  ✓ Moved task-004 to sprint-001/task-004/"
fi

echo ""
echo "📝 Step 4: Updating Epic 002 stories references..."

# Update the stories.md file in Epic 002
cat > docs/product/03-epics/active/002-testing-cicd/stories.md << 'EOF'
# Epic 002 - User Stories

## Active Stories (Sprint 2)

### In Current Sprint
- [002-002 Backend Tests](../../05-user-stories/current-sprint/sprint-002/story-002-002-backend-tests.md) 🔄 (15%)
- [002-004 Frontend Tests](../../05-user-stories/current-sprint/sprint-002/story-002-004-frontend-tests.md) ⏳
- [002-006 E2E Cypress](../../05-user-stories/current-sprint/sprint-002/story-002-006-e2e-cypress.md) ⏳
- [002-008 Performance](../../05-user-stories/current-sprint/sprint-002/story-002-008-performance.md) ⏳

### Completed Stories (Sprint 2)
- [002-001 RSpec Setup](../../05-user-stories/completed/sprint-002/story-002-001-rspec-setup.md) ✅
- [002-003 Jest Setup](../../05-user-stories/completed/sprint-002/story-002-003-jest-setup.md) ✅
- [002-005 CI Pipeline](../../05-user-stories/completed/sprint-002/story-002-005-ci-pipeline.md) ✅
- [002-007 Deployment](../../05-user-stories/completed/sprint-002/story-002-007-deployment.md) ✅

### Backlog Items
- Integration test improvements
- Coverage reporting automation
- Performance benchmarking suite

---
*Last Updated: 2025-08-25*
*Completed: 4 of 8 stories (50%)*
EOF

echo "✅ Updated Epic 002 stories references"

echo ""
echo "📊 Step 5: Creating Sprint 2 Status Report..."

cat > docs/sprints/active/sprint-002/status.md << 'EOF'
# Sprint 2 Status Report

**Date**: August 25, 2025  
**Sprint**: 2 - Testing & CI/CD  
**Week**: 2-3 of 7-week plan  

## 📊 Progress Summary

### Stories Status
| Story | Status | Progress | Notes |
|-------|--------|----------|-------|
| 002-001 RSpec Setup | ✅ Completed | 100% | Moved to completed |
| 002-002 Backend Tests | 🔄 In Progress | 15% | Current focus |
| 002-003 Jest Setup | ✅ Completed | 100% | Moved to completed |
| 002-004 Frontend Tests | ⏳ Pending | 0% | Next priority |
| 002-005 CI Pipeline | ✅ Completed | 100% | Moved to completed |
| 002-006 E2E Cypress | ⏳ Pending | 0% | Blocked by frontend tests |
| 002-007 Deployment | ✅ Completed | 100% | Moved to completed |
| 002-008 Performance | ⏳ Pending | 0% | Final sprint item |

### Metrics
- **Stories Completed**: 4 of 8 (50%)
- **Test Coverage**: ~15% (target: 80%)
- **Sprint Velocity**: On track

### Next Actions
1. Complete backend tests (story 002-002)
2. Start frontend tests (story 002-004)
3. Review coverage metrics

---
*Generated: 2025-08-25*
EOF

echo "✅ Created Sprint 2 status report"

echo ""
echo "🧹 Step 6: Cleaning empty directories..."
find docs -type d -empty -delete 2>/dev/null || true

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "✅ QA CLEANUP COMPLETED"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "Summary of changes:"
echo "  ✓ 4 completed stories moved to completed/"
echo "  ✓ Sprint reports reorganized under sprint-001/"
echo "  ✓ Epic 002 stories references updated"
echo "  ✓ Sprint 2 status report created"
echo ""
echo "📦 Backup saved as: ${BACKUP_FILE}"
echo ""
echo "Next steps:"
echo "  1. Review remaining 4 stories for completion status"
echo "  2. Update story 002-002 progress (currently at 15%)"
echo "  3. Commit changes: git add . && git commit -m 'chore: move completed stories and reorganize sprint reports'"
echo ""