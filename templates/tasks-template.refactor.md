---

description: "Task list template for refactor feature implementation"
---

# ⚠️ TEMPLATE MERGED - USE tasks-template.md

**This file is now a pointer to the unified template.**

**Refactor** 场景的任务拆分已统一到 `templates/tasks-template.md`。

本文件保留仅为兼容性，实际内容请参考：[templates/tasks-template.md](tasks-template.md)

## Refactor-Specific Notes

生成 refactor tasks 时，请额外关注：

### Required Artifacts (create early in Phase 1)

- `specs/[###-feature-name]/baseline.md`: baseline behaviors + measurements + golden examples
- `specs/[###-feature-name]/impact-map.md`: evidence-backed scope/impact map (symbols/usages/contracts)
- `specs/[###-feature-name]/migration.md`: phased migration + rollout + rollback

### HARD CONSISTENCY CONTRACT (Spec → Plan → Tasks)

1. **Single source of truth**: plan.md "Interface Inventory" is the authoritative list of `Ixx`.
2. **1:1 mapping**: For every `Ixx` in plan.md, tasks.md MUST contain **exactly one** delivery task.
3. **Required tag**: The delivery task line MUST include the exact token `Interface:Ixx` (e.g., `Interface:I01`).
4. **No extras**: tasks.md MUST NOT contain `Interface:Ixx` tokens that do not exist in plan.md.

### Interface Inventory (fill before Phase 3)

| Interface ID | Type | Method/Path (or name) | User Story |
|-------------|------|------------------------|------------|
| I01 | HTTP | [GET /v1/foo] | [US1] |
| I02 | WebSocket | [WS msg: FooUpdated] | [US2] |

### Definition of Done for Interface Tasks

- **AC-1 (Behavior)**: Parity validated against baseline.md
- **AC-2 (Performance)**: No latency/throughput regression vs baseline
- **AC-4 (Lossless)**: Rollback path confirmed per migration.md
- Contract compatibility verified (or contract updated with explicit approval)
- Observability checks updated if applicable
