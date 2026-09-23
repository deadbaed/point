{
  config,
  pkgs,
  lib,
  ...
}:
let
  sources = import ../../npins;
  username = "phil";
in
{
  # This must be a full path, or this file should be in `/etc/nix-darwin/configuration.nix`
  environment.darwinConfig = "/Users/phil/point/machines/darwin/configuration-small.nix";

  # I do not use flakes, and I do not want to use channels
  system.checks.verifyNixPath = false;

  # Attempt to kill channels
  # Thank you to https://jade.fyi/blog/pinning-nixos-with-npins/
  nixpkgs.flake.source = sources."nixpkgs-26.05-darwin";

  nixpkgs.overlays = [ ];

  nix = {
    channel.enable = false;
    nixPath = [
      "nixpkgs=${sources."nixpkgs-26.05-darwin"}"
      "darwin=${sources.nix-darwin}"
      "home-manager=${sources.home-manager}"
      "darwin-config=/Users/phil/point/machines/darwin/configuration-small.nix"
    ];
  };

  imports = [ (import "${sources.home-manager}/nix-darwin") ];

  # home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} =
    { config, pkgs, ... }:
    {
      imports = [
        ../../home.nix
        ../../home-gui.nix
        ../../home-non-nixos.nix
        ../../personal-identities.nix
      ];
    };

  nix = {
    optimise.automatic = true;
    settings = {
      trusted-users = [ username ];
      # Necessary for using flakes on this system.
      experimental-features = "nix-command flakes";

      # Additional binary caches
      substituters = [ ];
      trusted-public-keys = [ ];
    };
  };

  environment.shellAliases = {
    vim = "nvim";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = username;
  users.users.${username} = {
    name = username;
    home = /Users/phil;
    shell = pkgs.zsh;
  };

  # No startup sound
  system.startup.chime = false;

  # macOS defaults
  system.defaults = {
    WindowManager.EnableStandardClickToShowDesktop = false; # Only on stage manager
    menuExtraClock.ShowSeconds = true;
  };

  environment.systemPackages = with pkgs; [
    mosh
  ];
}
