{ config, pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs; [ vimPlugins.lazy-nvim ];

    extraPackages = with pkgs; [
      gcc # For https://github.com/romus204/tree-sitter-manager.nvim
    ];
  };

  # symlink to config
  # make sure it is writtable for lazy-lock.json
  xdg.configFile."nvim/init.lua".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/point/vim/nvim/init.lua";
  xdg.configFile."nvim/lazy-lock.json".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/point/vim/nvim/lazy-lock.json";

  # utils
  programs.ripgrep.enable = true;
  programs.fd.enable = true;
  programs.jq.enable = true;

  home.packages = with pkgs; [
    tree-sitter
    coreutils
  ];
}
