{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Essential system utilities
    curl
    wget
    unzip
    htop
    btop        # Modern htop alternative
    tree
    du-dust     # Modern du alternative
    duf         # Modern df alternative
    
    # Modern CLI tools (replace traditional ones)
    bat         # Better cat
    fd          # Better find
    ripgrep     # Better grep
    eza         # Better ls
    zoxide      # Smart cd
    delta       # Better git diff (used by git config)
    
    # Development essentials
    jq          # JSON processor
    yq          # YAML processor
    lazygit     # Git TUI
    gh          # GitHub CLI
    
    # Shell tools
    starship    # Prompt
    fzf         # Fuzzy finder
    direnv      # Environment management
    tmux        # Terminal multiplexer (backup if not using system tmux)
    
    # Programming languages and tools
    nodejs_20 
    yarn
    rustc
    cargo
    python3
    go
    
    # System monitoring and info
    neofetch    # System info
    procs       # Modern ps alternative
    
    # File management
    rsync       # File sync
    rclone      # Cloud storage sync
    
    # Network tools
    dig         # DNS lookup
    nmap        # Network scanner
    
    # Applications
    obsidian    # Notes (unfree)
    
    # Additional development tools
    docker-compose  # Container orchestration
    k9s         # Kubernetes TUI (if you use k8s)
    
    # Text processing
    pandoc      # Document converter
    
    # Archive tools
    p7zip       # 7-zip
    unrar       # RAR archives

    telegram-desktop
  ];
}
