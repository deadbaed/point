{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.enable = true;
}
