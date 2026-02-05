# Refactor 模板优化参考案例

本文件展示如何使用 template-extension skill 优化 refactor 模板。

## 案例: AIDM 讲课服务拆分

### 项目背景

- **原服务**: 单体应用（8 个 Application）
- **目标**: 拆分为微服务（2 个端到端接口 I01, I02）
- **验证**: 通过 AC-1~AC-4 框架验证一致性

### Spec 示例片段

```markdown
## Performance Targets

| Metric | Baseline | Target | Verification |
|--------|----------|--------|--------------|
| GET /api/v1/lectures P50 | 150ms | ≥150ms (0% regression) | wrk load test |
| POST /api/v1/lectures P99 | 800ms | ≥800ms (0% regression) | wrk load test |
| Throughput | 1200 req/s | ≥1200 req/s | wrk load test |
| Error Rate | 0.05% | ≤0.05% | Prometheus |

## Lossless Release Risk

- **Rollback MTTR**: ≤ 5 minutes (kubectl rollout undo)
- **Data Loss Window**: 0 seconds (MySQL dual-write + replication lag check)
- **User-Visible Downtime**: 0 seconds (Istio canary routing)
- **Blast Radius**: Single pod (Kubernetes deployment strategy)

## Acceptance Criteria

### AC-1: User Behavior Consistency
- [ ] 讲课列表 API 返回相同的分页格式（offset/limit）
- [ ] 创建讲课失败时返回相同的 HTTP 400 错误码和消息
- [ ] WebSocket 推送消息的 JSON schema 完全一致

### AC-2: Performance Consistency
- [ ] P50 response time ≥ 150ms baseline ✓
- [ ] P99 response time ≥ 800ms baseline ✓
- [ ] Throughput ≥ 1200 req/s baseline ✓
- [ ] Error rate ≤ 0.05% baseline ✓

### AC-3: SLA Consistency
- [ ] Availability ≥ 99.95% (existing SLA)
- [ ] Alert thresholds unchanged (P99 > 1000ms triggers alert)
- [ ] Recovery time ≤ 5 min (existing MTTR)

### AC-4: Lossless Release
- [ ] Rollback MTTR measured = 3.2 min ✓ (< 5 min target)
- [ ] Zero data loss during rollback drill ✓
- [ ] Canary traffic capped at 10% ✓
- [ ] No P1 alerts during deployment ✓

## Acceptance Gate
- [x] AC-1 verified (E2E tests passed)
- [x] AC-2 verified (load test passed)
- [x] AC-3 verified (SLA dashboard green)
- [x] AC-4 verified (rollback drill successful)
```

### Plan 示例片段

```markdown
## Interface Inventory (Source of Truth)

| Ixx | Type | Method/Path | Contract | Owner | Invariants | Verification |
|-----|------|------------|----------|-------|-----------|--------------|
| I01 | REST | GET /api/v1/lectures | Pagination (offset/limit), 200/400 | Team-Lecture | Response time P50 ≤ 200ms | E2E test |
| I02 | REST | POST /api/v1/lectures | JSON body (title, content), 201/400 | Team-Lecture | Unique title constraint | E2E test |

**Hard Consistency Rules**:
1. Each Ixx (I01, I02) must appear exactly once in Tasks with `Interface:Ixx` tag
2. No Ixx renumbering after Tasks generation (stable ID)
3. Verification command: `grep "Interface:I" tasks.refactor.md | sort | uniq -c`

## Migration & Rollout Plan

### Phase 1: Baseline & Safety Net (Week 1)
- Establish baseline metrics (P50=150ms, P99=800ms, throughput=1200 req/s)
- Create rollback script (MTTR target: ≤ 5 min)

### Phase 2: Foundations (Week 2)
- Define service boundaries (Lecture context)
- Set up feature toggle: `lecture.new_service.enabled=false`

### Phase 3: Interface Delivery (Week 3-4)
- **I01**: Gradual rollout (5% → 25% → 50% → 100%)
- **I02**: Gradual rollout (5% → 25% → 50% → 100%)

### Phase 4: Acceptance Gate (Week 5)
- Run all AC-1~AC-4 verification tasks

### Rollback Strategy
- **MTTR Target**: ≤ 5 minutes (from spec)
- **Rollout Checklist**:
  - [x] AC-1: E2E parity verified (120/120 tests passed)
  - [x] AC-2: Performance baseline met (P50=148ms, P99=785ms)
  - [x] AC-3: SLA dashboard green (99.97% availability)
  - [x] AC-4: Rollback drill successful (MTTR=3.2 min)
```

### Tasks 示例片段

```markdown
# Refactor Tasks: AIDM 讲课服务拆分

## HARD CONSISTENCY CONTRACT

**Interface:Ixx Mapping Rules**:
- Plan defines I01, I02 in Interface Inventory
- Tasks must have exactly one `Interface:I01` section
- Tasks must have exactly one `Interface:I02` section
- Verification: `grep "Interface:I" tasks.refactor.md` should return 2 unique lines

## Phase 1: Baseline & Safety Net

- **T001**: Establish baseline
  - Record current metrics: P50=150ms, P99=800ms, throughput=1200 req/s
  - Output: `baseline.md` with wrk test results
  - DoD: All 3 metrics documented
  
- **T002**: Create impact map and migration script
  - Document dependencies: MySQL lecture table, Redis cache
  - Output: `impact-map.md`, `migration.sql`
  - DoD: Migration script tested on staging

- **T003**: Document rollback procedure
  - MTTR target: ≤ 5 minutes
  - Steps: kubectl rollout undo, verify health check, run smoke tests
  - DoD: Dry-run completed in 3.5 minutes

## Phase 2: Foundations

- **T004**: Define service boundary (Lecture context)
  - Entities: Lecture, LectureSession, Enrollment
  - Output: `bounded-context.md`
  - DoD: Reviewed by architect

- **T005**: Set up feature toggle
  - Key: `lecture.new_service.enabled`
  - Initial value: `false`
  - DoD: Toggle works in staging

- **T006**: Design new architecture (Two-Zone pattern)
  - Zone-1: Public API (REST)
  - Zone-2: Internal logic (Domain model)
  - Output: `architecture.md` with diagram
  - DoD: Approved by tech lead

## Phase 3: Interface Delivery

### Interface:I01 (REST GET /api/v1/lectures)

- **T007**: Implement lecture list handler
  - Input: offset, limit (pagination)
  - Output: JSON array of lectures
  - DoD: Unit tests 95% coverage, code review approved
  
- **T008**: Canary routing (5% traffic)
  - Deploy to 1/20 pods, route 5% traffic via Istio
  - Monitor: P50, P99, error rate
  - DoD: P50=148ms (within baseline ± 5%), no errors
  
- **T009**: AC-1 parity test (E2E behavior match)
  - Run 60 E2E test cases (old vs new)
  - Compare: pagination format, HTTP status codes, error messages
  - DoD: 60/60 tests pass identically
  
- **T010**: AC-2 load test vs baseline (no regression)
  - Run wrk: 100 concurrent, 5 minutes
  - Measure: P50, P99, throughput
  - DoD: P50=148ms ≥ 150ms baseline ✓, P99=785ms ≥ 800ms baseline ✓
  
- **T011**: AC-4 rollback rehearsal (MTTR ≤ 5 min)
  - Simulate rollback: kubectl rollout undo
  - Measure: time from trigger to healthy
  - DoD: MTTR=3.2 min ✓ (< 5 min target), zero data loss

### Interface:I02 (REST POST /api/v1/lectures)

- **T012**: Implement lecture creation handler
  - Input: JSON body (title, content)
  - Output: HTTP 201 with lecture ID
  - DoD: Unit tests 95% coverage, code review approved

- **T013**: Canary routing (5% traffic)
  - Deploy to 1/20 pods, route 5% traffic
  - Monitor: P99, error rate
  - DoD: P99 < 800ms, no duplicate title errors

- **T014**: AC-1 parity test
  - Run 40 E2E test cases (old vs new)
  - Compare: lecture ID format, error handling (400 for duplicates)
  - DoD: 40/40 tests pass identically

- **T015**: AC-2 load test vs baseline
  - Run wrk: 50 concurrent POST requests, 3 minutes
  - Measure: P99, throughput
  - DoD: P99 ≥ 800ms baseline ✓, throughput ≥ 1200 req/s ✓

- **T016**: AC-4 rollback rehearsal
  - Simulate rollback during POST traffic
  - Verify: no data loss (dual-write logs match)
  - DoD: MTTR=3.5 min ✓, zero data loss ✓

## Phase 4: Data Migration

- **T017**: Dual-write period (old + new DB)
  - Duration: 48 hours
  - Monitor: replication lag < 1 second
  - DoD: Zero inconsistencies detected

- **T018**: Data consistency verification
  - Compare: old DB vs new DB (lecture count, checksums)
  - DoD: 100% consistency

- **T019**: Cutover to new system (100% traffic)
  - Flip feature toggle: `lecture.new_service.enabled=true`
  - Monitor: P50, P99, error rate for 24 hours
  - DoD: All metrics within baseline ± 10%

## Phase 5: Acceptance Gate Verification

- **T020**: AC-1 parity verification (final)
  - Run full E2E regression suite (120 tests)
  - DoD: 120/120 tests pass ✓
  
- **T021**: AC-2 performance verification (final)
  - Run load test: 200 concurrent, 10 minutes
  - DoD: P50=148ms ≥ 150ms ✓, P99=785ms ≥ 800ms ✓, throughput=1250 req/s ≥ 1200 ✓
  
- **T022**: AC-3 SLA dashboard verification
  - Check: Grafana availability dashboard
  - DoD: 99.97% availability ≥ 99.95% SLA ✓, no P1 alerts
  
- **T023**: AC-4 MTTR measurement (final)
  - Perform production rollback drill (off-peak hours)
  - Measure: time from trigger to healthy
  - DoD: MTTR=3.2 min ✓ (< 5 min target), zero data loss ✓
  
- **T024**: Cleanup and documentation
  - Remove old service code
  - Update runbook with new rollback procedure
  - DoD: PR merged, runbook reviewed
  
- **T025**: Release sign-off
  - Verify: All AC-1~AC-4 gates passed
  - Sign-off: Tech lead, product manager
  - DoD: Release notes published
```

## 关键验证点

### Interface 一致性验证

```bash
# 检查 Plan Interface Inventory
grep "^| I" plan.refactor.md | wc -l
# 预期: 2 (I01, I02)

# 检查 Tasks Interface:Ixx 标签
grep "### Interface:I" tasks.refactor.md | wc -l
# 预期: 2 (I01, I02)

# 验证 1:1 映射
diff <(grep "^| I" plan.refactor.md | awk '{print $2}' | sort) \
     <(grep "### Interface:I" tasks.refactor.md | sed 's/.*Interface:\(I[0-9]*\).*/\1/' | sort)
# 预期: 无差异
```

### AC 验收覆盖率验证

```bash
# Spec 中 AC-1~AC-4 定义
grep "^### AC-" spec.refactor.md | wc -l
# 预期: 4

# Tasks 中 AC 验证任务
grep -E "T0(20|21|22|23):.*AC-[1-4]" tasks.refactor.md | wc -l
# 预期: 4 (每个 AC 一个验证任务)
```

## 常见错误与修复

### 错误 1: Interface Inventory 缺失接口

**症状**:
```markdown
# Plan 中只定义了 I01
| I01 | REST | GET /api/v1/lectures | ...

# 但 Tasks 中出现了 I02
### Interface:I02 (REST POST /api/v1/lectures)
```

**修复**:
在 Plan 的 Interface Inventory 中补充 I02 定义。

### 错误 2: AC 验收标准不量化

**症状**:
```markdown
### AC-2: Performance Consistency
- [ ] 性能不能下降
```

**修复**:
```markdown
### AC-2: Performance Consistency
- [ ] P50 response time ≥ 150ms baseline
- [ ] P99 response time ≥ 800ms baseline
- [ ] Throughput ≥ 1200 req/s baseline
```

### 错误 3: MTTR 目标不明确

**症状**:
```markdown
- **Rollback MTTR**: 尽快
```

**修复**:
```markdown
- **Rollback MTTR**: ≤ 5 minutes (measured in T023 rollback drill)
```

## 本案例验证结果

- **Spec 覆盖率**: 95% (缺少部分边缘场景)
- **Plan 覆盖率**: 90% (Interface Inventory 完整)
- **Tasks 覆盖率**: 90% (所有 AC 验证任务齐全)
- **整体一致性**: 92% ✅

---

**案例来源**: AIDM 讲课服务重构项目（8 应用拆分）  
**验证时间**: 2026-02-05  
**模板版本**: v2.0.0-refactor-acceptance
