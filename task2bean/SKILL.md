---
name: task2bean
description: >
  Manage task creation using the `beans` CLI. Use this skill whenever the user asks to
  create tasks, subtasks, split work, break down work, divide tasks, plan tasks, or
  any similar request related to task/work-item management — whether or not the word
  "beans" is explicitly mentioned.
---

# Bean Task Management

## Creating a task

To create a task, run:

```bash
beans create "<description>"
```

### Description format

Every task description MUST include an ordering prefix before the actual description:

```
[<step>/<total_steps>] <short_description>
```

- `<step>`: The step number in the sequence (starting at 1).
- `<total_steps>`: Total number of sequential steps.
- `<short_description>`: A concise, clear sentence describing the purpose of the task.

Tasks that can run **in parallel** share the same step number. Only increment the step number when a task depends on previous ones being completed first.

When creating a **single task**, use `[1/1]`.

### Guidelines

- Always infer a short, actionable description from the user's intent.
- If the user provides a vague request, refine it into a clear task description before running the command.
- When the user asks to **split**, **break down**, or **divide** a piece of work, create one `beans create` call per resulting sub-task.
- Analyze dependencies between tasks to determine which can run in parallel (same step number) and which must be sequential (next step number).

### Examples

User: "Create a task to fix the header alignment"
```bash
beans create "[1/1] Fix header alignment on the dashboard page"
```

User: "Split the authentication work into smaller tasks"
```bash
beans create "[1/2] Implement login endpoint with JWT token generation"
beans create "[1/2] Add password reset flow via email"
beans create "[2/2] Create session expiration and refresh logic"
```
Here, login and password reset are independent (both `[1/2]`), but session refresh depends on them (step `[2/2]`).

User: "Break down the deployment pipeline"
```bash
beans create "[1/3] Write Dockerfile for the API service"
beans create "[1/3] Configure CI lint and test stages"
beans create "[2/3] Build and push Docker image in CI"
beans create "[3/3] Add automatic deployment to staging environment"
```

User: "I need a subtask for writing tests"
```bash
beans create "[1/1] Write unit tests for the payment processing module"
```
