{
  config,
  lib,
  pkgs,
  ...
}:

let
  name = "Philippe Loctaux";
  email = "p@philippeloctaux.com";
in
{
  programs.git.settings.user = {
    inherit name email;
  };
  programs.jujutsu.settings.user = {
    inherit name email;
  };

}
