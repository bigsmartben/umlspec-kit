---

description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: The examples below include test tasks. Tests are OPTIONAL - only include them if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by functional module or user story to enable independent implementation and testing.

## Format: `[ID] [P?] [Module] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Module]**: Which module/story this task belongs to (e.g., DB, API, US1, US2)
- Include exact file paths in descriptions

## Path Conventions

- **Single project**: `src/`, `tests/` at repository root
- **Web app**: `backend/src/`, `frontend/src/`
- **Mobile**: `api/src/`, `ios/src/` or `android/src/`
- Paths shown below assume single project - adjust based on plan.md structure

<!-- 
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.
  
  The /speckit.tasks command MUST replace these with actual tasks based on:
  - Functional requirements from spec.md
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints from contracts/
  - Interface mappings from spec section 1 (功能点完备性覆盖)
  
  Tasks should be organized by logical modules (Database, Service, API, etc.)
  or by user stories for clear dependency management.
  
  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize [language] project with [framework] dependencies
- [ ] T003 [P] Configure linting and formatting tools

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY feature implementation can begin

**⚠️ CRITICAL**: No feature work can begin until this phase is complete

### Database Layer

- [ ] T004 [P] [DB] Design and create database schema based on data-model.md
- [ ] T005 [P] [DB] Create database migration scripts
- [ ] T006 [P] [DB] Setup database indexes and constraints per spec section 6.3.1
- [ ] T007 [P] [DB] Create test data fixtures

### Service Layer Foundation

- [ ] T008 [P] [Service] Implement base service classes and interfaces
- [ ] T009 [P] [Service] Setup dependency injection framework
- [ ] T010 [P] [Service] Implement error handling and logging infrastructure
- [ ] T011 [P] [Service] Setup configuration management

### API Layer Foundation

- [ ] T012 [P] [API] Setup API routing framework
- [ ] T013 [P] [API] Implement authentication/authorization middleware
- [ ] T014 [P] [API] Implement request validation framework
- [ ] T015 [P] [API] Setup API response wrapper (e.g., ApiResponse)
- [ ] T016 [P] [API] Implement global exception handler

**Checkpoint**: Foundation ready - feature implementation can now begin

---

## Phase 3: Feature Implementation

**Purpose**: Implement core business features based on spec.md section 0.1 and section 1.1

### Module 1: [功能点1 - Feature Name]

**Interface**: `[GET/POST] /api/path` (Reference: spec.md section 1.1, 3.1)

- [ ] T017 [P] [M1] Implement [Entity] model in src/models/[entity].java
- [ ] T018 [M1] Implement [Service] business logic in src/services/[service].java
- [ ] T019 [M1] Implement API controller in src/controllers/[controller].java
- [ ] T020 [M1] Add input validation and error handling
- [ ] T021 [M1] Implement time sequence logic per spec section 2.1

### Module 2: [功能点2 - Feature Name]

**Interface**: `[GET/POST] /api/path` (Reference: spec.md section 1.1, 3.1)

- [ ] T022 [P] [M2] Implement [Entity] model in src/models/[entity].java
- [ ] T023 [M2] Implement [Service] business logic in src/services/[service].java
- [ ] T024 [M2] Implement API controller in src/controllers/[controller].java
- [ ] T025 [M2] Implement state transition logic per spec section 0.4
- [ ] T026 [M2] Add idempotency handling per spec section 6.2

### Module 3: [功能点3 - Feature Name]

**Interface**: `[GET/POST] /api/path` (Reference: spec.md section 1.1, 3.1)

- [ ] T027 [P] [M3] Implement [Entity] model in src/models/[entity].java
- [ ] T028 [M3] Implement [Service] business logic in src/services/[service].java
- [ ] T029 [M3] Implement API controller in src/controllers/[controller].java
- [ ] T030 [M3] Implement core algorithm per spec section 5.1

**Checkpoint**: Core features implemented

---

## Phase 4: Algorithm Implementation

**Purpose**: Implement core algorithms and business rules (Reference: spec.md section 5)

### Algorithm A: [算法名称1]

- [ ] T031 [Algo] Implement [Algorithm A] in src/algorithms/[algo].java
- [ ] T032 [Algo] Add edge case handling per spec section 5.1(A)
- [ ] T033 [Algo] Add algorithm unit tests

### Algorithm B: [算法名称2]

- [ ] T034 [Algo] Implement [Algorithm B] in src/algorithms/[algo].java
- [ ] T035 [Algo] Add calculation formula per spec section 5.1(B)
- [ ] T036 [Algo] Handle special cases (e.g., division by zero)

**Checkpoint**: All algorithms implemented and tested

---

## Phase 5: External Integration

**Purpose**: Integrate with external services (Reference: spec.md section 4)

### External Service 1: [服务名称]

- [ ] T037 [P] [Ext] Implement [Service] client in src/clients/[client].java
- [ ] T038 [Ext] Add retry and circuit breaker logic
- [ ] T039 [Ext] Add integration logging and monitoring

### External Service 2: [服务名称]

- [ ] T040 [P] [Ext] Implement [Service] client in src/clients/[client].java
- [ ] T041 [Ext] Handle external service failures gracefully
- [ ] T042 [Ext] Add fallback mechanism

**Checkpoint**: All external integrations complete

---

## Phase 6: Testing & Quality Assurance (OPTIONAL - only if tests requested)

**Purpose**: Comprehensive testing coverage

### Contract Tests

- [ ] T043 [P] [Test] Contract test for [Interface 1] in tests/contract/test_[name].java
- [ ] T044 [P] [Test] Contract test for [Interface 2] in tests/contract/test_[name].java
- [ ] T045 [P] [Test] Verify API contracts match spec.md section 3

### Integration Tests

- [ ] T046 [P] [Test] Integration test for [Flow 1] in tests/integration/test_[name].java
- [ ] T047 [P] [Test] Integration test for [Flow 2] in tests/integration/test_[name].java
- [ ] T048 [Test] End-to-end flow test per spec section 0.3

### Unit Tests

- [ ] T049 [P] [Test] Unit tests for models in tests/unit/models/
- [ ] T050 [P] [Test] Unit tests for services in tests/unit/services/
- [ ] T051 [P] [Test] Unit tests for algorithms in tests/unit/algorithms/

### Performance & Load Tests

- [ ] T052 [Test] Performance test - verify RT < [threshold] per spec section 8.1
- [ ] T053 [Test] Load test - verify concurrent user capacity per spec section 8.1
- [ ] T054 [Test] Stress test - verify system stability under high load

**Checkpoint**: All tests pass, quality metrics met

---

## Phase 7: Polish & Documentation

**Purpose**: Code quality, documentation, and deployment readiness

### Code Quality

- [ ] T055 [P] Code review and refactoring
- [ ] T056 [P] Performance optimization
- [ ] T057 [P] Security hardening
- [ ] T058 [P] Error message standardization

### Documentation

- [ ] T059 [P] API documentation (Swagger/OpenAPI)
- [ ] T060 [P] Database schema documentation
- [ ] T061 [P] Architecture documentation
- [ ] T062 [P] Deployment guide
- [ ] T063 Run quickstart.md validation

### Monitoring & Observability

- [ ] T064 [P] Add application metrics
- [ ] T065 [P] Add business metrics per spec section 0.2
- [ ] T066 [P] Setup alerting rules
- [ ] T067 [P] Add distributed tracing

**Checkpoint**: Feature complete and production-ready

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all feature work
- **Feature Implementation (Phase 3)**: Depends on Foundational phase completion
- **Algorithm Implementation (Phase 4)**: Can run in parallel with Phase 3
- **External Integration (Phase 5)**: Depends on Phase 3 completion
- **Testing (Phase 6)**: Depends on Phases 3-5 completion
- **Polish (Phase 7)**: Depends on all previous phases

### Module Dependencies

- **Module 1**: Can start after Foundational (Phase 2)
- **Module 2**: Can start after Foundational (Phase 2) - May depend on Module 1
- **Module 3**: Can start after Foundational (Phase 2) - May depend on Module 1 and 2

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Database, Service, and API layer tasks within Foundation can run in parallel
- Different modules in Phase 3 can be developed in parallel (if no dependencies)
- All test tasks marked [P] can run in parallel
- All documentation tasks can run in parallel

---

## Implementation Strategy

### Sequential Approach

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all features)
3. Implement Module 1 → Implement Module 2 → Implement Module 3
4. Implement algorithms (Phase 4)
5. Integrate external services (Phase 5)
6. Run comprehensive tests (Phase 6)
7. Polish and document (Phase 7)

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: Module 1
   - Developer B: Module 2
   - Developer C: Module 3
   - Developer D: Algorithms
3. Integrate and test together
4. Divide polish and documentation tasks

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add Module 1 → Test → Deploy (MVP!)
3. Add Module 2 → Test → Deploy
4. Add Module 3 → Test → Deploy
5. Add remaining features → Final testing → Production release

---

## Notes

- [P] tasks = different files, no dependencies, can run in parallel
- [Module] label maps task to specific module/feature for traceability
- Reference spec.md section numbers in task descriptions for clarity
- Verify database constraints match spec section 6.3.1
- Ensure API contracts match spec section 3.1
- Validate algorithms against spec section 5.1
- Verify success criteria from spec section 8
- Commit after each task or logical group
- Avoid: vague tasks, same file conflicts, circular dependencies
