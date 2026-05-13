{
  config,
  lib,
  pkgs,
  ...
}:

let
  sources = import ../../npins;
in
{
  imports = [ (import "${sources.home-manager}/nixos") ];

  # home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.phil =
    { config, pkgs, ... }:
    {
      imports = [
        ../../home.nix
        ../../home-gui.nix
        (import ../../niri { inherit sources pkgs config; })
      ];

      programs.git.settings.user = {
        name = "Philippe Loctaux";
        email = "p@philippeloctaux.com";
      };

      home.sessionVariables = {
        SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/rbw/ssh-agent-socket";
      };

      home.packages = with pkgs; [
        firefox
      ];
    };
}
