# Development tools and languages
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Version control
    lazygit     # Git TUI (one git interface)
    gh          # GitHub CLI
    
    # Programming languages (essential ones only)
    nodejs_20 
    yarn        # Node package manager
    rustc
    cargo
    python3
    go
    
    # Data processing
    jq          # JSON processor
    yq          # YAML processor
    
    # Container tools (if you use them)
    docker-compose
  ];
}
