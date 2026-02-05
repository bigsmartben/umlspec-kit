---
description: Generate an actionable, dependency-ordered tasks.md for a data feature based on available design artifacts.
handoffs: 
  - label: Analyze For Consistency
    agent: speckit.analyze
    prompt: Run a project analysis for consistency
    send: true
  - label: Implement Project
    agent: speckit.implement
    prompt: Start the implementation in phases
    send: true
scripts:
  sh: scripts/bash/check-prerequisites.sh --json
  ps: scripts/powershell/check-prerequisites.ps1 -Json
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

1. **Setup**: Run `{SCRIPT}` from repo root and parse FEATURE_DIR and AVAILABLE_DOCS list. All paths must be absolute. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot").

2. **Load design documents**: Read from FEATURE_DIR:
   - **Required**: plan.md (tech stack, libraries, structure), spec.md (user stories with priorities)
   - **Optional**: data-model.md (entities), contracts/ (API endpoints), research.md (decisions), quickstart.md (test scenarios)
   - Note: Not all projects have all documents. Generate tasks based on what's available.

3. **Execute task generation workflow**:
   - Load plan.md and extract tech stack, libraries, project structure
   - Load spec.md and extract interface mappings (data contracts, APIs, sinks)
   - If data-model.md exists: Extract entities and map to interfaces
   - If contracts/ exists: Map endpoints to interfaces
   - If research.md exists: Extract decisions for setup tasks
   - Generate tasks organized by interface (see Task Generation Rules below)
   - Generate dependency graph showing interface completion order
   - Create parallel execution examples per interface
   - Validate task completeness (each interface has exactly one end-to-end task)

4. **Generate tasks.md**: Use `templates/tasks-template.data.md` as structure, fill with:
   - Correct feature name from plan.md
   - Phase 1: Setup tasks (project initialization)
   - Phase 2: Foundational tasks (blocking prerequisites for all interfaces)
   - Include data contracts, lineage, quality, and backfill tasks
   - Phase 3+: Interface implementation list (one task per interface)
   - Each interface includes: reference to data contract/API and a single end-to-end task
   - Final Phase: Polish & cross-cutting concerns
   - All tasks must follow the strict checklist format (see Task Generation Rules below)
   - Clear file paths for each task
   - Dependencies section showing interface completion order
   - Parallel execution examples per interface
   - Implementation strategy section (MVP first, incremental delivery)

5. **Report**: Output path to generated tasks.md and summary:
   - Total task count
   - Task count per interface
   - Parallel opportunities identified
   - Suggested MVP scope (typically just Interface 1)
   - Format validation: Confirm ALL tasks follow the checklist format (checkbox, ID, labels, file paths)

Context for task generation: {ARGS}

The tasks.md should be immediately executable - each task must be specific enough that an LLM can complete it without additional context.

## Task Generation Rules

**CRITICAL**: Tasks MUST be organized by接口颗粒度（一个接口/数据契约一个任务）。

**Tests are OPTIONAL**: Only generate test tasks if explicitly requested in the feature specification or if user requests TDD approach.

### Checklist Format (REQUIRED)

Every task MUST strictly follow this format:

```text
- [ ] [TaskID] [P?] [Interface?] Description with file path
```

**Format Components**:

1. **Checkbox**: ALWAYS start with `- [ ]` (markdown checkbox)
2. **Task ID**: Sequential number (T001, T002, T003...) in execution order
3. **[P] marker**: Include ONLY if task is parallelizable (different files, no dependencies on incomplete tasks)
4. **[Interface] label**: REQUIRED for interface tasks only
   - Format: [dataset:foo_v1] or [GET /api/path]
   - Setup phase: NO interface label
   - Foundational phase: NO interface label
   - Interface phases: MUST have interface label
   - Polish phase: NO interface label
5. **Description**: Clear action with exact file path

**Examples**:

- ✅ CORRECT: `- [ ] T001 Create project structure per implementation plan`
- ✅ CORRECT: `- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py`
- ✅ CORRECT: `- [ ] T012 [P] [dataset:foo_v1] Implement end-to-end pipeline in src/...`
- ✅ CORRECT: `- [ ] T014 [GET /api/path] Implement end-to-end interface in src/...`
- ❌ WRONG: `- [ ] Create User model` (missing ID and Story label)
- ❌ WRONG: `T001 [US1] Create model` (missing checkbox)
- ❌ WRONG: `- [ ] [dataset:foo_v1] Create model` (missing Task ID)
- ❌ WRONG: `- [ ] T001 [dataset:foo_v1] Create model` (missing file path)

### Task Organization

1. **From Interfaces (data contracts/APIs)** - PRIMARY ORGANIZATION:
   - Each interface/contract gets exactly one end-to-end task
   - Do not split a single interface into ingestion/transform/publish tasks

2. **From Contracts**:
   - Use contracts as the source of truth when available
   - If tests requested: Each contract → contract test task [P] before implementation

3. **From Data Model**:
   - Entities are supporting details; fold into the interface task that needs them
   - Cross-interface entities → Foundational phase

4. **From Setup/Infrastructure**:
   - Shared infrastructure → Setup phase (Phase 1)
   - Foundational/blocking tasks → Foundational phase (Phase 2)
   - Interface-specific setup → within that interface task

### Phase Structure

- **Phase 1**: Setup (project initialization)
- **Phase 2**: Foundational (blocking prerequisites - MUST complete before user stories)
- **Phase 3+**: Interfaces (one task per interface)
   - If tests requested: Contract tests precede the interface task
   - Each phase should be a complete, independently testable increment
- **Final Phase**: Polish & Cross-Cutting Concerns
