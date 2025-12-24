{ ... }:
let
  catppuccin-delta = <catppuccin-delta>;
in
{
  programs.git = {
    enable = true;

    settings = {
      # config
      core.editor = "nvim";
      init.defaultBranch = "master";
      push.default = "current";
      pull.rebase = false;
      color = {
        ui = "auto";
        status = "auto";
        diff = "auto";
        branch = "auto";
      };

      # better diff to go with delta
      merge.conflictstyle = "diff3";
      diff.colorMoved = "dimmed-zebra"; # https://ruempler.eu/2023/12/31/code-reviews-with-git-color-diffs/

      pretty.custom = "%C(auto)%h %C(magenta)%ai %C(cyan)%aN %C(brightmagenta)(%ar) %C(auto)%D%n%s%n";
      #                         │             │           │                     │            │   └─ commit message
      #                         │             │           │                     │            └─ decorations (branch n stuff)
      #                         │             │           │                     └─ author relative date
      #                         │             │           └─ author name
      #                         │             └─ author date (ISO)
      #                         └─ hash (abbreviated)
      #
      # https://git-scm.com/docs/pretty-formats

      alias = {
        l = "log --graph --pretty=custom";
        ls = "l --stat";
        ds = "diff --shortstat";
      };
    };

    includes = [
      { # theme for delta
        path ="${catppuccin-delta}/catppuccin.gitconfig";
      }
    ];

    # sign commits/tags
    signing.format = "ssh";
    settings.gpg.ssh.defaultKeyCommand = "ssh-add -L"; # use first key in agent

    lfs.enable = true;
  };

  # better pager
  programs.delta = {
    enable = true;
    options = {
      navigate = true; # use n and N to move between diff sections
      light = false;
      line-numbers = true;
      side-by-side = true;
      features = "catppuccin-latte"; # theme
      enableGitIntegration = true;
    };
  };
}
