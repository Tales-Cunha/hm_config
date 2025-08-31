{ config, pkgs, ... }:

{
  # Enable unfree packages only when absolutely necessary
  nixpkgs.config.allowUnfree = true;

  # Import modular package configurations
  imports = [
    ./core.nix
    ./cli-tools.nix  
    ./development.nix
    ./productivity.nix
  ];
}
