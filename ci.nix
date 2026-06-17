let
  sources = import ./npins;
  home-manager = import sources.home-manager { };

  mkNixpkgs =
    system: nixpkgs:
    import nixpkgs {
      inherit system;
      config = { };
      overlays = [ ];
    };

  pkgs-x86-64-linux = mkNixpkgs "x86_64-linux" sources."nixos-26.05";
  nixpkgs-path = {
    nix.nixPath = [ "nixpkgs=${builtins.storePath pkgs-x86-64-linux.path}" ];
  };

in
{
  headless-home-manager-linux-x86_64 = home-manager.lib.homeManagerConfiguration {
    pkgs = pkgs-x86-64-linux;
    modules = [
      nixpkgs-path
      ./home.nix
      ./home-non-nixos.nix
    ];
  };

  gui-home-manager-linux-x86_64 = home-manager.lib.homeManagerConfiguration {
    pkgs = pkgs-x86-64-linux;
    modules = [
      nixpkgs-path
      ./home.nix
      ./home-gui.nix
      ./home-non-nixos.nix
      (
        {
          config,
          pkgs,
          ...
        }:
        {
          imports = [

            (import ./niri { inherit config pkgs; })
          ];

        }
      )
    ];
  };

}
