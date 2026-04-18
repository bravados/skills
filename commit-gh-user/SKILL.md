---
name: commit-gh-user
description: >
  Ensure the correct GitHub CLI (`gh`) user is active before committing in the
  current directory. Use this skill whenever the user asks to commit, push, or
  otherwise create git history in the working repository (e.g. "commitea esto",
  "haz un commit", "commit these changes", "push this"). If the `origin` remote
  belongs to the `bravados` organization/user, switch to the `bravados` gh
  account; otherwise switch to `javier-mesah`. Always verify (and switch if
  needed) BEFORE running `git commit`.
---

# Commit GH User

Make sure the active `gh` account matches the repository's `origin` remote
before creating any commit in the current directory.

## When to activate

Trigger this skill any time the user asks to create a git commit or push from
the current working directory. Examples:

- "commitea los cambios"
- "haz un commit con esto"
- "commit and push"
- "sube esto al repo"

Do NOT activate for the `add-skill-repo` skill's flow — that skill manages its
own `gh` switching for `~/skills/`.

## Procedure

1. **Detect the repository's `origin` remote** from the current directory:
   ```bash
   git remote get-url origin
   ```
   If the command fails (no remote / not a git repo), inform the user and stop.

2. **Determine the target `gh` user** from the remote URL:
   - If the URL owner segment is `bravados` (e.g. `git@github.com:bravados/...`
     or `https://github.com/bravados/...`), the target user is `bravados`.
   - Otherwise, the target user is `javier-mesah`.

3. **Check the active `gh` user**:
   ```bash
   gh auth status 2>&1
   ```
   Parse the output to find the line marked `Active account: true` and extract
   the account login.

4. **Switch `gh` user if needed**:
   - If the active account does NOT match the target user from step 2, run:
     ```bash
     gh auth switch --user <target-user>
     ```
   - If it already matches, skip the switch.

5. **Proceed with the commit** the user requested. Use a conventional commit
   message and include the co-author trailer:
   ```bash
   git add <files>
   git commit -m "<message>" -m "Co-Authored-By: Oz <oz-agent@warp.dev>"
   ```

6. **Do not restore the previous `gh` user** after committing — the account
   should remain aligned with the repository's remote.

## Notes

- Detection is based on the URL **owner**, not the full URL. Both SSH
  (`git@github.com:OWNER/REPO.git`) and HTTPS
  (`https://github.com/OWNER/REPO.git`) formats are supported.
- If `bravados` or `javier-mesah` is not available in `gh auth status`, stop
  and ask the user to log in with `gh auth login` for that account before
  retrying.
- Only act on the `origin` remote. Ignore other remotes.
