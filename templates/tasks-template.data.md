---

description: "Task list template for data feature implementation"
---

# Tasks: [FEATURE NAME] (Data)

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: The examples below include test tasks. Tests are OPTIONAL - only include them if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Data-Specific Guidance

- Include tasks for data contracts, lineage, data quality rules, and backfill/replay.
- Capture both real-time and batch paths if hybrid.
- Add monitoring/alerting tasks tied to data freshness and quality metrics.

## Phase 1: Setup (Shared Infrastructure)

- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize data pipeline framework and config
- [ ] T003 [P] Configure linting, formatting, and data validation tooling

---

## Phase 2: Foundational (Blocking Prerequisites)

- [ ] T004 Define input/output data contracts in specs/contracts/
- [ ] T005 [P] Create base schemas or models in src/models/
- [ ] T006 [P] Implement data quality rules in src/quality/
- [ ] T007 Document lineage in docs/lineage.md (include diagram)
- [ ] T008 Setup monitoring and alerting for freshness and quality

---

## Phase 3: User Story 1 - [Title] (Priority: P1)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Implementation for User Story 1

- [ ] T009 [P] [US1] Implement ingestion for [source] in src/ingest/
- [ ] T010 [P] [US1] Implement transform for [dataset] in src/transform/
- [ ] T011 [US1] Publish outputs to [target] in src/publish/
- [ ] T012 [US1] Add data quality checks for [dataset]

---

## Phase 4: Data Quality & Backfill

- [ ] T013 [P] Implement backfill workflow in src/backfill/
- [ ] T014 [P] Add reconciliation/validation for backfill results
- [ ] T015 Add runbooks for failure recovery in docs/runbooks/

---

## Phase 5: Observability & Documentation

- [ ] T016 [P] Add dashboards for freshness and quality metrics
- [ ] T017 Document interfaces and lineage in docs/
- [ ] T018 Run quickstart.md validation

---

## Dependencies & Execution Order

- Setup -> Foundational -> User Stories -> Quality/Backfill -> Observability/Docs
- Data contracts and quality rules must be in place before publishing outputs
