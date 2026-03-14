# Repository Guidelines

## Purpose
Briefly introduce the repo and point Codex to the deeper `.agent/` docs for details. Keep this file concise (200-400 words).

## Project overview
- What this repo does: `<one-sentence summary>`
- Key components: `<2-4 bullets with component names>`
- Critical flows: `<1-2 bullets>`
  - Details: see `.agent/ARCHITECTURE.md`.

## Safety and boundaries
- Never modify production data or run destructive commands without explicit approval.
- Do not add dependencies, migrations, or infra changes without confirmation.
- Avoid handling secrets; request input via secure channels.

## Project Structure & Module Organization
- Source code: `<path>` (details: `.agent/ARCHITECTURE.md`)
- Tests: `<path>` (details: `.agent/TESTING.md`)
- Configuration: `<path>`
- CI/CD: `<path>`

## Build, Test, and Development Commands
- Build: `<command>` (details: `.agent/SETUP.md`)
- Test: `<command>` (details: `.agent/TESTING.md`)
- Lint: `<command>` (details: `.agent/TESTING.md`)
- Docs index: `.agent/README.md`

## Coding Style & Naming Conventions
- Style/lint tools: `<tool>` (details: `.agent/CODING_STYLE.md`)
- Naming patterns: `<pattern>`
- Formatting rules not covered by tools: `.agent/CODING_STYLE.md`

## Testing Guidelines
- Test framework: `<framework>` (details: `.agent/TESTING.md`)
- How to run: `.agent/TESTING.md`
- Coverage expectations: `<notes>`

## Commit & Pull Request Guidelines
- Commit conventions: see `.agent/standards/commits.md`
- PR expectations: `<linked issues, description, screenshots, etc.>`

## Review expectations
- Run relevant tests for touched areas.
- Summarize changes and provide verification steps.
- Call out risk areas explicitly.

## Planning trigger
- Use a plan for complex new features, complex refactors, or high-risk changes.
- If you think you might need a plan, read `.agent/PLANS.md` for structure, storage, and commit policy.

## Deeper docs
- `.agent/README.md` — index of all agent docs
- `.agent/SETUP.md` — local setup and environment
- `.agent/TESTING.md` — test commands and expectations
- `.agent/CODING_STYLE.md` — style rules not enforced by tools
- `.agent/ARCHITECTURE.md` — system boundaries and data flow
- `.agent/GLOSSARY.md` — company terms, acronyms, and internal lingo

## Standards
- Load standards from `.agent/standards/index.yml` based on the task.

## Maintenance
- After large changes, review `AGENTS.md` and all `.agent/` docs (including standards) to keep them current.
- If updates seem necessary, ask the user whether to update these docs as part of the change.
