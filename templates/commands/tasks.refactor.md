---
description: Generate an actionable, dependency-ordered tasks.md for a refactor feature based on available design artifacts.
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
   - Load spec.md and extract user stories with their priorities (P1, P2, P3, etc.)
   - If data-model.md exists: Extract entities and map to user stories
   - If contracts/ exists: Extract end-to-end interfaces (HTTP/WebSocket/socket) and map them to user stories
   - If research.md exists: Extract decisions for setup tasks
   - Treat plan.md **Interface Inventory** as the source of truth for interfaces, invariants, and verification
   - Generate tasks organized by interface granularity (see Task Generation Rules below)
   - Generate dependency graph showing interface delivery order
   - Create parallel execution examples only for cross-interface or cross-cutting tasks
   - Validate task completeness (each interface task is independently verifiable)

4. **Generate tasks.md**: Use `templates/tasks-template.refactor.md` as structure, fill with:
   - Correct feature name from plan.md
   - Phase 1: Setup tasks (project initialization)
   - Phase 2: Foundational tasks (blocking prerequisites for all interfaces)
   - Include baseline capture, impact-map, migration+rollback, and parity validation tasks
   - Phase 3+: One phase per interface (HTTP/WebSocket/socket), in priority order derived from user story priority
   - Each interface phase includes: goal and exactly one end-to-end delivery task
   - To avoid redundancy, reference plan.md Interface Inventory for invariants/contract/verification details

5. **Hard consistency validation (MUST PASS)**:

After generating tasks.md, validate:

- Extract the set of interface IDs from plan.md Interface Inventory: `I01`, `I02`, ...
- Extract the set of interface IDs from tasks.md by scanning for tokens `Interface:Ixx`
- Rules:
   - Every plan interface ID MUST appear in tasks exactly once
   - No tasks interface IDs may exist that are not in plan
   - If any rule fails: ERROR and fix tasks.md
   - Final Phase: Polish & cross-cutting concerns
   - All tasks must follow the strict checklist format (see Task Generation Rules below)
   - Clear file paths for each task
   - Dependencies section showing story completion order
   - Parallel execution examples per story
   - Implementation strategy section (MVP first, incremental delivery)

5. **Report**: Output path to generated tasks.md and summary:
   - Total task count
   - Task count per interface
   - Parallel opportunities identified
   - Independent verification summary for each interface
   - Suggested MVP scope (typically just the first highest-priority interface)
   - Format validation: Confirm ALL tasks follow the checklist format (checkbox, ID, labels, file paths)

Context for task generation: {ARGS}

The tasks.md should be immediately executable - each task must be specific enough that an LLM can complete it without additional context.

## Task Generation Rules

**CRITICAL**: Tasks MUST be organized by **interface granularity** to enable independent delivery and verification.

**Interface Granularity Rule (REQUIRED)**:

- For every in-scope interface (**end-to-end HTTP/WebSocket/socket only**), generate **exactly one** end-to-end delivery task.
- Do NOT create interface-granularity tasks for: internal RPC, MQ consumers/producers, scheduled jobs/cron.
- Do NOT split a single interface into separate tasks like "model", "service", "controller".
- Put all necessary internal refactor work required to deliver that interface inside the interface task description.
- The interface task MUST include explicit verification steps (parity/contract check, and tests if requested).

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
4. **[Interface] label**: REQUIRED for interface delivery tasks only
   - Format: [Interface:I01], [Interface:I02], etc.
   - Setup phase: NO interface label
   - Foundational phase: NO interface label
   - Interface phases: MUST have interface label
   - Polish phase: NO interface label
5. **Description**: Clear action with exact file path

**Examples**:

- ✅ CORRECT: `- [ ] T001 Create project structure per implementation plan`
- ✅ CORRECT: `- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py`
- ✅ CORRECT: `- [ ] T012 [P] [Interface:I01] Deliver interface I01 end-to-end in src/...`
- ✅ CORRECT: `- [ ] T014 [Interface:I02] Deliver interface I02 end-to-end in src/...`
- ❌ WRONG: `- [ ] Create User model` (missing ID and Story label)
- ❌ WRONG: `T001 [US1] Create model` (missing checkbox)
- ❌ WRONG: `- [ ] [Interface:I01] Create User model` (missing Task ID)
- ❌ WRONG: `- [ ] T001 [Interface:I01] Create model` (missing file path)

### Task Organization

1. **From Interfaces (contracts/ + spec.md)** - PRIMARY ORGANIZATION:
   - Build an Interface Inventory first (method/path/name, contract file if present, owning module, mapped user story)
   - Each interface gets its own phase block
   - Use user story priority only to order interface phases

2. **From Contracts**:
   - Use contracts as the source of truth for interface definition when available
   - Keep contract compatibility unless explicitly allowed to change

3. **From Data Model**:
   - Entities are supporting details; do not create separate tasks per entity unless they are cross-interface foundational work
   - Prefer capturing entity work inside the interface task that needs it

4. **From Setup/Infrastructure**:
   - Shared infrastructure → Setup phase (Phase 1)
   - Foundational/blocking tasks → Foundational phase (Phase 2)
   - Interface-specific setup → within that interface's phase

### Phase Structure

- **Phase 1**: Setup (project initialization)
- **Phase 2**: Foundational (blocking prerequisites - MUST complete before user stories)
- **Phase 3+**: Interfaces in priority order (derived from user story priority)
   - Each phase contains exactly one end-to-end delivery task for that interface
   - Each phase should be a complete, independently verifiable increment
- **Final Phase**: Polish & Cross-Cutting Concerns
