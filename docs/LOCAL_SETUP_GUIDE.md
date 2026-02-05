# Specify CLI 本地模板更新指南

## 概述

本指南说明如何在本地开发环境中使用最新的 refactor 模板（已包含 AC-1~AC-4 验收标准和 MTTR 无损发布风险框架）。

---

## 前置条件

- 已安装 `specify` CLI：
  ```bash
  which specify
  # /home/ben/.local/bin/specify
  ```

- 本地 umlspec-kit 项目已更新到最新版本：
  ```bash
  cd /home/ben/project/umlspec-kit
  git log --oneline | head -1
  # bfb9291 refactor: optimize refactor templates...
  ```

---

## 方式一：使用 `--local` 标志（推荐开发）

如果你在本地开发 refactor 模板，使用 `--local` 标志让 specify 读取本地 `templates/` 目录，而不是从 GitHub 下载：

### 初始化项目（使用本地模板）

```bash
cd /your/project
specify init --ai copilot --local
```

**参数说明**：
- `--local`: 使用本地模板和脚本（从 `$REPO_ROOT/templates` 和 `$REPO_ROOT/scripts`）
- `--ai copilot`: 选择 AI agent（也可选 claude, windsurf, q 等）

**效果**：
- Spec Kit 会从本地 `/home/ben/project/umlspec-kit/templates/` 复制模板到你的项目
- 所有命令模板（`.claude/commands/`、`.github/agents/` 等）使用本地版本
- 包括最新的 AC-1~AC-4 验收标准框架

### 生成 Refactor 规划

```bash
# 在你的项目目录中，使用本地模板初始化后：
specify spec refactor "我想重构讲题服务，拆分成 8 个独立应用"
specify plan refactor
specify tasks refactor
```

---

## 方式二：手动复制更新（如果本地未配置 --local）

如果项目已经初始化但想更新到最新的 refactor 模板，可以手动复制：

### 步骤 1: 备份现有模板

```bash
cd /your/project
cp -r specs/ specs.backup
```

### 步骤 2: 复制最新的 refactor 模板

从 umlspec-kit 项目复制模板文件：

```bash
# 复制 template 文件
cp /home/ben/project/umlspec-kit/templates/spec-template.refactor.md specs/
cp /home/ben/project/umlspec-kit/templates/plan-template.refactor.md specs/
cp /home/ben/project/umlspec-kit/templates/tasks-template.refactor.md specs/

# 复制命令文件
cp -r /home/ben/project/umlspec-kit/templates/commands/* /your/project/.claude/commands/  # 或其他 agent 目录
```

### 步骤 3: 验证更新

```bash
# 查看新的验收标准
grep -A 5 "Acceptance Criteria" specs/spec-template.refactor.md

# 查看 MTTR 风险定义
grep -A 5 "Lossless Release Risk" specs/spec-template.refactor.md
```

---

## 新特性：AC-1~AC-4 验收标准框架

更新后的模板包含以下新特性：

### 在 Spec 中定义验收标准

```markdown
## Acceptance Criteria *(mandatory)*

### AC-1: User Behavior Consistency (E2E Parity)
| Scenario | Baseline | Post-Refactor | Verification |
...

### AC-2: Performance Consistency (No Regression)
| Metric | Baseline | Acceptance Threshold |
| P95 Latency | 180ms | ≤ 180ms |
...

### AC-3: SLA Consistency (No Degradation)
| SLA Metric | Baseline | Acceptance Threshold |
...

### AC-4: Lossless Release (MTTR Risk)
| Dimension | Requirement | Status |
| Rollback MTTR | ≤ 5 min | verified |
...
```

### 在 Plan 中对齐 Rollout 检查清单

```markdown
## Migration & Rollout Plan

### Rollout Checklist (maps to spec.md Acceptance Gate)
- [ ] **AC-1 ready**: Parity tests defined and passing
- [ ] **AC-2 ready**: Performance baseline captured
- [ ] **AC-3 ready**: SLA dashboards configured
- [ ] **AC-4 ready**: Rollback MTTR rehearsed
```

### 在 Tasks 中明确 Acceptance Gate 验证

```markdown
## Phase 5: Acceptance Gate Verification

- [ ] T015 AC-1 verification: Run full E2E parity test
- [ ] T016 AC-2 verification: Load test vs baseline
- [ ] T017 AC-3 verification: SLA dashboards
- [ ] T018 AC-4 verification: Rollback rehearsal + MTTR record
```

---

## 快速参考

### 使用本地模板创建新的 refactor 项目

```bash
cd /your/new/project
specify init --ai copilot --local
specify spec refactor "问题描述"
specify plan refactor
specify tasks refactor
```

### 生成的文件结构

```
specs/[###-feature]/
├── spec.md                          # AC-1~AC-4 验收标准
├── plan.md                          # Interface Inventory + MTTR rollout
├── baseline.md                      # 基线行为、性能、可观测性
├── impact-map.md                    # 影响范围与证据
├── migration.md                     # 迁移计划 + 回滚策略
├── tasks.md                         # Phase 1~5，含 AC 验证任务
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── checklists/
```

### 验收关键步骤

1. **Spec 阶段**：定义 AC-1~AC-4，明确 Acceptance Gate
2. **Plan 阶段**：细化 Interface Inventory，设定 MTTR 目标
3. **Tasks 第 1~4 阶段**：交付接口实现
4. **Tasks 第 5 阶段**：Acceptance Gate Verification
   - T015: AC-1 parity 全量测试
   - T016: AC-2 负载测试对比
   - T017: AC-3 SLA 仪表盘
   - T018: AC-4 回滚演练 + MTTR 验证

---

## 验证本地更新

### 检查模板版本

```bash
# 查看本地 refactor 模板的最新变动
cd /home/ben/project/umlspec-kit
git log --oneline -n 5 templates/spec-template.refactor.md

# 应该看到：
# bfb9291 refactor: optimize refactor templates with consistency-driven acceptance...
```

### 测试本地生成

```bash
cd /tmp/test-refactor
specify init --ai copilot --local
specify spec refactor "test"

# 检查生成的 spec 是否包含新的 AC 标准
grep "AC-1\|AC-2\|AC-3\|AC-4" specs/*/spec.md
```

---

## 问题排查

### 问题 1：`specify: command not found`

**解决**：确保 specify 已安装
```bash
which specify
# 如果没有，运行：
uv tool install specify-cli
```

### 问题 2：`--local` 标志不识别

**原因**：specify 版本过旧  
**解决**：
```bash
uv tool upgrade specify-cli
```

### 问题 3：找不到本地模板

**原因**：`--local` 指向的仓库根目录不对  
**解决**：
```bash
# 确认当前目录有 templates/ 子目录
ls -la templates/
# 如果没有，需要在 umlspec-kit 项目根目录运行
cd /home/ben/project/umlspec-kit
specify init --ai copilot --local
```

---

## 相关文档

- [Refactor 模板总体说明](README.md)
- [验证报告](refactor-template-validation-report.md)：Spec/Plan/Tasks 覆盖度与一致性检查
- [GitHub Release](https://github.com/bigsmartben/umlspec-kit/releases/tag/v2.0.0-refactor-acceptance)：最新变动说明

---

**最后更新**：2026-02-05  
**Specify CLI 版本**：使用 `--local` 标志调用本地模板  
**Refactor Template 版本**：v2.0.0-refactor-acceptance
