#!/usr/bin/env bash
set -euo pipefail

root="${1:-.}"
output="${2:-}"

if [[ ! -d "$root" ]]; then
  echo "Root not found: $root" >&2
  exit 1
fi

cd "$root"

write() {
  if [[ -n "$output" ]]; then
    printf "%s\n" "$1" >> "$output"
  else
    printf "%s\n" "$1"
  fi
}

if [[ -n "$output" ]]; then
  : > "$output"
fi

write "# Repo Analysis"
write ""

write "## Git"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
  write "- Branch: $branch"
  write "- Status:"
  git status -sb | sed 's/^/  - /' | while read -r line; do write "$line"; done
else
  write "- Not a git repository."
fi
write ""

write "## Docs"
for f in README.md CONTRIBUTING.md CODEOWNERS docs/README.md COMMITTING.md COMMIT_MESSAGE.md; do
  if [[ -e "$f" ]]; then
    write "- $f"
  fi
done
commit_docs=$(rg --files -g 'docs/*commit*.md' -g 'docs/*commit*.txt' 2>/dev/null || true)
if [[ -n "$commit_docs" ]]; then
  while read -r line; do
    write "- $line"
  done <<< "$commit_docs"
fi
write ""

write "## Tooling Files"
for f in package.json pnpm-lock.yaml yarn.lock bun.lockb pyproject.toml requirements.txt poetry.lock setup.cfg setup.py go.mod go.sum Cargo.toml Gemfile pom.xml build.gradle build.gradle.kts .editorconfig .prettierrc .prettierrc.json .prettierrc.yaml .eslintrc .eslintrc.json .eslintrc.yml .stylelintrc .markdownlint.yml .markdownlint.json .github/workflows .gitlab-ci.yml; do
  if [[ -e "$f" ]]; then
    write "- $f"
  fi
done
write ""

write "## Languages (top 10 by file count)"
rg --files -g '*.*' 2>/dev/null | awk -F. 'NF>1{print tolower($NF)}' | sort | uniq -c | sort -nr | head -n 10 | while read -r count ext; do
  write "- $ext: $count"
done
write ""

write "## Commit Convention (heuristic)"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1 && git log -n 1 >/dev/null 2>&1; then
  total=$(git log --format=%s -n 200 | wc -l | tr -d ' ')
  conv=$(git log --format=%s -n 200 | rg -c '^(feat|fix|docs|chore|refactor|test|build|ci|perf|style|revert)(\(.+\))?:' || true)
  conv=${conv:-0}
  write "- Conventional commits (last 200): $conv / $total"
  body_with_text=$(python3 - <<'PY'
import subprocess, sys
raw = subprocess.check_output(["git", "log", "-n", "200", "--format=%B%x00"])
messages = raw.decode("utf-8", errors="ignore").split("\x00")
count = 0
total = 0
body_lines = 0
body_chars = 0
body_with_blank = 0
for msg in messages:
    msg = msg.strip("\n")
    if not msg:
        continue
    total += 1
    parts = msg.split("\n\n", 1)
    if len(parts) == 2 and parts[1].strip():
        count += 1
        body = parts[1].strip("\n")
        body_lines += len([l for l in body.splitlines() if l.strip() != ""])
        body_chars += len(body)
    if "\n\n" in msg:
        body_with_blank += 1
avg_lines = int(body_lines / count) if count else 0
avg_chars = int(body_chars / count) if count else 0
blank_ratio = f"{body_with_blank}/{total}" if total else "0/0"
print(f"{count}/{total}; avg_lines={avg_lines}; avg_chars={avg_chars}; blank_sep={blank_ratio}")
PY
  )
  write "- Commits with bodies (last 200): $body_with_text"
else
  write "- No commit history detected."
fi
write ""

write "## Commit Guidance (docs)"
commit_guides=$(rg -n --no-heading -g 'README.md' -g 'CONTRIBUTING.md' -g 'COMMITTING.md' -g 'COMMIT_MESSAGE.md' -g 'docs/*commit*.md' -g 'docs/*commit*.txt' 'commit message|commit(s)?\\b|pull request|PR' 2>/dev/null || true)
if [[ -n "$commit_guides" ]]; then
  echo "$commit_guides" | while read -r line; do
    write "- $line"
  done
else
  write "- No commit guidance lines detected in docs"
fi
write ""

write "## Standards Suggestions"
if [[ -n "${total:-}" && -n "${conv:-}" ]]; then
  if [[ "$total" -gt 0 ]]; then
    ratio=$((conv * 100 / total))
    if [[ "$ratio" -ge 50 ]]; then
      write "- commits (conventional commits appear common)"
    fi
  fi
fi
if [[ -n "${body_with_text:-}" ]]; then
  body_count=${body_with_text%%/*}
  body_total=${body_with_text##*/}
  if [[ "$body_total" -gt 0 ]]; then
    body_ratio=$((body_count * 100 / body_total))
    if [[ "$body_ratio" -ge 50 ]]; then
      write "- commit-bodies (commit bodies appear common)"
    fi
  fi
fi
md_count=$(rg --files -g '*.md' 2>/dev/null | wc -l | tr -d ' ')
if [[ "$md_count" -ge 10 ]]; then
  write "- markdown (documentation is present)"
fi
write ""

write "## Claude Artifacts"
if [[ -d ".claude" ]]; then
  write "- .claude/ (review and migrate contents)"
  rg --files ".claude" 2>/dev/null | while read -r line; do
    write "  - $line"
  done
fi
if [[ -e "CLAUDE.md" ]]; then
  write "- CLAUDE.md (migrate content into AGENTS.md/.agent and remove)"
fi
write ""

write "## Company Terms (candidates)"
doc_files=$(rg --files -g '*.md' -g '*.txt' 2>/dev/null | rg -v '^(\.agent/|AGENTS\.md$)$' || true)
if [[ -n "$doc_files" ]]; then
  acronyms=$(echo "$doc_files" | xargs rg -o --no-filename '\b[A-Z][A-Z0-9]{1,8}\b' 2>/dev/null | \
    rg -v '^(API|HTTP|HTTPS|JSON|YAML|YML|XML|SQL|DB|CI|CD|SDK|CLI|UI|UX|CPU|GPU|TLS|SSL|JWT|OIDC|SSO|URL|URI|UUID|ID|PR|MR|QA|OK|TODO|FIXME|RFC|REST|CRUD|MVC|MVP|NPM|PNPM|YARN|NODE|TS|JS|PY|RB|GO|JAVA|K8S|AWS|GCP|S3|JIRA|HTML|README|TESTING|SETUP|PLANS|MAIN|MERGE|REBASE|NOT|SET|ME|UP|CTRL|SHA|IDE|RAILS|RSPEC|RUBOCOP|BUNDLE|GEMFILE|GEM|GEMS|RAKE|KARAFKA|DATADOG|YARD|YARDDOC|MYSQL|POSTGRES|REDIS|SIDEKIQ|ACTIVERECORD|ACTIONCONTROLLER|ACTIONVIEW|ACTIVESUPPORT)$' | \
    sort | uniq -c | sort -nr | head -n 25 || true)
  if [[ -n "$acronyms" ]]; then
    echo "$acronyms" | while read -r count term; do
      hint=$(echo "$doc_files" | xargs rg -n -m1 "\\b${term}\\b.*(:| - | is | means )" 2>/dev/null | head -n 1 || true)
      if [[ -n "$hint" ]]; then
        write "- $term (count: $count) -> hint: $hint"
      else
        write "- $term (count: $count)"
      fi
    done
  else
    write "- No strong acronym candidates detected"
  fi

  named_terms=$(echo "$doc_files" | xargs rg -o --no-filename '"[A-Za-z][A-Za-z0-9 -]{2,30}"' 2>/dev/null | \
    sed 's/^"//; s/"$//' | rg -v '^[A-Za-z ]+$' | sort | uniq -c | sort -nr | head -n 10 || true)
  if [[ -n "$named_terms" ]]; then
    write "- Quoted terms to review:"
    echo "$named_terms" | while read -r count term; do
      write "  - $term (count: $count)"
    done
  fi
else
  write "- No markdown/text docs found for term detection"
fi
write ""

write "## Next Steps"
write "- Review the detected evidence and confirm which standards to create."
