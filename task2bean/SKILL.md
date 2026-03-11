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
beans create "<short_description>"
```

- `<short_description>`: A concise, clear sentence describing the purpose of the task (e.g. `"Add input validation to the login form"`).

### Guidelines

- Always infer a short, actionable description from the user's intent.
- If the user provides a vague request, refine it into a clear task description before running the command.
- When the user asks to **split**, **break down**, or **divide** a piece of work, create one `beans create` call per resulting sub-task.

### Examples

User: "Create a task to fix the header alignment"
```bash
beans create "Fix header alignment on the dashboard page"
```

User: "Split the authentication work into smaller tasks"
```bash
beans create "Implement login endpoint with JWT token generation"
beans create "Add password reset flow via email"
beans create "Create session expiration and refresh logic"
```

User: "I need a subtask for writing tests"
```bash
beans create "Write unit tests for the payment processing module"
```
