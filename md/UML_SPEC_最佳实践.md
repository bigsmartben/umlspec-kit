# SDD × AI Agent 执行框架白皮书（Copilot Execution Edition）

## 0. 版本声明

- 本版本基于 **GitHub Copilot 作为唯一执行 Agent**
- **Cline 已被完全移除**，不再作为 Execution Zone 的组成部分
- 本白皮书面向 **AI Agent / AI 平台 / 自动化系统** 作为理解与执行依据

---

## 1. 核心结论（Executive Summary）

> **AI 不再被视为“自主 Agent”，而是被约束为“协议执行器”。**

SDD（Spec‑Driven Development）通过**双分区 + 执行协议**的方式，将 AI Coding 从“生成式不确定行为”转化为“可审计、可验证、可替换的工程执行行为”。

在本架构中：

- **GitHub Copilot = 执行引擎（Mutation Executor）**
- **IDEA Index = 唯一语义权威（Semantic Authority）**
- **speckit IMP = 不可替换的执行协议（Execution Contract）**

---

## 2. 总体架构：双分区执行模型（Two‑Zone Execution Model）

```
┌──────────────────────────────────────────────────────────┐
│                        L1 / L2                           │
│        Spec · Plan · Task（SDD 规范层 & 推理层）           │
└───────────────────────────┬──────────────────────────────┘
                            │ Task DSL
                            ▼
┌──────────────────────────────────────────────────────────┐
│        分区 A：IDEA Index Authority Zone（只读）           │
│----------------------------------------------------------│
│  • PSI / AST / Symbol Resolution                         │
│  • Call Hierarchy / Usage / Refactor Graph               │
│  • Impact Analysis                                       │
│                                                          │
│  输出：Index Projection（确定性 JSON，不可变）            │
└───────────────────────────┬──────────────────────────────┘
                            │ Projection
                            ▼
┌──────────────────────────────────────────────────────────┐
│        分区 B：Copilot Execution Zone（可写）              │
│----------------------------------------------------------│
│  • GitHub Copilot Chat / Inline                          │
│  • speckit IMP 执行协议                                  │
│  • 人类监督下的确定性执行                                │
│                                                          │
│  输入：Projection + IMP                                  │
│  输出：代码变更                                          │
└──────────────────────────────────────────────────────────┘
```

---

## 3. 两个分区的职责与不可逾越边界

### 3.1 IDEA Index Authority Zone

> **唯一语义权威（Single Semantic Authority）**

**职责：**
- 确定 Task 对应的真实代码位置
- 计算调用链与影响范围
- 输出可验证的 Index Projection

**禁止：**
- 写代码
- 执行 IMP
- 与 Copilot 直接耦合

---

### 3.2 Copilot Execution Zone

> **唯一变更执行者（Single Mutation Executor）**

**职责：**
- 严格按照 Projection 定位修改目标
- 严格按照 speckit IMP 步骤执行
- 不引入 Projection 之外的变更

**禁止：**
- 自主发现文件
- 自主推断调用关系
- 扩散修改范围

> ⚠️ Copilot 被视为“受控执行器”，而非“自主 Agent”。

---

## 4. speckit IMP 的重新定义（在 Copilot 场景下）

```
Spec / Plan / Task
        ↓
   speckit IMP（执行协议）
        ↓
Index Projection（IDEA 生成）
        ↓
GitHub Copilot（受控执行）
```

**IMP 在本架构中的职责：**

- 定义执行步骤顺序
- 定义不变量（Invariant）
- 定义校验点（Checkpoints）
- 定义失败处理策略（Fail‑Fast / 回滚）

> IMP 描述“如何执行”，而不是“由谁执行”。

---

## 5. 为什么 Copilot 现在是可行的执行器

在本架构下，Copilot 的不足被系统性抵消：

| Copilot 原始缺陷 | SDD 中的解决方式 |
|----------------|-----------------|
| 无索引能力 | 完全依赖 Index Projection |
| 易扩散修改 | IMP + 人类确认 |
| 无多步状态 | IMP 显式阶段化 |
| 无回滚 | Git / Patch 级控制 |

结论：

> **当 Copilot 不再“思考结构”，它就足够可靠。**

---

## 6. 对 AI 的输入规范（给 AI / Agent 阅读）

任何 AI 在本体系中，必须遵守以下前提：

1. Index Projection 被视为**事实**，不可质疑
2. 未在 Projection 中声明的代码，**禁止修改**
3. IMP 步骤必须逐条完成，不允许合并或跳过
4. 若发现 Projection 不足，应中止执行并反馈

---

## 7. 架构可替换性声明

- IDE 可替换（IDEA / Eclipse / 其他）
- 执行器可替换（Copilot / 未来 Agent）
- **协议不可替换（Spec / Task / Projection / IMP）**

---

## 8. 面向 AI 的最终声明（System‑Level Quote）

> **你不是被授权理解代码结构的智能体。**  
> **你只被授权执行已经被证明正确的结构变更。**

