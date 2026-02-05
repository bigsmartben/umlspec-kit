# Changelog

<!-- markdownlint-disable MD024 -->

All notable changes to the Specify CLI and templates are documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-02-05

### Added

- **Unified Task System**: Merged `tasks.md`, `tasks.refactor.md`, and `tasks.data.md` into a single authoritative template.
- **Interface Granularity Principle**: Enforced "one interface per task" rule across all task templates and plan handoffs.
- **Technical Review Structure**: Enhanced `spec-template.md` with structured sections for architecture, data models, and UML diagrams.
- **Architecture Sections**: Added technical context and system architecture sections to `plan-template.md`.

### Changed

- Updated all sync scripts (bash/powershell) to reflect the simplified template structure.
- Updated documentation and VS Code settings for the unified workflow.

## [0.1.8] - 2026-02-05

### Fixed

- Fixed template copying to include all variant files (data, refactor) in release packages.

## [0.1.6] - 2026-02-05

### Added

- Added `--local` flag to `specify init` for development, allowing bootstrapping from local templates and scripts.
- Robust AI assistant name handling with alias support (e.g., `colipot` -> `copilot`) and fuzzy matching suggestions.

## [0.1.5] - 2026-02-05

### Changed

- Release v0.1.5.

## [0.1.4] - 2026-02-05

### Fixed

- Ensure `.github/copilot-instructions.md` is correctly copied to release packages.
- Update agent context scripts to use the root `.github/copilot-instructions.md` path for Copilot.

## [0.1.3] - 2026-02-05

### Added

- Improved GitHub Copilot support with proper `mode` metadata for Chat Mode commands.
- Configured Copilot agent files to be stored in `.github/agents/`.

## [0.0.22] - 2025-11-07

### Added

- Support for VS Code/Copilot agents, and moving away from prompts to proper agents with hand-offs.
- Move to use `AGENTS.md` for Copilot workloads, since it's already supported out-of-the-box.
- Adds support for the version command. ([#486](https://github.com/github/spec-kit/issues/486))
- Fixes potential bug with the `create-new-feature.ps1` script that ignores existing feature branches when determining next feature number ([#975](https://github.com/github/spec-kit/issues/975))
- Add graceful fallback and logging for GitHub API rate-limiting during template fetch ([#970](https://github.com/github/spec-kit/issues/970))

## [0.0.21] - 2025-10-21

### Added

- Fixes [#975](https://github.com/github/spec-kit/issues/975) (thank you [@fgalarraga](https://github.com/fgalarraga)).
- Adds support for Amp CLI.
- Adds support for VS Code hand-offs and moves prompts to be full-fledged chat modes.
- Adds support for `version` command (addresses [#811](https://github.com/github/spec-kit/issues/811) and [#486](https://github.com/github/spec-kit/issues/486), thank you [@mcasalaina](https://github.com/mcasalaina) and [@dentity007](https://github.com/dentity007)).
- Adds support for rendering the rate limit errors from the CLI when encountered ([#970](https://github.com/github/spec-kit/issues/970), thank you [@psmman](https://github.com/psmman)).

## [0.0.20] - 2025-10-14

### Added

- **Intelligent Branch Naming**: `create-new-feature` scripts now support `--short-name` parameter for custom branch names
  - When `--short-name` provided: Uses the custom name directly (cleaned and formatted)
  - When omitted: Automatically generates meaningful names using stop word filtering and length-based filtering
  - Filters out common stop words (I, want, to, the, for, etc.)
  - Removes words shorter than 3 characters (unless they're uppercase acronyms)
  - Takes 3-4 most meaningful words from the description
  - **Enforces GitHub's 244-byte branch name limit** with automatic truncation and warnings
  - Examples:
    - "I want to create user authentication" → `001-create-user-authentication`
    - "Implement OAuth2 integration for API" → `001-implement-oauth2-integration-api`
    - "Fix payment processing bug" → `001-fix-payment-processing`
    - Very long descriptions are automatically truncated at word boundaries to stay within limits
  - Designed for AI agents to provide semantic short names while maintaining standalone usability

### Changed

- Updated `check-prerequisites` scripts to provide clearer guidance on missing tools.
- Refined template structures for better AI readability.

## [0.0.19] - 2025-10-01

### Fixed

- Bug in template path resolution for Windows environments.
- Corrected logic in `update-agent-context` when multiple agents exist.
