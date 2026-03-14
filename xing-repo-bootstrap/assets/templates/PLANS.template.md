# Planning Mode and Execution Plans

## When to use planning mode
Use an execution plan when:
- The work is a complex new feature or a complex refactor.
- The change is architectural or touches core components.
- The change affects security, payments, privacy, or critical reliability.
- The scope is unclear or risk is high, even if the implementation is short.

## Where plans live
- Store plans under `.agent/plans/`.
- Reference the plan filename in the Codex prompt when executing.

## Commit policy
- Commit plans when they affect architecture or cross-team work.
- Do not commit one-off exploratory plans unless others will reuse them.

## Naming convention
- `.agent/plans/YYYY-MM-DD-HHMM-short-feature.md`

## Execution plan template

### 1) Goal and context
- **Goal:**
- **User impact:**
- **Non-goals:**
- **Constraints:** (time, risk, compatibility, compliance)
- **Dependencies:** (services, teams, libraries)

### 2) Current state
- **Relevant modules/services:**
- **Known pain points:**
- **Links to existing docs/issues:**

### 3) Risks and safety checks
- **Prompt-injection risk:** (sources, inputs, tool usage)
- **Excessive agency risk:** (tools with side effects)
- **Output validation plan:** (tests, linters, reviews)
- **Rollback plan:**

### 4) Proposed approach
- **Design overview:**
- **Data flows:**
- **Compatibility notes:**

### 5) Work breakdown
- [ ] Step 1:
- [ ] Step 2:
- [ ] Step 3:

### 6) Test plan
- **Unit tests:**
- **Integration tests:**
- **Manual checks:**

### 7) Release and rollout
- **Rollout strategy:**
- **Monitoring:**
- **Owner:**

### 8) Open questions
-
