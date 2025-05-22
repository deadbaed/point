{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs; [ vimPlugins.lazy-nvim ];
  };

  # symlinks to config
  xdg.configFile."nvim/init.lua".source = ./init.lua;
  xdg.configFile."nvim/lazy-lock.json".source = ./lazy-lock.json;

  # utils
  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.jq.enable = true;
  programs.neovide.enable = true;
}
