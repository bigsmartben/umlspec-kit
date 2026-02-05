# Implementation Plan: [FEATURE] (Data)

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan.data` command.

## Summary

[Extract from feature spec: primary requirement + data approach]

## Technical Context

**Language/Version**: [e.g., Python 3.11 or NEEDS CLARIFICATION]  
**Primary Dependencies**: [e.g., Spark, Flink, Airflow or NEEDS CLARIFICATION]  
**Storage**: [e.g., data lake, warehouse, files or N/A]  
**Testing**: [e.g., pytest, dbt test or NEEDS CLARIFICATION]  
**Target Platform**: [e.g., Linux server, cloud service or NEEDS CLARIFICATION]

## Data Mode & SLA

- **Mode**: [real-time, batch, or hybrid]
- **Freshness/Latency**: [target]
- **Volume/Scale**: [records per day, size]

## Interfaces & Contracts

- **Input Contracts**: [schemas, versions, owners]
- **Output Contracts**: [schemas, consumers, SLAs]
- **Change Management**: [compatibility rules]

## Pipeline & Transformations

- **Stages**: [ingest, validate, transform, aggregate, publish]
- **ETL/ELT Strategy**: [where transformations occur]
- **Failure Handling**: [retries, quarantine, alerts]

## Data Quality Plan

- **Rules**: [completeness, accuracy, uniqueness, timeliness]
- **Thresholds**: [target values]
- **Validation Timing**: [pre-ingest, post-transform, pre-publish]

## Lineage & Dependencies

Provide a diagram using PlantUML or Mermaid.

```plantuml
@startuml
' Lineage or pipeline diagram
@enduml
```

```mermaid
flowchart LR
  A[Source] --> B[Transform]
  B --> C[Target]
```

## Interface Implementation *(optional - for API/message-driven scenarios)*

### Query Interfaces

| 接口 | 路径 | 实现组件 | 依赖服务 |
| --- | --- | --- | --- |
| [接口1] | `GET /api/path` | [Controller/Handler] | [数据访问层] |

### Event/Message Consumers

| 消费者 | Topic | 消费策略 | 幂等性设计 |
| --- | --- | --- | --- |
| [Consumer1] | `topic-name` | [同步/异步] | [幂等键设计] |

## Database Migration Plan *(optional - for database-heavy scenarios)*

### 变更执行顺序

1. **DDL变更** (上线前)
   - 新建表: [table_list]
   - 修改表: [table_list]
   - 新增索引: [index_list]

2. **数据迁移** (上线后)
   - 历史数据回填: [策略]
   - 数据校验: [方法]

3. **回滚方案**
   - DDL回滚: [脚本]
   - 数据回滚: [策略]

### 索引验证清单

- [ ] 查询性能测试: [关键查询的执行计划]
- [ ] 索引覆盖率: [是否满足WHERE/JOIN条件]
- [ ] 唯一性约束: [业务唯一键验证]

## Backfill & Replay Strategy

- **Scope**: [time range, partitions]
- **Triggers**: [manual, automated]
- **Idempotency**: [dedupe, reconciliation]

## Monitoring & Alerting

- **Metrics**: [freshness, quality, failure rates]
- **Alerts**: [thresholds and on-call routing]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

[Gates determined based on constitution file]

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
└── tasks.md
```

### Source Code (repository root)

```text
# [REPLACE WITH ACTUAL STRUCTURE]
```

**Structure Decision**: [Document the selected structure and reference the real directories]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
