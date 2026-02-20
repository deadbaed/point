{ config, pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {
  programs.neovide.enable = true;
  home.packages = with pkgs; [
  ] ++ (if isLinux then [
    pkgs.bitwarden-desktop
  ] else [
  ]);
  programs.firefox = {
    enable = true;
    languagePacks = [ "en-GB" "fr" "ru" ];
  };
}
