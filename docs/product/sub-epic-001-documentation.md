# SUB-EPIC-001: Documentation Consolidation and Standardization

## Epic Information
- **Parent Epic**: EPIC-001 - Portfolio as a Service Stabilization
- **Epic ID**: SUB-EPIC-001
- **Priority**: P0 - Critical (Foundation for all work)
- **Duration**: 1 week
- **Status**: IN PROGRESS

## Goal
Consolidate all scattered documentation from multiple directories into a single, coherent structure that serves as the source of truth for the project, enabling efficient development and onboarding.

## Background Context

### Current State
- 120+ documentation files in `portfolio-backend/docs/`
- Additional docs in `portfolio-backend/.docs/` (possibly duplicated)
- Empty or minimal docs in `portfolio-frontend/.docs/`
- No unified structure or naming conventions
- Information is duplicated, outdated, or contradictory
- No clear product vision or roadmap document

### Target State
- Single `/docs` directory at project root
- Clear categorization (product, architecture, api, development)
- Standardized naming conventions
- No duplicate information
- Up-to-date and accurate content
- Clear README files for navigation

## User Stories

### STORY-001: Documentation Audit and Inventory
**As a** technical lead  
**I want to** audit all existing documentation  
**So that** we understand what content exists and what's valuable

**Acceptance Criteria:**
- [ ] Complete inventory of all .md files in all doc directories
- [ ] Categorization of docs by type (product, technical, process)
- [ ] Identification of duplicate content
- [ ] Assessment of content quality and relevance
- [ ] List of outdated documents to archive
- [ ] Spreadsheet with findings and recommendations

**Estimation:** 4 hours

---

### STORY-002: Create Unified Documentation Structure
**As a** development team  
**I want to** have a standardized documentation structure  
**So that** information is easily discoverable and maintainable

**Acceptance Criteria:**
- [ ] `/docs` directory created at project root
- [ ] Subdirectories created: product/, architecture/, api/, development/
- [ ] Template files created for common document types
- [ ] Naming convention documented and applied
- [ ] Symlinks created from sub-projects to main docs
- [ ] .gitignore updated appropriately

**Estimation:** 2 hours

---

### STORY-003: Consolidate Product Documentation
**As a** product owner  
**I want to** have all product documentation in one place  
**So that** product vision and requirements are clear

**Acceptance Criteria:**
- [ ] PRD documents consolidated and updated
- [ ] Roadmap extracted from multiple files into single document
- [ ] User stories/features documented
- [ ] Product vision statement created
- [ ] Competitive analysis consolidated (if exists)
- [ ] All product docs in `/docs/product/`

**Tasks:**
1. Extract roadmap from 15+ files in `portfolio-backend/docs/roadmap/`
2. Consolidate workbook tasks into actionable items
3. Create product vision from scattered information
4. Update brownfield PRD with latest decisions

**Estimation:** 6 hours

---

### STORY-004: Consolidate Technical Documentation
**As a** developer  
**I want to** have clear technical documentation  
**So that** I can understand and work with the system effectively

**Acceptance Criteria:**
- [ ] Architecture documents consolidated
- [ ] API documentation unified (Swagger specs)
- [ ] Database schema documented
- [ ] Technology decisions recorded (ADRs)
- [ ] Integration guides consolidated
- [ ] All technical docs in `/docs/architecture/` and `/docs/api/`

**Tasks:**
1. Merge authentication docs from `portfolio-backend/docs/auth/`
2. Consolidate GPT/AI integration docs
3. Extract and update API documentation
4. Create current database schema documentation
5. Document Twilio integration

**Estimation:** 8 hours

---

### STORY-005: Create Development and Operations Guides
**As a** new developer  
**I want to** have clear setup and development guides  
**So that** I can quickly become productive

**Acceptance Criteria:**
- [ ] Development environment setup guide created
- [ ] Testing strategy and guide documented
- [ ] Deployment procedures documented
- [ ] Troubleshooting guide created
- [ ] Contributing guidelines established
- [ ] All guides in `/docs/development/`

**Tasks:**
1. Create comprehensive setup guide for both backend and frontend
2. Document testing approach and commands
3. Create deployment runbook
4. Write troubleshooting FAQ
5. Establish contribution guidelines

**Estimation:** 6 hours

---

### STORY-006: Archive and Clean Legacy Documentation
**As a** technical lead  
**I want to** archive outdated documentation  
**So that** only relevant information is maintained

**Acceptance Criteria:**
- [ ] Legacy docs moved to `/docs/archive/` with date stamp
- [ ] Duplicate files removed
- [ ] Old directories cleaned up
- [ ] Git history preserved for reference
- [ ] Archive README explains content
- [ ] Main README updated with current structure

**Tasks:**
1. Create `/docs/archive/2025-01-legacy/`
2. Move outdated docs with preservation notes
3. Delete duplicate files after verification
4. Clean up empty directories
5. Update all README files

**Estimation:** 3 hours

---

### STORY-007: Create Documentation Index and Navigation
**As a** team member  
**I want to** easily navigate documentation  
**So that** I can find information quickly

**Acceptance Criteria:**
- [ ] Main README with documentation map created
- [ ] Category README files with indexes created
- [ ] Cross-references between documents added
- [ ] Search keywords/tags added to documents
- [ ] Quick start guide created
- [ ] Documentation standards guide created

**Estimation:** 4 hours

## Technical Approach

### Migration Strategy
1. **Phase 1**: Inventory and categorize (don't move yet)
2. **Phase 2**: Create new structure
3. **Phase 3**: Copy and consolidate valuable content
4. **Phase 4**: Archive old structure
5. **Phase 5**: Update references and links

### Tools and Scripts
```bash
# Find all markdown files
find . -name "*.md" -type f > doc_inventory.txt

# Check for duplicates
md5sum **/*.md | sort | uniq -d

# Create structure
mkdir -p docs/{product,architecture,api,development,archive}
```

### Documentation Standards
- **File Naming**: `kebab-case.md`
- **Headers**: Start with H1 for title
- **Metadata**: Include creation date and version
- **Links**: Use relative paths
- **Images**: Store in `docs/assets/images/`

## Dependencies
- Access to all repositories
- Understanding of current system
- Time from subject matter experts
- Agreement on structure and standards

## Risks and Mitigation

| Risk | Impact | Mitigation |
|------|--------|------------|
| Loss of important information | High | Create complete backup before starting |
| Broken links in code | Medium | Search and update all references |
| Team resistance to new structure | Low | Involve team in structure decisions |
| Time overrun | Medium | Prioritize most critical docs first |

## Success Metrics
- 100% of valuable documentation consolidated
- 0 duplicate files remaining
- <10 minutes to find any document
- New developer can set up environment using docs
- All team members know where to find/add docs

## Timeline

### Day 1-2: Audit and Planning
- Complete documentation inventory
- Create new structure
- Get team agreement on approach

### Day 3-4: Consolidation
- Migrate product documentation
- Migrate technical documentation
- Create development guides

### Day 5: Cleanup and Polish
- Archive old documentation
- Create navigation and indexes
- Team review and feedback
- Final cleanup and commit

## Definition of Done
- [ ] All stories completed and accepted
- [ ] New structure in place and populated
- [ ] Old structure archived
- [ ] Team trained on new structure
- [ ] Documentation standards documented
- [ ] All links and references updated
- [ ] README files comprehensive
- [ ] Commit to repository with clear message

## Next Steps After Completion
1. Implement documentation update process
2. Set up documentation CI/CD checks
3. Create documentation review schedule
4. Begin using docs for onboarding
5. Start SUB-EPIC-002 (Testing and CI/CD)

---

## Current Progress Tracking

### Completed ✅
- [x] Main `/docs` structure created
- [x] Brownfield PRD created and saved
- [x] Brownfield Architecture document created
- [x] Main documentation README created

### In Progress 🔄
- [ ] Auditing existing documentation in backend
- [ ] Creating consolidation plan

### Pending ⏳
- [ ] Actual consolidation of 120+ files
- [ ] Archive creation
- [ ] Team review

---

*Sub-Epic created with BMad Framework*
*Version: 1.0.0*
*Created: 2025-01-19*
*Last Updated: 2025-01-19*