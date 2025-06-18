{ config, pkgs, lib, inputs, ... }:
let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {
  home.username = "phil";
  home.homeDirectory = (if isDarwin then /Users else /home) + "/${config.home.username}";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  imports = [
    ./git.nix
    ./vim/nvim
  ];

  targets.genericLinux.enable = isLinux;

  # bitwarden cli
  programs.rbw = {
    enable = true;
    settings = {
      pinentry = (if isDarwin then pkgs.pinentry_mac else pkgs.pinentry-gnome3);
      email = "p@philippeloctaux.com";
      base_url = "https://vaultwarden.philt3r.eu";
    };
  };

  # NOTE: To set default shell, edit `/etc/shells` to add `/home/$USER/.nix-profile/bin/zsh`
  programs.zsh = {
  enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "virtualenv"
        "timer"
      ];
    };
    sessionVariables = {
      TIMER_FORMAT = "took: %d";
      TIMER_THRESHOLD = "10";
    };
    initContent = ''
      rand_str() { len=''${1:-32}; LC_ALL=C ${pkgs.coreutils}/bin/tr -dc A-Za-z0-9 < /dev/urandom | ${pkgs.coreutils}/bin/head -c "$len"; ${pkgs.coreutils}/bin/echo }
    '';

    # TODO: redo prompt: show plugins (figure out a way for virtualenv)
  };

  home.shellAliases = {
    webserver = "${pkgs.python3Full}/bin/python3 -m http.server --directory $1";
    tokei = "${pkgs.tokei}/bin/tokei -C -s code";
    sl = "ls";
    lsa = "ls -la";
    l = "ls -1";
  } // (if isLinux then {
      s-u = "systemctl --user";
      s-ur = "systemctl --user daemon-reload";
    } else {});

  home.sessionPath = [ # add directories to PATH
    "${config.home.homeDirectory}/.cargo/bin"
  ];

  # better cat
  programs.bat = {
    enable = true;
    themes = {
      catppuccin = { src = inputs.catppuccin-bat; };
    };
    config = {
      theme = "Catppuccin Latte";
    };
    extraPackages = with pkgs.bat-extras; [
      batdiff
      batman
      batgrep
      batwatch
      prettybat
    ];
  };

  # better ls
  programs.lsd = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      icons = {
        when = "never"; # always, auto, never
      };
    };
  };

  # shell history & sync
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
    flags = [ "--disable-up-arrow" ];
  };

  # terminal multiplexer
  programs.zellij.enable = true;
  xdg.configFile."zellij/config.kdl".source = ./zellij/config.kdl;

  # autojump but in rust
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd j" ];
  };

  # tldr
  programs.tealdeer = {
    enable = true;
    settings = {
      auto_update = true;
    };
  };

  # gpg
  programs.gpg.enable = true;
  services.gpg-agent = {
    enable = true;
    enableZshIntegration = true;
  };

  # terminal
  programs.ghostty = {
    enable = true;
    package = (if isDarwin then pkgs.ghostty-bin else pkgs.ghostty);
    settings = {
      theme = "catppuccin-latte";
      window-decoration = (if isLinux then "none" else "auto");
    };
  };

  # tools with optional configuration
  programs.yt-dlp.enable = true;
  programs.btop.enable = true;
  programs.fastfetch.enable = true;

  # programs to install
  home.packages = with pkgs; [
    # networking
    curl
    wget
    wireguard-tools

    # system tools
    lnav
    osc
    tree
    dua
    smartmontools

    # nice utils
    qrencode # qrcode
    zbar # barcode
    age # file encryption
    libargon2 # passwords
    b3sum # blake3 hashing
    paperkey # pgp keys
    scrcpy # android screen copy

    # graphics / audio / video
    ffmpeg
    imagemagick

    # remote tools
    mosh
    bootterm

    # runtimes
    deno
    nodejs
    python3Full

    # dev tools
    tokei # count lines of code
    just # script runner
    sqlite
    mailpit # email testing
    certbot # acme client
    gcovr # coverage
    gource # history of a repository

    # rust utils
    cargo-audit
    cargo-vet

    # misc
    jetbrains-mono

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # TODO: package https://github.com/dnlmlr/cargo-clean-all
  # TODO: package https://github.com/openscopeproject/TrguiNG
  # TODO: package https://github.com/halfmexican/mingle
}
