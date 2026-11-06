{
  sources ? import ../../npins,
  pkgs ? import <nixpkgs> { },
  config,
}:
let
  noctalia = import sources.noctalia {
    inherit pkgs; # this line is optional, prevents downloading two versions of nixpkgs but disables cache
  };
in
{
  imports = [ noctalia.homeModule ];

  home.packages = with pkgs; [
    gpu-screen-recorder
    networkmanagerapplet
  ];

  programs.noctalia = {
    enable = true;
    settings = ./config.toml;
  };
}
