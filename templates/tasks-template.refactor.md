---

description: "Task list template for refactor feature implementation"
---

# Tasks: [FEATURE NAME] (Refactor)

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: The examples below include test tasks. Tests are OPTIONAL - only include them if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Refactor-Specific Guidance

- Capture baseline behavior and performance before changes.
- Keep interfaces, sequences, and schemas stable unless explicitly allowed.
- Prefer incremental, reversible steps with validation at each phase.

## Phase 1: Baseline & Safety Net

- [ ] T001 Capture baseline behaviors in docs/baseline.md
- [ ] T002 Add regression tests for critical flows in tests/
- [ ] T003 [P] Add performance benchmarks in tests/perf/

---

## Phase 2: Foundations

- [ ] T004 Identify refactor boundaries and dependencies in docs/refactor-scope.md
- [ ] T005 [P] Add feature flags or toggles if needed
- [ ] T006 Document target architecture diagrams in docs/architecture.md

---

## Phase 3: User Story 1 - [Title] (Priority: P1)

**Goal**: [Refactor goal for this story]

**Independent Test**: [How to verify this story works on its own]

### Implementation for User Story 1

- [ ] T007 [P] [US1] Refactor component [X] in src/
- [ ] T008 [US1] Ensure interface compatibility for [API/contract]
- [ ] T009 [US1] Validate behavior parity against baseline

---

## Phase 4: Migration & Cleanup

- [ ] T010 Migrate remaining callers to new component
- [ ] T011 Remove deprecated code paths (after validation)
- [ ] T012 Update documentation and diagrams

---

## Phase 5: Performance & Stability

- [ ] T013 [P] Re-run performance benchmarks and compare to baseline
- [ ] T014 Address regressions and finalize rollback plan
- [ ] T015 Run quickstart.md validation

---

## Dependencies & Execution Order

- Baseline -> Foundations -> User Stories -> Migration/Cleanup -> Performance/Stability
- Each refactor step must pass regression checks before proceeding

