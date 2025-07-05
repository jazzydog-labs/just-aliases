You are building a modal alias system for Zsh called just-aliases. Each mode corresponds to a file inside an aliases/ directory, where each file contains plain Zsh alias definitions. At any given time, only one mode is active.

### Core Behavior

- When switching modes:
    
    1. The rollback script from the current mode is sourced. It will **only remove or restore aliases** that still match the mode’s definition; if the alias has changed since activation (e.g. user override), it is **left untouched**.
        
    2. The apply script from the new mode is sourced. All aliases defined in that mode become active.
        
- The system does **not track state across sessions** — all alias rollback and switching is done dynamically per invocation.
    
- The "general" state of the shell (aliases before any mode is activated) is **not stored globally**. Instead, each mode captures a snapshot of alias state at the time the mode is built — only for the aliases it will overwrite.
    

### UX

- A shell function `m` is provided.
    
    - It invokes a Python script to show all available modes (based on the files in `aliases/`).
        
    - The user selects one mode.
        
    - The script then sources the current mode’s rollback script and the selected mode’s apply script.
        
    - It **tracks the current active mode** via a shell variable (e.g. `__just_aliases_active_mode`) to know which rollback script to use.
        

### Build Step

- A `build-aliases` script is run **inside an interactive shell session**.
    
- For each mode file:
    
    - It identifies the aliases defined.
        
    - For each alias, it checks the current shell to see if that alias is already defined:
        
        - If yes, it writes a `snapshot` file to preserve that original definition.
            
    - It writes:
        
        - An `apply` file that declares the mode’s aliases.
            
        - A `rollback` file that restores the original definitions **only if the current alias still matches the mode-defined value**; otherwise it does nothing.
            
- These files are written to `.cache/just-aliases/<mode>-apply.zsh`, `<mode>-rollback.zsh`, and `<mode>-snapshot.zsh`.
    

### Mode Switching Safety

- Switching modes always involves:
    
    1. Sourcing the rollback script from the current mode.
        
    2. Sourcing the apply script from the new mode.
        
- If an alias was redefined by the user between activation and rollback, it will not be touched.
    
- Only one mode is active at a time.  
    TODO: Later consider composing multiple modes or supporting alias overlays.
    

---

Let me know if you'd like a sample Python implementation to go with this.