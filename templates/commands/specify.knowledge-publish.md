---
description: Create or update the feature specification for knowledge publishing scenarios (教研知识发布场景).
handoffs: 
  - label: Build Technical Plan
    agent: speckit.plan
    prompt: Create a plan for the spec. I am building with...
  - label: Clarify Spec Requirements
    agent: speckit.clarify
    prompt: Clarify specification requirements
    send: true
scripts:
  sh: scripts/bash/create-new-feature.sh --json --template knowledge-publish "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 -Json -Template knowledge-publish "{ARGS}"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

The text the user typed after `/speckit.specify-knowledge-publish` in the triggering message **is** the feature description. Assume you always have it available in this conversation even if `{ARGS}` appears literally below. Do not ask the user to repeat it unless they provided an empty command.

Given that feature description, do this:

1. **Generate a concise short name** (2-4 words) for the branch:
   - Analyze the feature description and extract the most meaningful keywords
   - Create a 2-4 word short name that captures the essence of the feature
   - Use action-noun format when possible (e.g., "add-question-publish", "fix-content-template")
   - Preserve technical terms and acronyms (ES, MySQL, Dubbo, HTTP, etc.)
   - Keep it concise but descriptive enough to understand the feature at a glance
   - Examples:
     - "对计算专项场景提供竖式排版内容格式支持" → "vertical-layout-support"
     - "新增教学类目查询接口" → "teach-type-query-api"
     - "题目发布添加contentTemplate字段" → "add-content-template"

2. **Check for existing branches before creating new one**:

   a. First, fetch all remote branches to ensure we have the latest information:

      ```bash
      git fetch --all --prune
      ```

   b. Find the highest feature number across all sources for the short-name:
      - Remote branches: `git ls-remote --heads origin | grep -E 'refs/heads/[0-9]+-<short-name>$'`
      - Local branches: `git branch | grep -E '^[* ]*[0-9]+-<short-name>$'`
      - Specs directories: Check for directories matching `specs/[0-9]+-<short-name>`

   c. Determine the next available number:
      - Extract all numbers from all three sources
      - Find the highest number N
      - Use N+1 for the new branch number

   d. Run the script `{SCRIPT}` with the calculated number, short-name, and template flag:
      - Pass `--number N+1`, `--short-name "your-short-name"`, and `--template knowledge-publish` along with the feature description
      - Bash example: `{SCRIPT} --json --number 5 --short-name "vertical-layout" --template knowledge-publish "添加竖式排版支持"`
      - PowerShell example: `{SCRIPT} -Json -Number 5 -ShortName "vertical-layout" -Template knowledge-publish "添加竖式排版支持"`

   **IMPORTANT**:
   - Check all three sources (remote branches, local branches, specs directories) to find the highest number
   - Only match branches/directories with the exact short-name pattern
   - If no existing branches/directories found with this short-name, start with number 1
   - You must only ever run this script once per feature
   - The JSON is provided in the terminal as output - always refer to it to get the actual content you're looking for
   - The JSON output will contain BRANCH_NAME and SPEC_FILE paths
   - For single quotes in args, use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot")

3. Load `templates/spec-template.knowledge-publish.md` to understand required sections.

4. Follow this execution flow:

    1. Parse user description from Input
       If empty: ERROR "No feature description provided"
    2. Extract key concepts from description
    3. Run branch creation script with `--template knowledge-publish` flag
    4. Switch to new branch
    5. Read template: `templates/spec-template.knowledge-publish.md`
    6. Fill in all required sections:
       - User Scenarios & Testing (用户场景与测试)
       - 需求输入（来自业务方）
       - 技术方案 (including 架构设计, 数据模型设计)
       - 接口设计 (including 时序图, 改动分析, 性能设计, 改动清单, 验证路径)
       - 风险评估
       - 上线计划
       - 依赖方沟通
       - 监控与告警
    7. Create well-structured spec with:
       - Clear mermaid diagrams for architecture and sequences
       - Detailed table structures for data models
       - Comprehensive interface definitions
       - Risk assessment and mitigation strategies
    8. Write complete spec to file
    9. Present summary with file location and next steps

## Critical Rules for Knowledge Publishing Specs

1. **架构图必须包含**：
   - MySQL 表结构层
   - ES 索引层
   - 表间关系与数据流
   - 用颜色区分新旧模型（蓝色=现有，红色=新增）

2. **数据模型必须详细**：
   - 完整的字段定义表
   - 字段类型、含义、备注
   - 标注责任人（使用 $\color{#0089FF}{@负责人}$ 格式）

3. **接口设计必须包含**：
   - 时序图（sequenceDiagram）
   - 改动分析（影响评估表）
   - 性能设计（RT目标）
   - 改动清单（具体文件和代码位置）
   - 验证路径（明确的验证步骤）

4. **表格格式规范**：
   - 使用 Markdown 表格
   - 包含表头分隔线
   - 对齐方式统一

5. **责任人标注**：
   - 使用 $\color{#0089FF}{@姓名}$ 格式
   - 在关键改动点都要标注

6. **接口类型说明**：
   - Dubbo 接口：明确 Facade 和方法签名
   - HTTP 接口：明确 path 和 method
   - 入参/出参都要有 Schema 示例

## Template Structure

The knowledge publishing spec template includes these key sections:

### Required Sections (mandatory)
- **User Scenarios & Testing**: Prioritized user stories with acceptance criteria
- **需求输入**: Business requirements input with key points
- **技术方案**: Technical solution overview with architecture diagrams
- **数据模型设计**: Detailed database/index schema design
- **接口设计**: Complete interface definitions with sequences
- **风险评估**: Risk assessment and mitigation
- **上线计划**: Deployment plan with checklist
- **依赖方沟通**: Upstream/downstream communication
- **监控与告警**: Monitoring and alerting configuration

### Optional Sections
- **发布规则**: Publishing validation rules
- **数据流转**: Data flow diagrams
- **附录**: Related documents and glossary

## Execution Steps

1. **Create feature branch and spec file**
   - Run the script with `--template knowledge-publish` flag
   - Parse JSON output for paths

2. **Fill in business context**
   - 需求输入 section with date, scope, source
   - Extract key requirements from user description

3. **Design technical solution**
   - Create architecture diagram with mermaid
   - Design data models with detailed tables
   - Plan interface changes

4. **Document interfaces thoroughly**
   - For each interface:
     - Write sequence diagram
     - Analyze impact on existing systems
     - Design performance targets
     - List specific code changes
     - Define verification steps

5. **Complete risk and deployment planning**
   - Identify technical and compatibility risks
   - Create deployment checklist
   - Plan monitoring and alerts

6. **Write complete spec**
   - Use all template sections
   - Replace all placeholders
   - Ensure diagrams render correctly
   - Verify table formatting

7. **Present to user**
   - File location
   - Key sections summary
   - Next recommended steps

## Example Usage Pattern

**User says**: "新增教学类目批量查询接口，支持根据章节ID批量查询类目和PT信息"

**You should**:
1. Extract short-name: "teach-type-batch-query"
2. Check for existing branches with this name
3. Run script: `{SCRIPT} --json --number 6 --short-name "teach-type-batch-query" --template knowledge-publish "新增教学类目批量查询接口"`
4. Create spec with:
   - User story: 批量查询减少网络开销
   - 技术方案: hub侧新增Dubbo接口
   - 接口设计: queryTeachTypeByChapterIds with sequence diagram
   - 数据模型: TeachTypeChapterDTO with ptId field
   - 性能设计: 批量限制100条，RT < 50ms
5. Write to specs/{number}-teach-type-batch-query/SPEC.md

## Important Notes

- **Always use the knowledge-publish template** for education/research/publishing domain features
- **Include Chinese descriptions** where appropriate (this domain is Chinese-language focused)
- **Be thorough with diagrams** - they are critical for understanding complex data flows
- **Mark all stakeholders** using the colored @mention format
- **Performance targets are mandatory** for all interfaces
- **Verification paths must be actionable** - specific steps, not vague descriptions

Let's build a comprehensive knowledge publishing specification!
