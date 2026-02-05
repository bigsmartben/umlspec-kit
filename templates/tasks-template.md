---

description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: The examples below include test tasks. Tests are OPTIONAL - only include them if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by接口颗粒度（一个接口一个任务）以便独立实现与验证。

## Format: `[ID] [P?] [Interface] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Interface]**: 具体接口标识（例如 `[GET /api/path]`），实现任务必须“一接口一任务”
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
  
  Tasks MUST be organized by接口颗粒度（一个接口一个任务）。
  每个接口仅允许一个实现任务，要求端到端完成（Controller/Service/DAO/Validation）。
  
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

## Phase 3: Interface Implementation

**Purpose**: Implement interfaces based on spec.md section 1.1 and 3.1

### Interface 1: [接口名称]

**Interface**: `[GET/POST] /api/path` (Reference: spec.md section 1.1, 3.1)

- [ ] T017 [P] [GET /api/path] Implement end-to-end interface in src/controllers/[controller].java (includes controller/service/dao/validation)

### Interface 2: [接口名称]

**Interface**: `[GET/POST] /api/path` (Reference: spec.md section 1.1, 3.1)

- [ ] T018 [P] [GET /api/path] Implement end-to-end interface in src/controllers/[controller].java (includes controller/service/dao/validation)

### Interface 3: [接口名称]

**Interface**: `[GET/POST] /api/path` (Reference: spec.md section 1.1, 3.1)

- [ ] T019 [P] [GET /api/path] Implement end-to-end interface in src/controllers/[controller].java (includes controller/service/dao/validation)

**Checkpoint**: Core features implemented

---

## Phase 4: Algorithm & External Integration Notes

**Purpose**: 算法与外部依赖必须折叠到对应接口任务中，保持“一接口一任务”。

- 将算法实现、边界处理、外部服务调用、重试/熔断/降级等内容合并进对应接口的单一任务描述。
- 若存在非HTTP接口（如MQ消费/定时任务），也应视为“接口”，为其创建**一个**端到端任务。

**Checkpoint**: 所有接口任务均端到端完成

---

## Phase 5: Testing & Quality Assurance (OPTIONAL - only if tests requested)

**Purpose**: Comprehensive testing coverage

### Contract Tests

- [ ] T043 [P] [Test] Contract test for [GET /api/path] in tests/contract/test_[name].java
- [ ] T044 [P] [Test] Contract test for [GET /api/path] in tests/contract/test_[name].java
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

## Phase 6: Polish & Documentation

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
- **Algorithm & External Integration Notes (Phase 4)**: Must be included within interface tasks
- **Testing (Phase 5)**: Depends on Phases 3-4 completion
- **Polish (Phase 6)**: Depends on all previous phases

### Interface Dependencies

- **Interface 1**: Can start after Foundational (Phase 2)
- **Interface 2**: Can start after Foundational (Phase 2) - May depend on Interface 1
- **Interface 3**: Can start after Foundational (Phase 2) - May depend on Interface 1 and 2

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Database, Service, and API layer tasks within Foundation can run in parallel
- Different interfaces in Phase 3 can be developed in parallel (if no dependencies)
- All test tasks marked [P] can run in parallel
- All documentation tasks can run in parallel

---

## Implementation Strategy

### Sequential Approach

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all features)
3. Implement Interface 1 → Implement Interface 2 → Implement Interface 3
4. Implement algorithms (Phase 4)
5. Integrate external services (Phase 5)
6. Run comprehensive tests (Phase 5)
7. Polish and document (Phase 6)

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
  - Developer A: Interface 1
  - Developer B: Interface 2
  - Developer C: Interface 3
   - Developer D: Algorithms
3. Integrate and test together
4. Divide polish and documentation tasks

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add Interface 1 → Test → Deploy (MVP!)
3. Add Interface 2 → Test → Deploy
4. Add Interface 3 → Test → Deploy
5. Add remaining features → Final testing → Production release

---

## Notes

- [P] tasks = different files, no dependencies, can run in parallel
- [Interface] label maps task to a specific endpoint for traceability
- Reference spec.md section numbers in task descriptions for clarity
- Implement tasks MUST follow “一个接口一个任务”
- Verify database constraints match spec section 6.3.1
- Ensure API contracts match spec section 3.1
- Validate algorithms against spec section 5.1
- Verify success criteria from spec section 8
- Commit after each task or logical group
- Avoid: vague tasks, same file conflicts, circular dependencies
