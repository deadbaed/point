{ config, pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in
{
  programs.neovide.enable = true;
  programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      vscodevim.vim
      wakatime.vscode-wakatime
    ];
  };
  home.packages =
    with pkgs;
    [
      localsend
    ]
    ++ (
      if isLinux then
        [
          pkgs.bitwarden-desktop
        ]
      else
        [
        ]
    );
}
