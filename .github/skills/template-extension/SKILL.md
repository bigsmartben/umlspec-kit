---
name: template-extension
description: Extend Specify CLI with custom refactor templates including AC-1~AC-4 acceptance framework, Interface Inventory consistency, and MTTR-based lossless release verification. Use when adding new scenario templates (refactor/data/feature) or optimizing existing templates for consistency-driven acceptance.
---

# Template Extension Skill

## 目的

为 Specify CLI 扩展和优化自定义模板，特别是 refactor 场景模板。实现一致性驱动的接受标准（AC-1~AC-4 框架）、接口粒度任务分解、硬一致性契约（Interface:Ixx），以及 MTTR 无损发布风险度量。

## 何时使用

- 添加新的 refactor 模板（spec/plan/tasks）
- 优化现有模板的接受标准
- 实现接口粒度的任务分解
- 建立 spec→plan→tasks 传递链的一致性契约
- 定义 MTTR 风险度量

## 核心原则

### 1. 一致性驱动接受（Consistency-Driven Acceptance）

Refactor 项目的成功基于 **一致性**（behavior/performance/SLA/MTTR），而非创新或优化。

**AC-1~AC-4 框架**:
- **AC-1**: 用户行为一致性（User Behavior Consistency）- E2E 回归测试证明功能等价
- **AC-2**: 性能一致性（Performance Consistency）- 基线对标负载测试，0% 性能下降
- **AC-3**: SLA 一致性（SLA Consistency）- 可用性、告警阈值无劣化
- **AC-4**: 无损发布（Lossless Release）- MTTR 预演验证，零数据丢失，零停机

### 2. 接口粒度交付（Interface-Granular Delivery）

**原则**: 1 个 Interface = 1 个交付任务

**接口定义**:
- ✅ 包含: HTTP/WebSocket/Socket 端到端接口
- ❌ 排除: 内部 RPC、MQ consumer、定时任务

**任务结构**:
```markdown
### Interface:I01 (REST POST /api/v1/users)
- T007: 实现处理器
- T008: 金丝雀路由（5% 流量）
- T009: AC-1 等价测试（E2E 行为匹配）
- T010: AC-2 负载测试 vs 基线（无回退）
- T011: AC-4 回滚预演（MTTR ≤ 5 min）
```

### 3. 硬一致性契约（Hard Consistency Contract）

**Interface:Ixx 标签机制**:
- Plan 中的 Interface Inventory 为单一真实来源
- Tasks 中每个接口必须携带 `Interface:Ixx` 标签
- 1:1 映射，双向可验证（机械检查）

**验证规则**:
```bash
# Plan: Interface Inventory 定义
| I01 | REST | POST /api/v1/users | {...} | Team-A | {...} |

# Tasks: 必须出现且仅出现一次
### Interface:I01 (REST POST /api/v1/users)
```

### 4. MTTR 风险度量（MTTR-Based Risk Measurement）

**四个维度**:
1. **Rollback MTTR**: 回滚耗时 ≤ 5 分钟（包含验证）
2. **Data Loss Window**: 数据丢失窗口 = 0 秒（双写验证）
3. **User-Visible Downtime**: 用户可见停机 = 0 秒（蓝绿/金丝雀）
4. **Blast Radius**: 爆炸半径 = 单实例（功能开关隔离）

## 实施步骤

### 第一步: 分析目标架构与最佳实践

1. **识别目标架构**（参考文档或项目）
   - Two-Zone 分层
   - Projection 投影模式
   - Scope 控制边界

2. **确定接口清单**
   - 列出所有端到端接口（HTTP/WebSocket/Socket）
   - 排除内部 RPC、MQ、定时任务
   - 分配 Interface ID（I01, I02, ...）

3. **定义接受标准基线**
   - 性能基线（P50/P99 响应时间、吞吐量、错误率）
   - SLA 基线（可用性、MTTR）
   - 行为基线（E2E 测试用例覆盖）

### 第二步: 优化 Spec 模板

**文件**: `templates/spec-template.refactor.md`

**关键内容**:

```markdown
## Performance Targets

| Metric | Baseline | Target | Verification |
|--------|----------|--------|--------------|
| Response Time (P50) | 100ms | ≥100ms (0% regression) | Load test |
| Response Time (P99) | 500ms | ≥500ms (0% regression) | Load test |
| Throughput | 1000 req/s | ≥1000 req/s | Load test |
| Error Rate | 0.1% | ≤0.1% (no increase) | Monitoring |

## Lossless Release Risk (MTTR-based)

- **Rollback MTTR**: ≤ 5 minutes (including verification)
- **Data Loss Window**: 0 seconds (dual-write + replication lag check)
- **User-Visible Downtime**: 0 seconds (blue-green + canary routing)
- **Blast Radius**: Single instance (feature flags + circuit breakers)

## Acceptance Criteria

### AC-1: User Behavior Consistency (E2E Parity)
- [ ] All E2E test cases pass with identical results (old vs new)
- [ ] Error messages and HTTP status codes match exactly
- [ ] Database write operations produce identical outcomes

### AC-2: Performance Consistency (No Regression)
- [ ] P50 response time ≥ baseline
- [ ] P99 response time ≥ baseline
- [ ] Throughput ≥ baseline
- [ ] Error rate ≤ baseline

### AC-3: SLA Consistency (No Degradation)
- [ ] Availability ≥ existing SLA (e.g., 99.95%)
- [ ] Alert thresholds remain the same or stricter
- [ ] Recovery time ≤ existing MTTR target

### AC-4: Lossless Release (MTTR-Verified)
- [ ] Rollback MTTR measured ≤ 5 minutes
- [ ] Zero data loss during rollback drill
- [ ] Canary traffic never exceeded 10%
- [ ] No critical alerts during deployment

## Acceptance Gate
- [ ] AC-1 verified
- [ ] AC-2 verified
- [ ] AC-3 verified
- [ ] AC-4 verified
```

### 第三步: 优化 Plan 模板

**文件**: `templates/plan-template.refactor.md`

**关键内容**:

```markdown
## Non-Negotiables

（从 Spec 继承 Invariants，避免重复定义）

## Interface Inventory (Source of Truth)

| Ixx | Type | Method/Path | Contract | Owner | Invariants | Verification |
|-----|------|------------|----------|-------|-----------|--------------|
| I01 | REST | POST /api/v1/users | {...} | Team-A | {...} | E2E test |
| I02 | WebSocket | wss://socket.api/chat | {...} | Team-B | {...} | Integration test |

**Hard Consistency Rules**:
1. Each Ixx appears exactly once in this table
2. Each Ixx must appear exactly once in Tasks with `Interface:Ixx` tag
3. No Ixx can be renumbered after Tasks generation (stable anchor)

## Migration & Rollout Plan

### Rollback Strategy
- **MTTR Target**: ≤ 5 minutes (from spec)
- **Rollout Checklist**:
  - [ ] AC-1: E2E parity verified
  - [ ] AC-2: Performance baseline met
  - [ ] AC-3: SLA dashboard green
  - [ ] AC-4: Rollback drill successful

## Performance Plan

（参考 Spec 的 Performance Targets 表，不重复列出数值）
```

### 第四步: 优化 Tasks 模板

**文件**: `templates/tasks-template.refactor.md`

**关键内容**:

```markdown
# Refactor Tasks

## HARD CONSISTENCY CONTRACT

**Interface:Ixx Mapping Rules**:
1. Every Ixx in Plan Interface Inventory → Exactly one `Interface:Ixx` section in Tasks
2. Every `Interface:Ixx` in Tasks → Must exist in Plan Interface Inventory
3. Verification: Mechanical check (grep "Interface:I" tasks.md | sort | uniq)

## Phase 1: Baseline & Safety Net

- **T001**: Establish baseline
  - Record P50/P99 response time, throughput, error rate
  - Output: `baseline.md` with metrics table
  
- **T002**: Create impact map and migration script
  - Document data flow, dependencies, rollback steps
  - Output: `impact-map.md`, `migration.md`

- **T003**: Document rollback procedure
  - MTTR target: ≤ 5 minutes
  - Verification: Dry-run rehearsal

## Phase 2: Foundations

- **T004**: Define service boundaries (DDD contexts)
- **T005**: Set up feature toggles for gradual rollout
- **T006**: Design new architecture (Two-Zone/Projection)

## Phase 3: Interface Delivery (1 Interface = 1 Delivery Task)

### Interface:I01 (REST POST /api/v1/users)

- **T007**: Implement handler in new service
  - DoD: Unit tests pass, code review approved
  
- **T008**: Canary routing (5% traffic)
  - DoD: Monitoring shows P50/P99 within baseline ± 5%
  
- **T009**: AC-1 parity test (E2E behavior match)
  - DoD: All E2E test cases pass identically
  
- **T010**: AC-2 load test vs baseline (no regression)
  - DoD: P50 ≥ baseline, P99 ≥ baseline, throughput ≥ baseline
  
- **T011**: AC-4 rollback rehearsal (MTTR ≤ 5 min)
  - DoD: Rollback completed in < 5 min, zero data loss

### Interface:I02 (WebSocket wss://socket.api/chat)

- **T012**: Implement handler in new service
- **T013**: Canary routing (5% traffic)
- **T014**: AC-1 parity test
- ... (repeat AC-2, AC-4 verification)

## Phase 4: Data Migration (if applicable)

- **T015**: Dual-write period (old + new systems)
- **T016**: Data consistency verification
- **T017**: Cutover to new system (100% traffic)

## Phase 5: Acceptance Gate Verification

- **T018**: AC-1 parity verification (final)
  - All E2E tests pass, behavior identical
  
- **T019**: AC-2 performance verification (final)
  - Load test confirms no regression
  
- **T020**: AC-3 SLA dashboard verification
  - Availability ≥ SLA, no degraded alerts
  
- **T021**: AC-4 MTTR measurement (final)
  - Rollback drill: MTTR < 5 min, zero data loss
  
- **T022**: Cleanup and documentation
  - Remove feature toggles, update runbooks
  
- **T023**: Release sign-off
  - All AC-1~AC-4 gates passed
```

### 第五步: 更新命令模板

**文件**: `templates/commands/{spec,plan,tasks}.refactor.md`

确保命令模板引导 AI 生成符合上述结构的文档：

```markdown
# Spec Command Template

Generate a refactor spec with:
1. Performance Targets table (baseline-driven)
2. Lossless Release Risk (MTTR dimensions)
3. AC-1~AC-4 Acceptance Criteria
4. Acceptance Gate checklist

# Plan Command Template

Generate a refactor plan with:
1. Interface Inventory table (Ixx mapping)
2. Hard Consistency Rules reminder
3. Rollout Checklist mapped to AC-1~AC-4

# Tasks Command Template

Generate refactor tasks with:
1. HARD CONSISTENCY CONTRACT section
2. Phase 3: Interface Delivery (one per Ixx)
3. Phase 5: AC verification tasks (T018-T023)
```

### 第六步: 验证与文档

1. **创建验证报告**（可选）
   - 文件: `docs/refactor-template-validation-report.md`
   - 内容: 对标真实项目（如 AIDM），计算覆盖率
   - 示例: Spec 95%, Plan 90%, Tasks 90%

2. **创建使用指南**
   - 文件: `docs/TEMPLATE_USAGE_GUIDE.md`
   - 内容: 同步方法、工作流、AC 框架详解、故障排查

3. **创建同步脚本**
   - 文件: `scripts/bash/sync-local-templates.sh`
   - 功能: 将模板复制到项目的 `.specify/templates/`

## 模板更新 Checklist

### 模板文件
- [ ] `spec-template.refactor.md` - AC-1~AC-4 + MTTR 风险
- [ ] `plan-template.refactor.md` - Interface Inventory + 一致性规则
- [ ] `tasks-template.refactor.md` - Interface:Ixx 粒度 + AC 验收任务
- [ ] `commands/spec.refactor.md` - 命令模板
- [ ] `commands/plan.refactor.md` - 命令模板
- [ ] `commands/tasks.refactor.md` - 命令模板

### 文档和脚本
- [ ] `docs/TEMPLATE_USAGE_GUIDE.md` - 完整使用指南
- [ ] `docs/LOCAL_SETUP_GUIDE.md` - 本地设置说明（可选）
- [ ] `docs/refactor-template-validation-report.md` - 验证报告（可选）
- [ ] `scripts/bash/sync-local-templates.sh` - Bash 同步脚本
- [ ] `scripts/powershell/sync-local-templates.ps1` - PowerShell 同步脚本

### Git 和发布
- [ ] 提交所有模板更改（详细 commit message）
- [ ] 推送到 GitHub
- [ ] 创建 Release tag（如 v2.0.0-refactor-acceptance）
- [ ] 撰写 Release Notes（包含特性、验证、使用方法）

## 输出示例

### Spec 输出示例

```markdown
# Refactor Spec: 讲课服务拆分

## Performance Targets

| Metric | Baseline | Target | Verification |
|--------|----------|--------|--------------|
| 课程列表 P50 | 120ms | ≥120ms (0% regression) | Load test |
| 课程详情 P99 | 600ms | ≥600ms (0% regression) | Load test |
| 创建课程 throughput | 800 req/s | ≥800 req/s | Load test |

## Lossless Release Risk

- **Rollback MTTR**: ≤ 5 minutes
- **Data Loss Window**: 0 seconds (dual-write)
- **User-Visible Downtime**: 0 seconds (blue-green)
- **Blast Radius**: Single instance

## Acceptance Criteria

### AC-1: User Behavior Consistency
- [ ] 课程创建 API 返回相同的课程 ID 格式
- [ ] 错误场景（重复课程名）返回相同 HTTP 400
- [ ] WebSocket 消息格式完全一致

### AC-2: Performance Consistency
- [ ] 课程列表 P50 ≥ 120ms ✓
- [ ] 课程详情 P99 ≥ 600ms ✓
- [ ] 创建课程吞吐 ≥ 800 req/s ✓

### AC-3: SLA Consistency
- [ ] 可用性 ≥ 99.9% (现有 SLA)
- [ ] 告警阈值无变化

### AC-4: Lossless Release
- [ ] Rollback MTTR = 3.5 min ✓ (< 5 min)
- [ ] 回滚期间零数据丢失 ✓
```

### Plan 输出示例

```markdown
# Refactor Plan: 讲课服务拆分

## Interface Inventory (Source of Truth)

| Ixx | Type | Method/Path | Contract | Owner | Invariants | Verification |
|-----|------|------------|----------|-------|-----------|--------------|
| I01 | REST | GET /api/v1/courses | Pagination, 200/400 | Team-Lecture | Course ID format | E2E test |
| I02 | REST | POST /api/v1/courses | JSON body, 201/400 | Team-Lecture | Unique name | E2E test |
| I03 | REST | GET /api/v1/courses/{id} | Path param, 200/404 | Team-Lecture | Cache TTL 60s | E2E test |
| I04 | WebSocket | wss://ws.api/lecture | Subscribe protocol | Team-Lecture | Message order | Integration test |

**Hard Consistency Rules**:
- Each Ixx must appear exactly once in Tasks with `Interface:Ixx` tag
- No renumbering after Tasks generation
```

### Tasks 输出示例

```markdown
# Refactor Tasks: 讲课服务拆分

## HARD CONSISTENCY CONTRACT

Interface:I01, I02, I03, I04 must each appear exactly once below.

## Phase 3: Interface Delivery

### Interface:I01 (REST GET /api/v1/courses)

- **T007**: 实现课程列表 handler
  - DoD: 单元测试覆盖率 > 80%
  
- **T008**: 金丝雀路由（5% 流量）
  - DoD: P50 = 118ms ✓ (within baseline ± 5%)
  
- **T009**: AC-1 等价测试
  - DoD: 50 个 E2E 用例全部通过
  
- **T010**: AC-2 负载测试
  - DoD: P50 = 118ms ≥ 120ms baseline ✓

### Interface:I02 (REST POST /api/v1/courses)

- **T011**: 实现课程创建 handler
- **T012**: 金丝雀路由（5% 流量）
- **T013**: AC-1 等价测试
- **T014**: AC-2 负载测试

（以此类推 I03, I04）
```

## 参考资源

### 文档
- [VS Code Agent Skills 规范](https://code.visualstudio.com/docs/copilot/customization/agent-skills)
- [Agent Skills 开放标准](https://agentskills.io/)
- 项目文档: `docs/TEMPLATE_USAGE_GUIDE.md`
- 验证报告: `docs/refactor-template-validation-report.md`

### 脚本
- Bash 同步: `scripts/bash/sync-local-templates.sh`
- PowerShell 同步: `scripts/powershell/sync-local-templates.ps1`

### 最佳实践
- 始终从 spec 定义 AC-1~AC-4，plan 和 tasks 引用（不重复定义）
- Interface Inventory 在 plan 中定义一次，spec 和 tasks 仅引用
- MTTR 目标在 spec 中定义，plan 和 tasks 执行验证
- 每个接口独立交付，独立验收（1:1 原则）

## 故障排查

### 问题: Interface Inventory 缺失

**症状**: Tasks 中无法找到 Interface:Ixx 对应的定义

**解决**:
1. 检查 Plan 的 Interface Inventory 表是否完整
2. 确认每个 Ixx 在 Plan 中出现且仅出现一次
3. 重新生成 Tasks（`specify tasks refactor --force`）

### 问题: AC 验收标准不一致

**症状**: Spec/Plan/Tasks 中 AC-1~AC-4 描述不同

**解决**:
1. 以 Spec 为准（单一真实来源）
2. Plan 和 Tasks 仅引用 Spec 中的 AC 编号
3. 避免在 Plan/Tasks 中重新定义 AC 内容

### 问题: MTTR 目标未量化

**症状**: Spec 中 MTTR 目标为 "尽快"、"几分钟"

**解决**:
1. 设定具体数值（如 ≤ 5 minutes）
2. 在 Plan 的 Rollback Strategy 中引用该数值
3. 在 Tasks 的 AC-4 任务中验证该数值

---

**技能版本**: 1.0.0  
**最后更新**: 2026-02-05  
**兼容**: Specify CLI v2.0.0+
