{
  description = "point";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # themes
    catppuccin-bat = {
      flake = false;
      url = "github:catppuccin/bat";
    };
    catppuccin-delta = {
      flake = false;
      url = "github:catppuccin/delta";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#m1ir
      darwinConfigurations."m1ir" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs self; };
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "home-manager.backup";
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.phil = {
              imports = [ ./home.nix ./home-darwin.nix ];
              programs.git = {
                userName = "Philippe Loctaux";
                userEmail = "p@philippeloctaux.com";
              };
            };
          }
        ];
      };
    };

  # TODO: add alejandra formatted
}
