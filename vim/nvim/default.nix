{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs; [ vimPlugins.lazy-nvim ];

    # Darwin: put the Nix compiler before /usr/bin so `cc` does not trigger Xcode.
    extraWrapperArgs = lib.optionals pkgs.stdenv.isDarwin [
      "--prefix"
      "PATH"
      ":"
      "${lib.makeBinPath [ pkgs.stdenv.cc ]}"
    ];

    extraPackages = with pkgs; [
      # For https://github.com/romus204/tree-sitter-manager.nvim
      stdenv.cc
      tree-sitter

      # For https://github.com/symphorien/vim-nixhash
      coreutils
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
}
