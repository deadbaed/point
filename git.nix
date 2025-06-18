{ inputs, ... }:
{
  programs.git = {
    enable = true;

    includes = [
      { # set git identity only for dotfiles repo
        condition = "gitdir:~/point/";
        contents = {
          user = {
            email = "p@philippeloctaux.com";
            name = "Philippe Loctaux";
          };
        };
      }
      { # theme for delta
        path ="${inputs.catppuccin-delta}/catppuccin.gitconfig";
      }
    ];

    extraConfig = {
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
    };

    # sign commits/tags
    signing.format = "ssh";
    extraConfig.gpg.ssh.defaultKeyCommand = "ssh-add -L"; # use first key in agent

    aliases = {
      l = "log --graph --pretty=custom";
      ls = "l --stat";
      ds = "diff --shortstat";
    };

    lfs.enable = true;

    # better pager
    delta = {
      enable = true;
      options = {
        navigate = true; # use n and N to move between diff sections
        light = false;
        line-numbers = true;
        side-by-side = true;
        features = "catppuccin-latte"; # theme
      };
    };
  };
}
