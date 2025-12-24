{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs; [ vimPlugins.lazy-nvim ];
  };

  # symlink to config
  # make sure it is writtable for lazy-lock.json
  xdg.configFile.nvim = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/point/vim/nvim/";
    recursive = true;
  };

  # utils
  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.jq.enable = true;
}
