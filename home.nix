{ config, pkgs, ... }:

{
  # Basic user configuration (will be set by flake parameters)
  # home.username and home.homeDirectory are set by the flake
  home.stateVersion = "25.05"; # Don't change this after first install

  # Import modular configurations
  imports = [
    ./modules/packages.nix
    ./modules/fonts.nix
    ./programs/git.nix
    ./programs/zsh.nix
    ./programs/tmux.nix
    ./programs/neovim.nix
  ];

  # Allow Home Manager to manage itself
  programs.home-manager.enable = true;

  # Essential scripts
  home.file = {
    ".local/bin/tmux-sessionizer" = {
      source = ./scripts/tmux-sessionizer.sh;
      executable = true;
    };
  };
  
  # XDG directories
  xdg.enable = true;
  
  # Additional environment variables
  home.sessionVariables = {
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };
}
