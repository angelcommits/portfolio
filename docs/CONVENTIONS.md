# 📋 Documentation Conventions & Standards

> **Official conventions for Portfolio project documentation**  
> *Established: 2025-08-24*

## 📁 File Naming Conventions

### General Rules
- **Format**: Use kebab-case for all documentation files
- **Extension**: Always use `.md` for Markdown files
- **Language**: English by default, append language code for translations (e.g., `readme-es.md`)
- **No spaces**: Replace spaces with hyphens (`-`)
- **Lowercase**: Keep all filenames in lowercase except for standard files (README, CONVENTIONS, etc.)

### Standard Filenames

| Type | Convention | Example |
|------|------------|---------|
| **Index Files** | `README.md` or `INDEX.md` | `docs/README.md` |
| **Sprint Documents** | `YYYY-MM-DD-{type}.md` | `2025-08-24-standup.md` |
| **Tasks** | `task-{number}-{name}.md` | `task-002-progress.md` |
| **Stories** | `story-{epic}-{number}-{name}.md` | `story-002-001-rspec-setup.md` |
| **Epics** | `epic-{name}.md` or `sub-epic-{number}-{name}.md` | `sub-epic-001-documentation.md` |
| **Reports** | `{name}-report.md` | `phase1-completion-report.md` |
| **Reviews** | `{type}-review-{date}.md` | `qa-review-2025-08-24.md` |

## 📂 Directory Structure

### Core Structure
```
docs/
├── README.md                    # Master index (required)
├── CONVENTIONS.md              # This file
├── api/                        # API documentation
├── architecture/               # System design & technical specs
│   ├── database/              # Database schemas
│   ├── domain-driven-design/  # DDD documentation
│   └── reviews/               # Architecture reviews
├── development/               # Development guides
├── product/                   # Product management
│   ├── backlog/              # Product & technical backlog
│   ├── epics/                # Epic documentation
│   ├── roadmap/              # Product roadmap
│   └── user-stories/         # User stories
├── resources/                 # Supporting materials
│   ├── archive/              # Archived/obsolete docs
│   ├── external-audits/      # External reviews
│   └── templates/            # Document templates
├── sprints/                   # Sprint management
│   ├── current/              # Active sprint
│   ├── completed/            # Completed sprints
│   ├── reports/              # Sprint reports
│   └── retrospectives/       # Sprint retros
├── team/                      # Team documentation
├── testing/                   # Test documentation
│   ├── coverage-reports/     # Coverage reports
│   └── qa-reviews/           # QA review documents
└── workflows/                 # Development workflows
```

### Directory Rules
1. **No deep nesting**: Maximum 3 levels deep
2. **Clear purpose**: Each directory should have a clear, single purpose
3. **Index files**: Each major directory should have a README.md
4. **No duplicates**: Avoid duplicate directories with similar purposes

## 📝 Document Format Standards

### Markdown Structure

#### Header Hierarchy
```markdown
# H1 - Document Title (one per document)
## H2 - Major Sections
### H3 - Subsections
#### H4 - Details
##### H5 - Fine details (avoid if possible)
###### H6 - Never use
```

#### Front Matter
Every document should start with:
```markdown
# Document Title

> **Brief description of the document's purpose**

**Created**: YYYY-MM-DD  
**Updated**: YYYY-MM-DD  
**Status**: Draft | Review | Final | Deprecated  
**Owner**: Team/Person name
```

### Content Standards

#### Lists
- Use `-` for unordered lists (not `*` or `+`)
- Use `1.` for ordered lists with proper numbering
- Indent with 2 spaces for nested lists

#### Code Blocks
````markdown
```language
// Always specify the language for syntax highlighting
const example = "code here";
```
````

#### Tables
```markdown
| Column 1 | Column 2 | Column 3 |
|----------|----------|----------|
| Data     | Data     | Data     |
```
- Always include header separator
- Align columns for readability in raw markdown

#### Links
- **Internal**: Use relative paths `[Link Text](./path/to/file.md)`
- **External**: Use absolute URLs `[Link Text](https://example.com)`
- **Anchors**: Use lowercase, hyphenated `[Section](#section-name)`

## 🏷️ Document Categories

### Required Sections by Category

#### Sprint Documents
1. Sprint Goal
2. Sprint Backlog
3. Team Capacity
4. Daily Progress
5. Impediments
6. Sprint Review/Retro

#### User Stories
1. Story Description (As a... I want... So that...)
2. Acceptance Criteria
3. Technical Notes
4. Dependencies
5. Definition of Done

#### Technical Documentation
1. Overview/Purpose
2. Architecture/Design
3. Implementation Details
4. API/Interface
5. Testing Strategy
6. Deployment Notes

#### Reports
1. Executive Summary
2. Detailed Findings
3. Metrics/Data
4. Recommendations
5. Action Items
6. Appendices

## 🔄 Git Conventions

### Commit Messages for Documentation
```
docs: <type> <description>

Types:
- docs: add - New documentation
- docs: update - Update existing docs
- docs: fix - Fix errors in docs
- docs: reorganize - Structure changes
- docs: remove - Delete obsolete docs

Examples:
- docs: add sprint retrospective template
- docs: update API documentation for v2
- docs: fix broken links in architecture docs
- docs: reorganize product documentation structure
```

### Branch Naming
- Documentation branches: `docs/{feature}-{description}`
- Example: `docs/sprint-templates`, `docs/api-v2-updates`

## ✅ Documentation Checklist

Before committing documentation:

- [ ] Filename follows conventions
- [ ] Placed in correct directory
- [ ] Has proper front matter
- [ ] Headers follow hierarchy (H1 → H2 → H3)
- [ ] All code blocks have language specified
- [ ] Internal links are relative
- [ ] External links are absolute
- [ ] Tables are properly formatted
- [ ] No trailing whitespace
- [ ] File ends with newline
- [ ] README/INDEX updated if needed
- [ ] Cross-references are valid

## 🚀 Best Practices

### Do's ✅
- Keep documents focused on a single topic
- Use clear, descriptive titles
- Include examples where helpful
- Add diagrams for complex concepts
- Update timestamps when modifying
- Cross-reference related documents
- Use emoji sparingly for section headers

### Don'ts ❌
- Don't duplicate information (link instead)
- Don't use absolute paths for internal links
- Don't exceed 3 levels of directory nesting
- Don't mix languages in the same document
- Don't leave TODO comments in final docs
- Don't use H5/H6 headers
- Don't forget to update indexes

## 📊 Quality Standards

### Document Quality Metrics
- **Completeness**: All required sections present
- **Accuracy**: Information is correct and up-to-date
- **Clarity**: Easy to understand, no ambiguity
- **Consistency**: Follows all conventions
- **Navigability**: Easy to find and link to

### Review Process
1. **Self-review**: Author checks against conventions
2. **Peer review**: Team member validates content
3. **Technical review**: SME verifies accuracy
4. **Final approval**: Lead approves for publication

## 🔍 Validation Tools

### Recommended Tools
- **markdownlint**: Enforce markdown standards
- **link-checker**: Validate all links
- **spell-checker**: Check spelling
- **vale**: Enforce writing style

### Automation
Consider adding pre-commit hooks for:
- Filename validation
- Markdown linting
- Link checking
- Format verification

## 📚 Templates

Templates are available in `/docs/resources/templates/`:
- `sprint-review-template.md`
- `user-story-template.md`
- `technical-doc-template.md`
- `retrospective-template.md`

## 🆘 Help & Support

### Common Issues

#### Issue: Where to place a document?
**Solution**: Check the directory structure above. When in doubt, place in the most specific category.

#### Issue: How to name a file?
**Solution**: Follow the naming conventions table. Use kebab-case and be descriptive.

#### Issue: Broken links after reorganization
**Solution**: Use relative paths and run link-checker after moves.

### Getting Help
- Check this conventions document first
- Review existing similar documents for examples
- Ask the team if unclear
- Submit improvements to this document via PR

---

**Document Version**: 1.0.0  
**Last Updated**: 2025-08-24  
**Maintained by**: Portfolio Team  
**Review Schedule**: Quarterly

*This is a living document. Submit PRs to improve conventions.*