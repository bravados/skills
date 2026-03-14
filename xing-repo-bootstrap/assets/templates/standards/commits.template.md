# Standard: Commit Structure

## Principles
- Commits should be small, scoped, and reversible.
- The message should explain the change, not just the diff.
- Match repository-specific commit style where possible.
- Keep Codex attribution trailers consistent for reporting.

## Repo-specific rules (detected from this repository)
- Subject format: `<replace based on git history and docs>`
- Ticket prefix policy: `<replace if required>`
- Mood/capitalization/punctuation: `<replace based on detected practice>`
- Line-length expectations: `<replace based on detected practice>`
- Additional local requirements: `<replace from CONTRIBUTING/README/COMMITTING if present>`

## Codex baseline rules (always apply)
- One logical change per commit.
- Include a body that explains what changed and why (especially for non-trivial changes), even if the repo historically has sparse commit bodies.
- Use a blank line between subject and body.
- In the body, explain rationale and noteworthy decisions for complex changes.
- For multiline commit messages, prefer:
  - `git commit -m "<subject>" -m "<full body with real line breaks, paragraphs, and trailers>"`
- Keep the full body (including trailers) in one multiline `-m` argument with actual newlines.
- Do not compose multiline bodies with escaped `\n`.
- Why: known Codex formatting issue can produce literal `\n` when multiline bodies are escaped (`https://github.com/openai/codex/issues/3166`).
- AI-assisted commits from Codex must end with this trailer block (after an empty line):
  - `AI-assisted-by: OpenAI Codex`
  - `Co-authored-by: Codex <199175422+chatgpt-codex-connector[bot]@users.noreply.github.com>`

## Examples (adapt to repository style)
- `<example subject in repo style>`
- `<example subject + body in repo style>`

## Validation
- `git show --stat` should reflect a coherent change set.
- Reviewers should be able to revert a single commit cleanly.
- Codex-authored commits should include meaningful bodies that explain why.
- Codex-authored commits should include the required `AI-assisted-by` and `Co-authored-by` trailers.
- Validate message formatting with `git log -1 --format=%B`:
  - contains real line breaks (no literal `\n`)
  - has a blank line between subject and body
  - has a blank line before attribution trailers
