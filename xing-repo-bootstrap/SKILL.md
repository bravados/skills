---
name: xing-repo-bootstrap
description: Bootstrap an existing repo with XING Codex agentic coding files, standards, and cross-links (AGENTS.md, .agent/*), then guide review and commit.
---

# XING Repo Bootstrap Skill

Use this skill when onboarding Codex to an existing repository. It creates the file structure from XING recommended practices, fills the files with repo-specific context, detects applicable standards, and guides a review loop before committing.

## Inputs to confirm
- Repository root path (default: current working directory)
- Whether to update existing files or create new ones
- Commit message (default: "docs: add agentic coding setup")

## Outputs
- `AGENTS.md`
- `.agent/README.md`
- `.agent/PLANS.md`
- `.agent/SETUP.md`
- `.agent/TESTING.md`
- `.agent/CODING_STYLE.md`
- `.agent/ARCHITECTURE.md`
- `.agent/GLOSSARY.md`
- `.agent/standards/README.md`
- `.agent/standards/index.yml`
- `.agent/standards/*.md` (only for standards detected in the repo)
- Optional: `.agent/specs/` and `.agent/product/` folders (if recommended by the team)

## Workflow

### 1) Create a TODO list
- List all steps and confirm scope with the user.

### 2) Analyze the repository
- Read top-level docs: `README.md`, `CONTRIBUTING.md`, `CODEOWNERS`, `docs/`.
- Scan other top-level Markdown files when relevant (for example, release/process docs, runbooks, architecture notes).
- Follow links from the initially scanned docs and read linked files when they are relevant to setup, standards, testing, architecture, or commit conventions.
- Search for commit guidance in `CONTRIBUTING.md`, `COMMITTING.md`, `COMMIT_MESSAGE.md`, and `docs/*commit*`.
- Identify build/test/lint commands and CI.
- Determine languages/frameworks and dependency managers.
- Analyze source tree patterns to infer likely standards (controllers, testing framework, test data/factories, services, consumers, naming/structure).
- Detect existing standards (commit conventions and body practices, markdown style, testing practices, logging/error handling).
- Detect likely company acronyms/internal terms from docs/code and infer definitions when possible.
- Also detect non-acronym internal names (for example product or platform names such as "Juicer" or "New Work One") and include them in the glossary when relevant.
- Use `scripts/analyze_repo.sh` to generate a quick evidence report if helpful.
- If `CLAUDE.md` exists, read it fully and plan how to migrate its content into `AGENTS.md` and `.agent/` docs.
- If a `.claude/` folder exists, review files and plan how to migrate relevant guidance into the new structure.
- If an existing `AGENTS.md` exists, read it fully and plan how to merge or reorganize its content into the new structure.

### 3) Draft the file structure
- Create missing files using templates from `assets/templates/`.
- Do not overwrite existing files without explicit approval.
- Keep files short and tailored; avoid dumping large README content.
- For `CLAUDE.md`, extract relevant guidance and place it in the appropriate new files, then remove `CLAUDE.md`.
- For `.claude/`, extract relevant guidance into the new files, then remove the `.claude/` folder.
- For an existing `AGENTS.md`, overwrite it with the standardized structure after merging relevant content.

### 4) Fill files with repo-specific info
- `AGENTS.md` should link to all `.agent/` docs and relevant standards.
- `AGENTS.md` must include a concise repo structure overview (source, tests, configs, CI).
- `.agent/SETUP.md` and `.agent/TESTING.md` must include real commands.
- `.agent/CODING_STYLE.md` should focus on rules not enforced by formatters.
- `.agent/ARCHITECTURE.md` should summarize boundaries and data flow in 5-10 bullets.
- `.agent/GLOSSARY.md` should include detected company terms/acronyms and non-acronym internal names; infer definitions from docs when possible, otherwise flag as missing definition.
- Keep `AGENTS.md` brief and non-duplicative; each section should point to the relevant `.agent/` file for details.
- Put the product/repo summary and key components in `AGENTS.md`; keep `.agent/ARCHITECTURE.md` focused on structure and flow.
- In `AGENTS.md`, include the planning trigger and point to `.agent/PLANS.md` for structure, storage, and commit policy.
- In `.agent/TESTING.md`, emphasize test importance, TDD when feasible, and separate testing vs. implementation phases.
- Move linting commands to `.agent/CODING_STYLE.md` and reference them from `AGENTS.md`.

### 5) Detect standards and create only what applies
- Create a standard only if there is evidence in the repo (config files, docs, code patterns, commit history).
- Use source-code evidence, not only docs, to infer standards that Codex should follow in this repo.
- Candidate areas to detect from repo evidence include:
  - Naming conventions (variables, functions/methods, classes/modules/types, files/directories).
  - Code organization (where business logic lives, layering rules, responsibilities by folder).
  - API/service structure (controller/handler patterns, request/response conventions, validation).
  - Testing setup (frameworks, test layout, naming patterns, fixtures/factories/test data creation).
  - Error handling and logging conventions (patterns for propagation, retries, observability).
  - Data access patterns (ORM/query style, migrations, transaction boundaries).
  - Event/queue/message processing patterns (consumer/producer structure, idempotency, DLQ/retry behavior).
  - Security-sensitive conventions (authn/authz usage, secret handling, input sanitization).
  - Documentation/PR conventions that materially affect implementation workflow.
- Focus on what seems special or important in this repo, not generic language/framework defaults.
- Update `.agent/standards/index.yml` to include only created standards.
- Use templates in `assets/templates/standards/` for initial drafts.
- Copy `assets/templates/standards/README.template.md` directly to `.agent/standards/README.md`.
- For commit standards, copy `assets/templates/standards/commits.template.md` to `.agent/standards/commits.md` and fill all repo-specific placeholders.
- For commit standards, incorporate guidance from commit bodies and any commit policy docs.
- For commit standards, replace repo-style placeholders with detected conventions from history/docs; do not keep generic defaults.
- Even if historical commits lack bodies, require Codex commits to include a meaningful body that explains why.
- Always add the Codex attribution trailers in commit standards, separated by a blank line from the main body:
  - `AI-assisted-by: OpenAI Codex`
  - `Co-authored-by: Codex <199175422+chatgpt-codex-connector[bot]@users.noreply.github.com>`
- When evidence exists, generate additional standards for framework/testing/architecture patterns based on what the repository actually uses.

### 6) Review glossary and resolve unknown terms
- Review `.agent/GLOSSARY.md` for missing or ambiguous definitions.
- For terms without clear definitions in docs, ask the user for definitions.
- Record confirmed definitions in `.agent/GLOSSARY.md` and keep unresolved items clearly marked.

### 7) Cross-link and validate discovery
- Ensure `AGENTS.md` points to `.agent/README.md` and the core docs.
- Ensure `.agent/README.md` points to all other `.agent/` docs.
- Use relative paths and keep links short.
- Confirm that any guidance from `CLAUDE.md` or a previous `AGENTS.md` is preserved in the new structure.

### 8) Review loop
- Ask the user to review each file for correctness.
- Iterate until the user confirms.

### 9) Commit
- Before creating the commit, re-read `AGENTS.md` and `.agent/standards/commits.md` from disk to apply the freshly generated conventions in the same session.
- If the generated commit standard differs from the current commit format, follow the generated repo-specific standard for this commit.
- Stage all created/updated files.
- Make a single commit with the agreed message, body, and required trailers.

## References
- `assets/templates/`
