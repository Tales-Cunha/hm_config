{
  description = "Minimal Home Manager configuration for any user/hardware";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # Support multiple architectures
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      
      # Helper to create configurations for each system
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      
      # Function to create a home configuration for any user
      mkHomeConfiguration = system: username: {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./home.nix
          {
            home.username = username;
            home.homeDirectory = "/home/${username}";
          }
        ];
      };
    in
    {
      # Default configuration (template - replace with your username)
      homeConfigurations."template" = home-manager.lib.homeManagerConfiguration 
        (mkHomeConfiguration "x86_64-linux" "template");
        
      # Example configurations for common setups
      homeConfigurations."talescunha" = home-manager.lib.homeManagerConfiguration 
        (mkHomeConfiguration "x86_64-linux" "talescunha");
      
      # Template for easy customization
      templates.default = {
        path = ./.;
        description = "Minimal Home Manager configuration";
      };
    };
}
