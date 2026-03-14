---
name: add-skill-repo
description: >
  Upload/publish a skill to the user's skills repo. Use this skill when the user asks to
  "upload", "push", "add", or "publish" a skill to their repo, e.g. "sube la skill X a mi repo",
  "push skill X to my repo", "add skill X to the repo". Copies the skill from ~/.codex/skills/
  to ~/skills/, handles gh auth switching to bravados if needed, commits, and pushes.
---

# Add Skill to Repo

Copy a locally installed skill to the `~/skills` repository, commit, and push.

## Procedure

1. **Identify the skill name** from the user's request.

2. **Verify the skill exists** at `~/.codex/skills/<skill-name>/`. If it does not exist, inform the user and stop.

3. **Copy the skill** to `~/skills/`:
   ```bash
   cp -R ~/.codex/skills/<skill-name> ~/skills/<skill-name>
   ```

4. **Check the active `gh` user**:
   ```bash
   gh auth status 2>&1
   ```
   Parse the output to determine the currently logged-in account. Store it for later restoration.

5. **Switch to `bravados` if needed**:
   - If the active account is NOT `bravados`, switch:
     ```bash
     gh auth switch --user bravados
     ```
   - Remember whether a switch was performed.

6. **Commit and push** from `~/skills/`:
   ```bash
   git -C ~/skills add <skill-name>
   git -C ~/skills commit -m "feat: add skill <skill-name>" -m "Co-Authored-By: Oz <oz-agent@warp.dev>"
   git -C ~/skills push
   ```

7. **Restore the original `gh` user** if it was changed in step 5:
   ```bash
   gh auth switch --user <original-user>
   ```

## Notes

- Always restore the original `gh` user after pushing, even if the push fails.
- If the skill directory already exists in `~/skills/`, ask the user whether to overwrite before proceeding.
