{ config, pkgs, lib, inputs, ... }:
{
  programs.zsh.sessionVariables = {
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock";
  };
}
