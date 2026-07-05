{ config, pkgs, ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      theme = "catppuccin_latte";
      editor = {
        line-number = "relative";
        lsp = {
          display-progress-messages = true;
          display-inlay-hints = true;
        };
      };
    };
  };
}
