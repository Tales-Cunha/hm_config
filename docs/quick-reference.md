# Quick Reference Guide

## Essential Commands

### Home Manager
```bash
hm           # Apply configuration changes
hm-edit      # Edit configuration
hm-diff      # Show configuration diff
```

### Git Workflow
```bash
gst          # git status
gaa          # git add --all
gc "message" # git commit with message
gp           # git push
gl           # git pull
gco branch   # git checkout branch
gd           # git diff
glog         # git log (pretty)
```

### Modern CLI Tools
```bash
# File operations
ll           # eza -la --icons (better ls)
cat file     # bat file (syntax highlighted)
tree         # eza --tree --icons (tree view)

# Navigation
z project    # zoxide smart cd to project
..           # cd ..
...          # cd ../..

# System monitoring
top          # btop (system monitor)
ps           # procs (process list)
du           # dust (disk usage)
df           # duf (disk free)

# Search and find
rg pattern   # ripgrep (better grep)
fd filename  # fd (better find)
```

### Tmux + Project Management
```bash
tms          # tmux-sessionizer (find and switch projects)
ta session   # tmux attach to session
tl           # tmux list sessions
proj name    # find project and auto-start tmux if needed
```

### Neovim + Tmux Integration
```bash
v file       # open file in neovim
vim file     # alias for neovim

# Inside Neovim (with tmux)
<Ctrl-h/j/k/l>    # Navigate seamlessly between vim/tmux panes
<leader>vr        # Run command in tmux pane
<leader>vl        # Run last command in tmux
<leader>vq        # Close tmux runner
```

### Development Utilities
```bash
# Version control
lazygit      # Git TUI interface
gh           # GitHub CLI

# Data processing
jq '.'       # Format JSON
yq '.'       # Process YAML

# System info
info         # neofetch (system information)
```

### Archive Operations
```bash
extract file.zip    # Universal extractor function
p7zip -h           # Archive tool help
```

### Project Workflow

1. **Start a project session:**
   ```bash
   tms
   # or
   proj myproject
   ```

2. **Navigate and edit:**
   ```bash
   ll              # See files with icons
   v important.py  # Edit in neovim
   ```

3. **Git workflow:**
   ```bash
   gst             # Check status
   gaa && gc "Add new feature"  # Stage and commit
   gp              # Push changes
   ```

4. **System monitoring:**
   ```bash
   top             # Monitor system
   du              # Check disk usage
   ```

## File Structure

```
~/.config/home-manager/
├── home.nix                 # Main configuration
├── modules/                 # Modular packages
│   ├── packages.nix        # Module coordinator
│   ├── core.nix           # Essential utilities
│   ├── cli-tools.nix      # Modern CLI tools
│   ├── development.nix    # Programming tools
│   └── productivity.nix   # Productivity apps
├── programs/              # Program configurations
│   ├── git.nix           # Git with delta
│   ├── zsh.nix           # ZSH with starship
│   ├── tmux.nix          # Tmux configuration
│   └── neovim.nix        # Neovim with LazyVim
└── scripts/              # Custom scripts
    └── tmux-sessionizer.sh
```

## Configuration Philosophy

- **One app per purpose** - No duplicate functionality
- **Terminal-first** - Everything accessible via keyboard
- **Tmux-centric** - Seamless integration between terminal and editor
- **Modern tools** - Replace traditional UNIX tools with better alternatives
- **Modular design** - Easy to maintain and extend

## Customization

To add new packages:
1. Identify the appropriate module (core, cli-tools, development, productivity)
2. Add package to relevant module in `modules/`
3. Run `hm` to apply changes

To modify program configs:
1. Edit relevant file in `programs/`
2. Run `hm` to apply changes