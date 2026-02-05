---

description: "Task list template for refactor feature implementation"
---

# Tasks: [FEATURE NAME] (Refactor)

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: The examples below include test tasks. Tests are OPTIONAL - only include them if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by **interface granularity** (one interface/endpoint per delivery task) to ensure each task is independently shippable, testable, and verifiable.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Refactor-Specific Guidance

- Capture baseline behavior and performance before changes.
- Keep interfaces, sequences, and schemas stable unless explicitly allowed.
- Prefer incremental, reversible steps with validation at each phase.

## CRITICAL: Task Granularity (Interface-Level Delivery)

**Definition (in this repository)**:

- **Interface** means an **end-to-end, externally observable** entrypoint, including:
	- HTTP API endpoint (REST/GraphQL)
	- WebSocket interface (connect/auth + message types)
	- Raw socket interface (protocol command/message types)
- **Interface does NOT include**: internal RPC, MQ consumers/producers, scheduled jobs/cron, or other purely internal triggers.

1. **One interface = one delivery task**: For every in-scope interface (HTTP endpoint / WebSocket message type / socket command), create **exactly one** end-to-end task that delivers it.
2. **No “layer-splitting” per interface**: Do not create separate tasks like “model/service/controller” for the same endpoint. Those are implementation details and must be completed inside that endpoint’s delivery task.
3. **Independently verifiable**: Each interface task must include its own verification steps (contract/parity check, and tests if requested).
4. **Scope control (target architecture)**: The interface task may only touch code that is justified by `impact-map.md` evidence (symbols/usages/contracts/tests). If new files/symbols are needed, update `impact-map.md` first.

## HARD CONSISTENCY CONTRACT (Spec → Plan → Tasks)

These rules are designed to be mechanically checkable:

1. **Single source of truth**: plan.md “Interface Inventory” is the authoritative list of `Ixx`.
2. **1:1 mapping**: For every `Ixx` in plan.md, tasks.md MUST contain **exactly one** delivery task.
3. **Required tag**: The delivery task line MUST include the exact token `Interface:Ixx` (e.g., `Interface:I01`).
4. **No extras**: tasks.md MUST NOT contain `Interface:Ixx` tokens that do not exist in plan.md.

## Interface Inventory (fill before Phase 3)

> **Avoid redundancy**: This is a lightweight index for task ordering. The detailed Interface Inventory is the source of truth in plan.md.

| Interface ID | Type | Method/Path (or name) | User Story |
|-------------|------|------------------------|------------|
| I01 | HTTP | [GET /v1/foo] | [US1] |
| I02 | WebSocket | [WS msg: FooUpdated] | [US2] |

## Required Artifacts (create early)

- `specs/[###-feature-name]/baseline.md`: baseline behaviors + measurements + golden examples
- `specs/[###-feature-name]/impact-map.md`: evidence-backed scope/impact map (symbols/usages/contracts)
- `specs/[###-feature-name]/migration.md`: phased migration + rollout + rollback

## Phase 1: Baseline & Safety Net

- [ ] T001 Create baseline doc in specs/[###-feature-name]/baseline.md
- [ ] T002 Create impact map in specs/[###-feature-name]/impact-map.md
- [ ] T003 Define migration + rollback plan in specs/[###-feature-name]/migration.md
- [ ] T004 Add regression tests for critical flows in tests/ (only if requested)
- [ ] T005 [P] Add performance benchmarks in tests/perf/ (only if requested)

---

## Phase 2: Foundations

- [ ] T006 Identify refactor boundaries and dependencies in specs/[###-feature-name]/impact-map.md
- [ ] T007 [P] Add feature flags or toggles if needed in src/
- [ ] T008 Document target architecture diagrams in specs/[###-feature-name]/plan.md

---

## Phase 3+: Interface Delivery (one phase per interface)

> Repeat this phase block for every interface in the Interface Inventory, in priority order.

### Interface I01 - [METHOD /path or interface name] (Maps to [US1])

**Goal**: [what this interface must do after refactor]

**Invariant(s) / Contract / Verification**: Reference plan.md → Interface Inventory → I01 (keep details there)

- [ ] T009 [US1] Deliver interface I01 end-to-end (Contract + Code + Parity validation) Interface:I01 in [file paths]

**Definition of Done for this interface task** (maps to spec.md Acceptance Criteria):

- **AC-1 (Behavior)**: Parity validated against specs/[###-feature-name]/baseline.md
- **AC-2 (Performance)**: No latency/throughput regression vs baseline
- **AC-4 (Lossless)**: Rollback path confirmed per specs/[###-feature-name]/migration.md
- Contract compatibility verified (or contract updated with explicit approval)
- Observability checks updated if applicable

---

## Phase 4: Migration & Cleanup (cross-interface)

- [ ] T012 Migrate remaining callers to new component
- [ ] T013 Remove deprecated code paths (only after parity + rollout validation)
- [ ] T014 Update documentation and diagrams in specs/[###-feature-name]/

---

## Phase 5: Acceptance Gate Verification (cross-interface)

> This phase verifies all spec.md Acceptance Criteria before final rollout.

- [ ] T015 [P] AC-1 verification: Run full E2E parity test suite against baseline
- [ ] T016 [P] AC-2 verification: Run load test, confirm latency/throughput ≤ baseline
- [ ] T017 AC-3 verification: Confirm SLA dashboards show ≥ baseline availability
- [ ] T018 AC-4 verification: Rehearse rollback, confirm MTTR ≤ target (document result)
- [ ] T019 Update migration.md with final rollback rehearsal results
- [ ] T020 Run quickstart.md validation

---

## Dependencies & Execution Order

- Baseline -> Foundations -> Interface delivery (by priority) -> Migration/Cleanup -> Performance/Stability
- Each interface task must be independently verifiable before moving to the next interface
