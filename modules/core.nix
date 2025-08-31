# Core system utilities - absolutely essential tools
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # File operations
    curl
    wget
    unzip
    rsync
    
    # System monitoring (one tool per purpose)
    btop        # System monitor (replaces htop)
    
    # File management
    tree
    du-dust     # Disk usage (replaces du)
    duf         # Disk free (replaces df)
    
    # Network essentials
    dig         # DNS lookup
    
    # Archive handling
    p7zip       # Universal archive tool
  ];
}
