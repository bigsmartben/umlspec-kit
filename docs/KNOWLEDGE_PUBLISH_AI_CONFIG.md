# 教研知识发布模板 - AI 助手配置示例

本文档展示如何在不同的 AI 助手中配置"教研知识发布"自定义命令。

## GitHub Copilot

在 `.github/agents/` 目录下创建命令文件：

**文件**: `.github/agents/specify.knowledge-publish.md`

```markdown
---
description: Create or update the feature specification for knowledge publishing scenarios (教研知识发布场景).
mode: speckit.specify-knowledge-publish
---

{命令文件内容参考 templates/commands/specify.knowledge-publish.md}
```

## Claude Code

在 `.claude/commands/` 目录下创建命令文件：

**文件**: `.claude/commands/specify-knowledge-publish.md`

```markdown
---
description: Create or update the feature specification for knowledge publishing scenarios (教研知识发布场景).
---

{命令文件内容参考 templates/commands/specify.knowledge-publish.md}
```

## Windsurf

在 `.windsurf/workflows/` 目录下创建工作流文件：

**文件**: `.windsurf/workflows/specify-knowledge-publish.md`

```markdown
---
description: Create or update the feature specification for knowledge publishing scenarios (教研知识发布场景).
---

{命令文件内容参考 templates/commands/specify.knowledge-publish.md}
```

## Cursor

在 `.cursor/commands/` 目录下创建命令文件：

**文件**: `.cursor/commands/specify-knowledge-publish.md`

```markdown
---
description: Create or update the feature specification for knowledge publishing scenarios (教研知识发布场景).
---

{命令文件内容参考 templates/commands/specify.knowledge-publish.md}
```

## 通用配置注意事项

### 1. 脚本路径配置

确保在命令文件的 `scripts` 部分正确配置路径：

```yaml
scripts:
  sh: scripts/bash/create-new-feature.sh --json --template knowledge-publish "{ARGS}"
  ps: scripts/powershell/create-new-feature.ps1 -Json -Template knowledge-publish "{ARGS}"
```

### 2. 参数占位符

不同 AI 助手使用不同的参数占位符：

- **标准格式**: `$ARGUMENTS` 或 `{ARGS}`
- **TOML 格式** (Gemini, Qwen): `{{args}}`
- **脚本替换**: `{SCRIPT}` 会被替换为实际脚本路径

### 3. 命令调用方式

配置完成后，用户可以通过以下方式调用：

```bash
# GitHub Copilot
/speckit.specify-knowledge-publish 添加竖式排版支持

# Claude Code
/specify-knowledge-publish 添加竖式排版支持

# Cursor
/specify-knowledge-publish 添加竖式排版支持

# Windsurf (在工作流面板中选择)
```

## 自动化配置脚本

如果您使用 Specify CLI 初始化项目，可以通过以下方式自动配置：

### 使用 Specify CLI 初始化（推荐）

```bash
# 使用 GitHub Copilot
specify init --ai copilot

# 使用 Claude Code
specify init --ai claude

# 使用 Cursor
specify init --ai cursor-agent

# 使用 Windsurf
specify init --ai windsurf
```

### 手动同步模板

如果已经初始化过，可以手动同步模板：

```bash
# Bash
./scripts/bash/sync-local-templates.sh

# PowerShell
./scripts/powershell/sync-local-templates.ps1
```

这会将 `templates/commands/` 下的所有命令文件同步到对应的 AI 助手目录。

## 验证配置

配置完成后，验证步骤：

1. **检查文件是否存在**
   ```bash
   # 根据您使用的 AI 助手检查对应路径
   ls -la .github/agents/specify.knowledge-publish.md
   # 或
   ls -la .claude/commands/specify-knowledge-publish.md
   ```

2. **测试命令调用**
   在 AI 助手中输入命令，检查是否能正确识别：
   ```
   /speckit.specify-knowledge-publish test
   ```

3. **检查脚本执行**
   确保脚本可以正确执行：
   ```bash
   # 测试 bash 脚本
   ./scripts/bash/create-new-feature.sh --json --template knowledge-publish "test feature"
   
   # 测试 PowerShell 脚本
   ./scripts/powershell/create-new-feature.ps1 -Json -Template knowledge-publish "test feature"
   ```

## 故障排查

### 问题1：命令不被识别

**原因**：命令文件格式或位置不正确

**解决方案**：
- 检查文件名和路径是否符合 AI 助手的要求
- 确保 YAML front matter 格式正确
- 重启 AI 助手或 IDE

### 问题2：模板文件未找到

**原因**：脚本中的模板路径不正确

**解决方案**：
- 确认 `templates/spec-template.knowledge-publish.md` 文件存在
- 检查脚本中的模板路径配置
- 查看脚本执行时的错误日志

### 问题3：参数传递失败

**原因**：参数占位符格式不匹配

**解决方案**：
- 检查 `{ARGS}` 或 `$ARGUMENTS` 的使用是否正确
- 确认脚本参数解析逻辑
- 查看命令文件中的 scripts 配置

## 扩展：创建更多自定义模板

您可以按照相同的模式创建更多自定义模板：

1. **创建模板文件**
   ```bash
   cp templates/spec-template.md templates/spec-template.my-custom.md
   ```

2. **创建命令文件**
   ```bash
   cp templates/commands/specify.md templates/commands/specify.my-custom.md
   ```

3. **更新命令文件中的脚本调用**
   ```yaml
   scripts:
     sh: scripts/bash/create-new-feature.sh --json --template my-custom "{ARGS}"
     ps: scripts/powershell/create-new-feature.ps1 -Json -Template my-custom "{ARGS}"
   ```

4. **同步到 AI 助手目录**
   ```bash
   ./scripts/bash/sync-local-templates.sh
   ```

---

**相关文档**：
- [教研知识发布模板使用指南](./KNOWLEDGE_PUBLISH_TEMPLATE.md)
- [Spec Kit 主文档](../README.md)
- [AI 代理集成指南](../AGENTS.md)
