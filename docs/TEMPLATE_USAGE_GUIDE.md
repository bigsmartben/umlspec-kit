# Specify CLI 本地模板更新指南 v2.0.0-refactor-acceptance

## 🎯 概述

本指南说明如何在本地使用最新的 refactor 模板（v2.0.0-refactor-acceptance）与 Specify CLI 集成。包括三种方法，从简单到复杂。

**关键特性**:
- ✅ AC-1~AC-4 接受标准框架（一致性驱动）
- ✅ Interface 粒度任务分解（1 接口 = 1 交付任务）
- ✅ 硬一致性契约（Interface:Ixx 标签机制）
- ✅ MTTR 无损发布风险度量
- ✅ 92% 验证覆盖率（基于 AIDM 项目）

---

## 方法 1：使用同步脚本（推荐）

### 前置条件
- Specify CLI 已安装：`which specify`
- umlspec-kit repo 可访问：`/home/ben/project/umlspec-kit`

### Bash 版本（Linux/macOS）

```bash
# 1. Clone 或 navigate 到目标项目
cd /path/to/your/project

# 2. 运行同步脚本
/home/ben/project/umlspec-kit/scripts/bash/sync-local-templates.sh .

# 3. 验证同步成功
ls -la .specify/templates/
```

**输出示例**：
```
╔════════════════════════════════════════════════════════════╗
║  Sync Local Refactor Templates - Specify v2.0.0+          ║
╚════════════════════════════════════════════════════════════╝

✓ All refactor templates found in /home/ben/project/umlspec-kit
✓ Working in: /path/to/your/project
✓ Created: .specify
✓ Synced 6 template files

╔════════════════════════════════════════════════════════════╗
║  ✅ Sync Complete                                          ║
╚════════════════════════════════════════════════════════════╝
```

### PowerShell 版本（Windows）

```powershell
# 1. Navigate 到目标项目
cd C:\path\to\your\project

# 2. 运行同步脚本
& "C:\path\to\umlspec-kit\scripts\powershell\sync-local-templates.ps1" .

# 3. 验证同步成功
Get-ChildItem .specify/templates -Recurse
```

---

## 方法 2：手动复制（快速）

如果脚本执行失败，手动复制也很简单：

```bash
# 1. 创建 .specify 目录
mkdir -p .specify/templates/commands

# 2. 复制 refactor 模板
cp /home/ben/project/umlspec-kit/templates/spec-template.refactor.md .specify/templates/
cp /home/ben/project/umlspec-kit/templates/plan-template.refactor.md .specify/templates/
cp /home/ben/project/umlspec-kit/templates/tasks-template.refactor.md .specify/templates/
cp /home/ben/project/umlspec-kit/templates/commands/spec.refactor.md .specify/templates/commands/
cp /home/ben/project/umlspec-kit/templates/commands/plan.refactor.md .specify/templates/commands/
cp /home/ben/project/umlspec-kit/templates/commands/tasks.refactor.md .specify/templates/commands/

# 3. 验证
ls -la .specify/templates/
```

---

## 方法 3：使用 Git 符号链接（开发用）

如果你频繁更新模板，可以创建符号链接指向源文件：

```bash
# 1. 创建 .specify 目录
mkdir -p .specify/templates/commands

# 2. 创建符号链接（Linux/macOS）
ln -s /home/ben/project/umlspec-kit/templates/spec-template.refactor.md .specify/templates/
ln -s /home/ben/project/umlspec-kit/templates/plan-template.refactor.md .specify/templates/
ln -s /home/ben/project/umlspec-kit/templates/tasks-template.refactor.md .specify/templates/
ln -s /home/ben/project/umlspec-kit/templates/commands/spec.refactor.md .specify/templates/commands/
ln -s /home/ben/project/umlspec-kit/templates/commands/plan.refactor.md .specify/templates/commands/
ln -s /home/ben/project/umlspec-kit/templates/commands/tasks.refactor.md .specify/templates/commands/

# 3. 验证
ls -la .specify/templates/
```

**注意**: 符号链接使模板自动更新，但在 CI/CD 中可能不兼容。

---

## 使用 Refactor 模板

### 1️⃣ 初始化项目（可选）

如果尚未初始化，可使用 `--local` 标志：

```bash
specify init --ai copilot --local
```

### 2️⃣ 创建 Refactor Spec

定义重构的目标、接受标准和风险度量：

```bash
specify spec refactor "Description of your refactor task"
```

**生成的文件**: `.specs/spec.refactor.md`

**关键内容**:
```markdown
# Refactor Spec

## Business Objectives
- [描述目标]

## Current State Analysis
- Architecture Diagram
- Key Metrics (baseline)

## Target Architecture
- Interface Inventory (Ixx mapping)
- Invariants (保持不变)

## Performance Targets
- Response Time: baseline ± 0%
- Throughput: baseline ± 0%
- Error Rate: baseline (0% regression)

## Lossless Release Risk (MTTR-based)
- Rollback MTTR: ≤ 5 min
- Data Loss Window: 0
- User-Visible Downtime: 0
- Blast Radius: single instance

## Acceptance Criteria
- AC-1: User Behavior Consistency (E2E parity)
- AC-2: Performance Consistency (no regression)
- AC-3: SLA Consistency (no degradation)
- AC-4: Lossless Release (MTTR-verified)

## Acceptance Gate
- [ ] AC-1 verified
- [ ] AC-2 verified
- [ ] AC-3 verified
- [ ] AC-4 verified
```

### 3️⃣ 生成 Plan（含 Interface Inventory）

设计目标架构和接口清单（任务分解的源头）：

```bash
specify plan refactor
```

**生成的文件**: `.plans/plan.refactor.md`

**关键内容**:
```markdown
# Refactor Plan

## Non-Negotiables
- [从 spec 继承的 Invariants]

## Interface Inventory (Source of Truth)
| Ixx | Type | Method/Path | Contract | Owner | Invariants | Verification |
|-----|------|------------|----------|-------|-----------|--------------|
| I01 | REST | POST /api/v1/users | {...} | Team-A | {...} | {...} |
| I02 | WS | wss://socket.api/chat | {...} | Team-B | {...} | {...} |

## Migration & Rollout Plan
- Phase 1: Baseline & Safety Net
  - MTTR target: ≤ 5 min (from spec)
  - Rollout checklist mapped to AC-1~AC-4

## Performance Plan
- Baseline metrics from spec
- Verification points per interface
```

**关键约束**:
- Interface Inventory 是单一真实来源（避免 spec/tasks 冗余）
- 每个 Ixx 在 plan 中出现一次，在 tasks 中配对出现

### 4️⃣ 生成 Tasks（接口粒度交付）

按 Interface 分解任务，每个接口一个交付任务，加入 AC 验收：

```bash
specify tasks refactor
```

**生成的文件**: `.tasks/tasks.refactor.md`

**关键内容**:
```markdown
# Refactor Tasks

## Phase 1: Baseline & Safety Net
- T001: Establish baseline (response time, throughput, error rate)
- T002: Create migration script and impact map
- T003: Document rollback procedure

## Phase 2: Foundations
- T004: Define service boundaries
- T005: Set up feature toggles
- T006: Design new architecture

## Phase 3: Interface Delivery (Interface:Ixx granularity)
### Interface:I01 (REST POST /api/v1/users)
- T007: Implement handler in new service
- T008: Canary routing (5% traffic)
- T009: AC-1 parity test (E2E behavior match)
- T010: AC-2 load test vs baseline (no regression)
- T011: AC-4 rollback rehearsal (MTTR ≤ 5 min)

### Interface:I02 (WebSocket wss://socket.api/chat)
- T012: Implement handler in new service
- T013: Canary routing (5% traffic)
- T014: AC-1 parity test
- ...

## Phase 5: Acceptance Gate Verification
- T015: AC-1 parity verification (final)
- T016: AC-2 performance verification
- T017: AC-3 SLA dashboard
- T018: AC-4 MTTR measurement
- T019: Cleanup and documentation
- T020: Release sign-off
```

---

## 📊 AC-1~AC-4 框架详解

### AC-1: 用户行为一致性（E2E Parity）

**定义**: 新服务与旧服务的用户可观察行为完全一致

**验证方式**:
```bash
# 回归测试：旧版本 vs 新版本输出
./test/regression-test.sh --baseline=$OLD_SERVICE_URL --target=$NEW_SERVICE_URL
```

**通过标准**:
- ✅ 100% 端点响应格式一致
- ✅ 错误消息完全相同（含 HTTP 状态码）
- ✅ 数据库写操作结果一致

### AC-2: 性能一致性（No Regression）

**定义**: 响应时间、吞吐量、错误率无低于基线的下降

**基线示例**:
```
服务 A: P50=100ms, P99=500ms, Throughput=1000 req/s, Error=0.1%
目标:   P50≥100ms, P99≥500ms, Throughput≥1000 req/s, Error≤0.1%
```

**验证方式**:
```bash
# 负载测试（100 并发，5 分钟）
wrk -t12 -c100 -d300s --latency $NEW_SERVICE_URL
```

**通过标准**:
- ✅ P50 不低于基线
- ✅ P99 不低于基线
- ✅ 吞吐量不低于基线
- ✅ 错误率不高于基线

### AC-3: SLA 一致性（No Degradation）

**定义**: 可用性、事件影响范围无劣化

**指标示例**:
```
原 SLA: 99.95% 可用性，≤5 分钟恢复时间
新 SLA: ≥99.95% 可用性，≤5 分钟恢复时间
```

**验证方式**:
- 监控仪表板对比（图表历史）
- 告警规则验证（相同阈值）
- 事件根本原因分析

### AC-4: 无损发布（MTTR-Verified）

**定义**: 发布过程中零数据丢失、零用户可见停机、可快速回滚

**四个维度**:

| 维度 | 目标 | 验证 |
|------|------|------|
| **Rollback MTTR** | ≤ 5 分钟 | 预演回滚（T018） |
| **Data Loss Window** | 0 秒 | 双写验证、日志检查 |
| **User-Visible Downtime** | 0 秒 | 蓝绿部署、金丝雀路由 |
| **Blast Radius** | 单实例 | 功能开关、容错边界 |

**验证方式**:
```bash
# 预演回滚（生产环境模拟）
./scripts/rollback-drills.sh --iterations=3 --measure-mttr
```

**通过标准**:
- ✅ Rollback 完成 ≤ 5 分钟（含验证）
- ✅ 回滚期间零数据丢失
- ✅ 金丝雀流量未超 10%
- ✅ 无告警触发

---

## 🔧 故障排查

### 问题 1: Specify CLI 未找到

```bash
❌ Error: command not found: specify
```

**解决**:
```bash
# 使用 uv 安装
uv tool install specify-cli

# 或从源码安装
pip install -e /home/ben/project/umlspec-kit
```

### 问题 2: 模板未同步到 .specify

```bash
❌ Error: Template not found: spec-template.refactor.md
```

**解决**:
```bash
# 手动运行同步
/home/ben/project/umlspec-kit/scripts/bash/sync-local-templates.sh .

# 或检查权限
ls -la .specify/templates/
chmod 644 .specify/templates/*.md
```

### 问题 3: Interface Inventory 缺失

```bash
⚠️ Warning: Plan missing Interface Inventory table
```

**解决**:
```bash
# 重新生成 plan（确保使用 refactor 模板）
specify plan refactor --force

# 手动补充（参考 Interface Inventory 表格格式）
```

### 问题 4: AC 验收门禁未完成

```bash
❌ Acceptance Gate failed: AC-2 not verified
```

**解决**:
```bash
# 运行负载测试
wrk -t12 -c100 -d300s --latency $NEW_SERVICE_URL > perf-results.txt

# 更新 spec 的 AC-2 检查项
- [x] AC-2 verified (baseline: P50=100ms, new: P50=98ms ✓)
```

---

## 📚 完整文档

| 文件 | 用途 | 位置 |
|------|------|------|
| **LOCAL_SETUP_GUIDE.md** | 本地模板设置 | `/home/ben/project/umlspec-kit/docs/` |
| **refactor-template-validation-report.md** | 验证报告（AIDM 案例） | `/home/ben/project/umlspec-kit/docs/` |
| **spec-template.refactor.md** | Spec 模板（AC 框架） | `/home/ben/project/umlspec-kit/templates/` |
| **plan-template.refactor.md** | Plan 模板（Interface Inventory） | `/home/ben/project/umlspec-kit/templates/` |
| **tasks-template.refactor.md** | Tasks 模板（接口粒度） | `/home/ben/project/umlspec-kit/templates/` |
| **GitHub Release** | v2.0.0-refactor-acceptance | https://github.com/bigsmartben/umlspec-kit/releases/tag/v2.0.0-refactor-acceptance |

---

## 🚀 快速开始（5 分钟）

```bash
# 1. 同步模板
/home/ben/project/umlspec-kit/scripts/bash/sync-local-templates.sh .

# 2. 创建 refactor 三件套
specify spec refactor "Microservice extraction: User Service"
specify plan refactor
specify tasks refactor

# 3. 在编辑器中打开文件
code .specs/spec.refactor.md
code .plans/plan.refactor.md
code .tasks/tasks.refactor.md

# 4. 填充 Interface Inventory（plan）
# → 列出所有待重构的端点（I01, I02, ...)

# 5. 验证一致性
# → spec 中 AC-1~AC-4 完整定义
# → plan 中 Interface Inventory 完整
# → tasks 中每个 Ixx 出现一次，含 Interface:Ixx 标签
```

---

## ✅ 验收清单

- [ ] Specify CLI 已安装（`specify --version`）
- [ ] 模板已同步（`.specify/templates/*.refactor.md` 存在）
- [ ] Spec 已创建（包含 AC-1~AC-4 和 Acceptance Gate）
- [ ] Plan 已创建（包含 Interface Inventory 表格）
- [ ] Tasks 已创建（包含 Interface:Ixx 标签和 AC 验收任务）
- [ ] Interface Inventory 行数与 Tasks 中 Ixx 一致
- [ ] MTTR 目标已定义（Spec 和 Plan 对齐）
- [ ] AC 验收标准具体可测（包含数值阈值）

---

## 💬 获取帮助

- **文档**: 参考 `/home/ben/project/umlspec-kit/docs/`
- **案例**: 查看 AIDM 项目验证报告（refactor-template-validation-report.md）
- **反馈**: 提交 issue 或 PR 到 https://github.com/bigsmartben/umlspec-kit

---

*v2.0.0-refactor-acceptance | 最后更新: 2024*
