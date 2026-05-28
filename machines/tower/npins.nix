{
  config,
  lib,
  ...
}:

let
  sources = import ../../npins;
  pkgs = import sources."nixos-26.05" { };
in
# thank you https://piegames.de/dumps/pinning-nixos-with-npins-revisited/
{
  nix = {
    channel.enable = false;
    nixPath = [
      "nixpkgs=/etc/nixos/nixpkgs"
      "nixos-config=/home/phil/point/machines/tower/configuration.nix"
    ];
  };

  environment.etc = {
    "nixos/nixpkgs".source = builtins.storePath pkgs.path;
  };
}
