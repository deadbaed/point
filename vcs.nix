{ ... }:
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

    # sign commits/tags
    signing.format = "ssh";
    settings.gpg.ssh.defaultKeyCommand = "ssh-add -L"; # use first key in agent

    lfs.enable = true;
  };

  # git alternative
  programs.jujutsu = {
    enable = true;
    settings = {
      ui = {
        default-command = "log";
        pager = "less";
        diff-editor = ":builtin";
      };
      # thank you https://ddbeck.com/notes/jj-git-push-bookmark-template/
      template-aliases."slugify(str)" = ''
        truncate_end(
            65,
            str.first_line()
            .replace(regex:'[^[[:alnum:]].]', '_')
            .replace(regex:'_{2,}', '_')
            .replace(regex:"(^_+|_+$)", "")
            .lower()
            )
      '';
    };
  };

  # smart merge conflict
  programs.mergiraf = {
    enable = true;
    enableGitIntegration = true;
    enableJujutsuIntegration = true;
  };

  # better diffing
  programs.difftastic = {
    enable = true;
    git = {
      enable = true;
      diffToolMode = true;
    };
    jujutsu.enable = true;
  };
}
