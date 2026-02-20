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

    programs.zsh.sessionVariables = {
#      SSH_AUTH_SOCK = "${config.home.homeDirectory}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock";
    };
  };
}
