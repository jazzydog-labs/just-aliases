# System Integration Points

This document lists the files and configuration that *just-aliases* touches on a macOS system.
It is useful for auditing or completely removing the tool.

## Files and locations

- `~/.oh-my-zsh/custom/jazzydog-labs/` – copies of the `bootstrap/*.zsh` scripts are placed here by `setup-modular-loading.sh`.
- Snippet inserted into `~/.zshrc` between `#START: Load all custom modular scripts` and `#END: Load all custom modular scripts`. This loads every script from the directory above.
- Lines sourcing `just-aliases.zsh` may be appended to `~/.zshrc` during manual setup.
- `~/.config/jazzydog-labs/.config.yaml` – configuration file copied from the repo.
- `~/.just-aliases/` – global installation with generated scripts and a `justfile`.

## Removal

Run `just uninstall` (or execute `./uninstall.sh`) to remove all of the above. It deletes the directories, removes the snippet from `~/.zshrc`, and cleans up any line that sources `just-aliases.zsh`.
