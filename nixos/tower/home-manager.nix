{ config, lib, pkgs, ... }:

let
  sources = import ../../npins;
in
{
  imports = [ (import "${sources.home-manager}/nixos") ];

  # home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.phil = { config, pkgs, ... }: {
    imports = [ ../../home.nix ../../home-gui.nix ];

    programs.git.settings.user = {
      name = "Philippe Loctaux";
      email = "p@philippeloctaux.com";
    };

    home.sessionVariables = {
      # Make sure the ssh agent is enabled inside Bitwarden settings
      SSH_AUTH_SOCK = "${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
    };
  };
}
