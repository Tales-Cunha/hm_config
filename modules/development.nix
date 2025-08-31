# Development tools and languages
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Version control (one git interface)
    lazygit     # Git TUI
    gh          # GitHub CLI
    
    # Programming languages (essential ones only)
    nodejs_20 
    python3
    rustc
    cargo
    go
    
    # Data processing
    jq          # JSON processor
    yq          # YAML processor
  ];
}
