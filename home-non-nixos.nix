{ config, pkgs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {
 home.username = "phil";
 home.homeDirectory = (if isDarwin then /Users else /home) + "/${config.home.username}";

