# priority
- [x] add autocomplete for repos with g/lg


## workflow
- add some aliases for:
    - opening browser (with current repo context)
    - opening cursor with current repo context
    - managing tmux sessions/windows...maybe we manage them and switch automatically
    - checking some cron jobs or something that automatically update a terminal if its become stale... if we didn't do anything for several minutes it will show a notification that we will have something to do there
    - loom go can keep track of events that are queued up and that we wanna visit (e.g. loom go next)
    - loom go can figure out context of what it wants to do

- we want to have some way of grepping for todos in all the files in the directory
    - this means we need a pattern for all files in the directory that may have todos
        - and a way of viewing the todos with some context to them (e.g. file path, maybe a surrounding line or two)
    - its useful to have a project skeleton (something like a pre-image projection), i.e. we can see all the directories and all the types of files that they would have. when we add a new file to git we validate it against the skeleton schema or whatever its called and see if we need to update the schema





## maybe later, optional
- optional aliases
    - opening terminal/terminal tabs with current repo context
    - opening file explorer with current repo context  
    - opening git GUI tools (like GitKraken, SourceTree) with current repo context
    - opening project documentation (README, docs folder) in browser
    - opening project issues/PRs in browser (GitHub/GitLab)
    - opening project CI/CD pipelines in browser
    - opening project monitoring/logs dashboards
    - opening project database/admin tools
    - opening project API documentation (Swagger, etc.)
    - opening project test coverage reports
    - opening project dependency/license reports
    - opening project security scan reports

## touchpoint tracking
- implement a schema describing all integration points (files, directories, zshrc snippets)
- expose a command that lists these touchpoints
- validate that `uninstall` removes everything defined in the schema
