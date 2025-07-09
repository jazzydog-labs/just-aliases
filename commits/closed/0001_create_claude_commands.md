We would like to have custom claude commands under a ./commands directory, that after `just bootstrap && source ~/.zshrc`, will be moved into (a possibly nonexistant `~/.claude/commands`).

```
# So the first step is something like:
mkdir -p ~/.claude/commands
# then we copy `./commands` to `~/.claude/commands`
...

please write this code, as well as some example, useful commands given this repo


