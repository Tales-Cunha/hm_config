# Modern CLI replacements for traditional tools
{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Better traditional tools (one replacement per tool)
    bat         # Better cat
    fd          # Better find  
    ripgrep     # Better grep
    eza         # Better ls
    zoxide      # Smart cd
    delta       # Better git diff
    procs       # Better ps
    
    # Essential shell tools
    starship    # Prompt
    fzf         # Fuzzy finder
    direnv      # Environment management
  ];
}
