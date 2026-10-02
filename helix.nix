{ config, pkgs, ... }:
{
  programs.helix = {
    enable = true;
    settings = {
      # TODO: switch to dual theme when helix > 25.07.1 is out
      theme = "catppuccin_latte";
      # theme.dark = "catppuccin_mocha";
      # theme.light = "catppuccin_latte";

      editor = {
        line-number = "relative";
        lsp = {
          display-progress-messages = true;
          display-inlay-hints = true;
        };
        end-of-line-diagnostics = "hint";
        inline-diagnostics.cursor-line = "warning";
        bufferline = "multiple";
      };
    };
  };
}
