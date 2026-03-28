---
name: spec-kit-init
description: >
  Initialize the current project with GitHub Spec Kit (spec-kit / specify).
  Use this skill when the user asks to initialize, set up, or start using
  spec-kit in a project — e.g. "vamos a usar spec-kit", "inicializa el proyecto
  con spec-kit", "set up spec-kit here", "usa specify en este repo",
  "quiero usar spec-driven development", or any similar request.
---

# Spec Kit Project Initialization

Run the following command from the project root:

```bash
specify init --here --ai codex
```

This initializes spec-kit in the current directory using Codex as the AI assistant.

## Before running

- Confirm the current working directory is the intended project root.
- If the directory is not empty, add `--force` to skip the confirmation prompt:

```bash
specify init --here --ai codex --force
```

## After running

Inform the user that spec-kit has been initialized and they can start working with spec-driven development.
