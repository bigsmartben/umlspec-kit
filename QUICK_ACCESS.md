# Specify CLI 本地模板更新 - 快速访问

## 📖 立即阅读（按优先级）

### 🎯 第一次使用（5 分钟）
1. **快速开始**: [TEMPLATE_USAGE_GUIDE.md](docs/TEMPLATE_USAGE_GUIDE.md#🚀-快速开始5-分钟)
2. **同步脚本**: 
   ```bash
   /home/ben/project/umlspec-kit/scripts/bash/sync-local-templates.sh .
   ```

### 📚 完整文档（15 分钟）
1. **主指南**: [TEMPLATE_USAGE_GUIDE.md](docs/TEMPLATE_USAGE_GUIDE.md)
   - 三种同步方法
   - 完整工作流
   - AC-1~AC-4 框架详解
   - 故障排查

2. **本地设置**: [LOCAL_SETUP_GUIDE.md](docs/LOCAL_SETUP_GUIDE.md)
   - `--local` 标志用法
   - 手动复制步骤
   - AC 框架快速参考

### 🔍 验证和证明
1. **验证报告**: [refactor-template-validation-report.md](docs/refactor-template-validation-report.md)
   - 92% 覆盖率（AIDM 8 应用）
   - Spec/Plan/Tasks 详细评估
   - 示例 AC 填充

2. **交付总结**: [DELIVERY_SUMMARY.md](docs/DELIVERY_SUMMARY.md)
   - 完整交付清单
   - 文件统计
   - 后续行动

---

## 🔧 关键文件位置

| 文件 | 路径 | 用途 |
|------|------|------|
| **主指南** | docs/TEMPLATE_USAGE_GUIDE.md | ⭐ 开发者必读 |
| **设置指南** | docs/LOCAL_SETUP_GUIDE.md | 快速设置步骤 |
| **验证报告** | docs/refactor-template-validation-report.md | 框架证明 |
| **交付总结** | docs/DELIVERY_SUMMARY.md | 项目完成证书 |
| **Bash 脚本** | scripts/bash/sync-local-templates.sh | 自动同步（Linux/macOS） |
| **PowerShell 脚本** | scripts/powershell/sync-local-templates.ps1 | 自动同步（Windows） |

---

## 🎯 按角色查看

### 👨‍💻 开发者
- **第一步**: 同步模板
  ```bash
  /home/ben/project/umlspec-kit/scripts/bash/sync-local-templates.sh .
  ```
- **第二步**: 阅读 [TEMPLATE_USAGE_GUIDE.md](docs/TEMPLATE_USAGE_GUIDE.md#🚀-快速开始5-分钟)
- **第三步**: 运行三个命令
  ```bash
  specify spec refactor "Description"
  specify plan refactor
  specify tasks refactor
  ```

### 🏗️ 架构师
- **阅读**: [TEMPLATE_USAGE_GUIDE.md §AC-1~AC-4 框架详解](docs/TEMPLATE_USAGE_GUIDE.md#ac-1-用户行为一致性e2e-parity)
- **参考**: [refactor-template-validation-report.md](docs/refactor-template-validation-report.md)
- **验证**: Interface Inventory 设计与 AC 标准

### 🔧 DevOps/SRE
- **使用脚本**: [sync-local-templates.sh](scripts/bash/sync-local-templates.sh)
- **配置环境**: [LOCAL_SETUP_GUIDE.md](docs/LOCAL_SETUP_GUIDE.md)
- **监控 MTTR**: [TEMPLATE_USAGE_GUIDE.md §AC-4](docs/TEMPLATE_USAGE_GUIDE.md#ac-4-无损发布mttr-verified)

### 📊 QA/Testers
- **验收标准**: [TEMPLATE_USAGE_GUIDE.md §验收清单](docs/TEMPLATE_USAGE_GUIDE.md#✅-验收清单)
- **AC 验证**: [TEMPLATE_USAGE_GUIDE.md §AC-1~AC-4 框架详解](docs/TEMPLATE_USAGE_GUIDE.md#📊-ac-1~ac-4-框架详解)
- **测试方法**: [TEMPLATE_USAGE_GUIDE.md §故障排查](docs/TEMPLATE_USAGE_GUIDE.md#🔧-故障排查)

---

## ✅ 我应该做什么？

### 第一次使用本地模板？
1. ✅ 阅读: [快速开始 5 分钟](docs/TEMPLATE_USAGE_GUIDE.md#🚀-快速开始5-分钟)
2. ✅ 运行: 同步脚本
3. ✅ 创建: spec/plan/tasks

### 需要了解框架？
1. ✅ 阅读: [AC-1~AC-4 框架详解](docs/TEMPLATE_USAGE_GUIDE.md#📊-ac-1~ac-4-框架详解)
2. ✅ 查看: [验证报告案例](docs/refactor-template-validation-report.md)
3. ✅ 参考: MTTR 四维度

### 遇到问题？
1. ✅ 查阅: [故障排查](docs/TEMPLATE_USAGE_GUIDE.md#🔧-故障排查)
2. ✅ 检查: [验收清单](docs/TEMPLATE_USAGE_GUIDE.md#✅-验收清单)
3. ✅ 提交: GitHub issue

---

## 🚀 三行命令快速开始

```bash
# 1. 同步模板
/home/ben/project/umlspec-kit/scripts/bash/sync-local-templates.sh .

# 2. 创建三件套
specify spec refactor "Your refactor description"
specify plan refactor && specify tasks refactor

# 3. 打开并编辑
code .specs/spec.refactor.md .plans/plan.refactor.md .tasks/tasks.refactor.md
```

---

## 📊 项目信息

- **版本**: v2.0.0-refactor-acceptance
- **验证**: 92% 覆盖率（AIDM 8 应用项目）
- **文件**: 11 个（~52 KB）
- **状态**: ✅ 生产就绪

**GitHub Release**: 
https://github.com/bigsmartben/umlspec-kit/releases/tag/v2.0.0-refactor-acceptance

---

## 💡 核心概念速记

| 概念 | 含义 | 使用场景 |
|------|------|---------|
| **AC-1** | 用户行为一致性 | E2E 回归测试 |
| **AC-2** | 性能一致性 | 负载测试 vs 基线 |
| **AC-3** | SLA 一致性 | 监控仪表板 |
| **AC-4** | 无损发布 | MTTR 预演 |
| **Interface:Ixx** | 接口标识符 | Plan/Tasks 一致性检查 |
| **MTTR** | 回滚时间 | 风险评估 |

---

**准备好了吗？** 
→ 运行同步脚本，然后按照 [TEMPLATE_USAGE_GUIDE.md](docs/TEMPLATE_USAGE_GUIDE.md) 快速开始！ 🎯
