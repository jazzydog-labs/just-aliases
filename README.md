# just-aliases

A small modal alias system for Zsh.  Alias definitions live under `aliases/` and are grouped into "modes".  The shell function `ja` lets you enable one mode at a time and roll back safely.

## Quick start

```bash
# clone and build the mode scripts
 git clone <repo-url>
 cd just-aliases
 python just_aliases.py build

# enable the shell integration
 echo "source $(pwd)/just-aliases.zsh" >> ~/.zshrc
 source ~/.zshrc
```

## Commands

- `ja` – interactive mode selection
- `ja list` – list available modes
- `ja switch <mode>` – activate a mode directly
- `ja-current` – show the active mode
- `ja-clear` – roll back the active mode
- `build-aliases` – regenerate scripts after editing `aliases/`

## Creating a mode

1. Add a file `aliases/my-mode.zsh` containing your aliases:
   ```zsh
   alias ll='ls -la'
   alias gs='git status'
   ```
2. Run `build-aliases`.
3. Activate with `ja switch my-mode`.

## Layout

```
aliases/           # raw mode files
scripts/           # generated apply/rollback scripts
just_aliases.py    # build logic
just-aliases.zsh   # shell integration
```

See `documents/high-level-idea.md` for the broader design goals.
