---

description: "Task list template for data feature implementation"
---

# ⚠️ TEMPLATE MERGED - USE tasks-template.md

**This file is now a pointer to the unified template.**

**Data** 场景的任务拆分已统一到 `templates/tasks-template.md`。

本文件保留仅为兼容性，实际内容请参考：[templates/tasks-template.md](tasks-template.md)

## Data-Specific Notes

生成 data tasks 时，请额外关注：

### Foundational Phase (Phase 2)

确保包含数据专有基础设施：

- [ ] Define input/output data contracts in specs/contracts/
- [ ] Create base schemas or models in src/models/
- [ ] Implement data quality rules framework in src/quality/
- [ ] Document lineage in docs/lineage.md (include diagram)
- [ ] Setup monitoring and alerting for freshness and quality

### Interface Label Format

对于数据场景，接口标识可以是：
- `[dataset:foo_v1]` - 数据契约/数据集
- `[GET/POST /api/path]` - 数据 API 端点
- `[stream:topic_name]` - 流式数据接口

### Interface Task Requirements

每个数据接口任务必须端到端完成：
- Ingestion（数据摄取）
- Transform（数据转换）
- Publish（数据发布）
- Quality checks（质量校验）
- Backfill workflow（回灌流程）
- Monitoring/alerting（监控告警）

### Dependencies

- Data contracts and quality rules must be in place before publishing outputs
- Lineage documentation must be updated when adding new interfaces
