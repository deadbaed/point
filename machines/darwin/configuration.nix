{
  config,
  pkgs,
  lib,
  ...
}:
let
  sources = import ../../npins;
  username = "phil";
  tilesize = 30;
in
{
  # This must be a full path, or this file should be in `/etc/nix-darwin/configuration.nix`
  environment.darwinConfig = "/Users/phil/point/machines/darwin/configuration.nix";

  # I do not use flakes, and I do not want to use channels
  system.checks.verifyNixPath = false;

  # Attempt to kill channels
  # Thank you to https://jade.fyi/blog/pinning-nixos-with-npins/
  nixpkgs.flake.source = sources.nixpkgs;

  imports = [
    <home-manager/nix-darwin>
  ];

  # home-manager
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.${username} =
    { config, pkgs, ... }:
    {
      imports = [
        ../../home.nix
        ../../home-gui.nix
        ../../home-non-nixos.nix
      ];

      programs.git.settings.user = {
        name = "Philippe Loctaux";
        email = "p@philippeloctaux.com";
      };

      programs.zsh.sessionVariables = {
        SSH_AUTH_SOCK = "${config.home.homeDirectory}/Library/Containers/com.bitwarden.desktop/Data/.bitwarden-ssh-agent.sock";
      };
    };

  nix = {
    optimise.automatic = true;
    settings = {
      trusted-users = [ username ];
      # Necessary for using flakes on this system.
      experimental-features = "nix-command flakes";

      # Additional binary caches
      substituters = [ ];
      trusted-public-keys = [ ];
    };
  };

  environment.shellAliases = {
    vim = "nvim";
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  system.primaryUser = username;
  users.users.${username} = {
    name = username;
    home = /Users/phil;
    shell = pkgs.zsh;
  };

  # TouchID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  # No startup sound
  system.startup.chime = false;

  # macOS defaults
  system.defaults = {
    WindowManager.EnableStandardClickToShowDesktop = false; # Only on stage manager
    screensaver = {
      askForPassword = true;
      askForPasswordDelay = 0;
    };

    dock = {
      tilesize = tilesize;
      magnification = true;
      largesize = tilesize * 3;
      show-recents = false;
      persistent-apps = [
        {
          app = "/Applications/Safari.app";
        }
        {
          app = "/Applications/Nix Apps/Ghostty.app";
        }
        {
          app = "/Applications/Spotify.app";
        }
        {
          app = "/System/Applications/Messages.app";
        }
        {
          app = "/System/Applications/Mail.app";
        }
        {
          app = "/System/Applications/Calendar.app";
        }
        {
          app = "/System/Applications/System Settings.app";
        }
      ];
      persistent-others = [
        {
          folder = {
            path = "/Applications/";
            showas = "grid";
          };
        }
        {
          folder = {
            path = "/Users/${username}/Downloads";
            arrangement = "date-added";
            showas = "fan";
          };
        }
      ];

      # No hot corners
      wvous-br-corner = 1;
      wvous-bl-corner = 1;
      wvous-tl-corner = 1;
      wvous-tr-corner = 1;
    };

    finder = {
      ShowHardDrivesOnDesktop = true;
      ShowExternalHardDrivesOnDesktop = true;
      ShowMountedServersOnDesktop = true;
      ShowRemovableMediaOnDesktop = true;

      # Disable warning when changing a file extension
      FXEnableExtensionChangeWarning = false;

      # Show path bar, and layout as multi-column
      ShowPathbar = true;

      _FXShowPosixPathInTitle = true; # show full path in finder title
      _FXSortFoldersFirst = true;

      # Change the default finder view
      # “icnv” = Icon view, “Nlsv” = List view, “clmv” = Column View, “Flwv” = Gallery View. The default is icnv.
      FXPreferredViewStyle = "Nlsv";
      #
      # # Search in current folder by default
      # FXDefaultSearchScope = "SCcf";

      NewWindowTarget = "Home";
    };

    # 18 = Display icon in menu bar
    # 24 = Hide icon in menu bar
    controlcenter = {
      NowPlaying = true;
      Sound = true;
    };

    menuExtraClock.ShowSeconds = true;

    NSGlobalDomain = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;

      AppleWindowTabbingMode = "always";

      # Disable smart dash/period/quote substitutions
      NSAutomaticDashSubstitutionEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      NSAutomaticQuoteSubstitutionEnabled = false;

      # Disable automatic capitalization
      NSAutomaticCapitalizationEnabled = false;

      # Disable automatic spelling correction
      NSAutomaticSpellingCorrectionEnabled = false;

      # Local save by default
      NSDocumentSaveNewDocumentsToCloud = false;

      # Extended save panel
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;

      "com.apple.sound.beep.feedback" = 1;
    };

    CustomUserPreferences = {
      "com.apple.Safari" = {
        ShowFullURLInSmartSearchField = true;
        AlwaysRestoreSessionAtLaunch = true;

        # Disable auto open safe downloads
        AutoOpenSafeDownloads = false;
      };
    };

    # Stole a lot from https://github.com/hzspyy/dotfiles/blob/188c7e2d110405593e71d3ea03475cfac3c4c97a/configs/nix-darwin/configuration.nix#L155
    # Thank you!
    CustomSystemPreferences = {
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on USB or network volumes
        DSDontWriteUSBStores = true;
        DSDontWriteNetworkStores = true;
      };

      "com.apple.AdLib" = {
        # Disable personalized advertising
        forceLimitAdTracking = true;
        allowApplePersonalizedAdvertising = false;
        allowIdentifierForAdvertising = false;
      };

      "com.apple.Safari" = {
        SendDoNotTrackHTTPHeader = true;

        # Enable Develop Menu, Web Inspector
        IncludeDevelopMenu = true;
        IncludeInternalDebugMenu = true;
        WebKitDeveloperExtras = true;
        WebKitDeveloperExtrasEnabledPreferenceKey = true;
        "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" = true;
      };
    };
  };

  # homebrew
  homebrew.enable = true;
  environment.systemPath = [ "${config.homebrew.prefix}/bin" ]; # add homebew to PATH
  homebrew.brews = [
    # formulae
    "mas" # mac app store, https://github.com/mas-cli/mas
    "imagesnap" # catpure images from webcam
  ];
  homebrew.casks = [
    # graphical apps
    "background-music" # control sound of individual apps
    "calibre" # epub
    "cog-app" # audio player
    "discord"
    "ungoogled-chromium"
    "firefox"
    "imageoptim" # compress images
    "inkscape"
    "handbrake-app"
    "keepassxc"
    "lulu" # firewall
    "nextcloud"
    "obs"
    "openmtp" # android file transfer
    "orion" # test web browser
    "paintbrush" # simple image editor
    "pinta"
    "pocket-casts"
    "spotify"
    "signal"
    "steam"
    "tor-browser"
    "transmission" # until nixpkgs has mac gui
    "veracrypt"
    "whatsapp"
  ];
  homebrew.masApps = {
    # mac app store apps
    # To find the app name with its id: https://github.com/mas-cli/mas?tab=readme-ov-file#-app-ids

    # misc
    Speedtest = 1153157709;
    Bitwarden = 1352778147;
    "Googly Eyes" = 6743048714;
    WireGuard = 1451685025;
    "Home Assistant" = 1099568401;
    Gapplin = 768053424;
    #"Moe Memos" = 1643902185; # iPad app
    "Ice Cubes for Mastodon" = 6444915884;

    # apple
    Developer = 640199958;
    TestFlight = 899247664;

    # entertainment
    "CANAL+" = 694580816;
    # SubStreamer = 1012991665; # crashes

    # osm
    Avenue = 1523681067;
    "Go Map!!" = 592990211;

    # zsa keyboards
    keymapp = 6472865291;

    # iWork
    Numbers = 409203825;
    Pages = 409201541;
    Keynote = 409183694;

    # iLife
    iMovie = 408981434;

    # safari extensions
    SingleFile = 6444322545;
    UnTrap = 1637438059; # youtube
  };

  environment.systemPackages = with pkgs; [
    # gui apps
    appcleaner # unfree license
    audacity
    bruno
    cyberduck
    dbeaver-bin
    ghostty-bin
    # gimp # FIXME: broken
    grandperspective
    josm
    keepassxc
    keka # unfree license
    keycastr
    libreoffice-bin
    localsend
    mumble
    net-news-wire
    neovide
    numi # unfree license
    rectangle
    # rpi-imager # FIXME: broken
    sloth-app
    sqlitebrowser # gui for sqlite
    stats # stats in menbar
    telegram-desktop
    trgui-ng # transmission frontend
    unnaturalscrollwheels
    utm
    vlc-bin
    vscodium
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "appcleaner"
      "numi"
      "keka"
    ];

  # TODO: package https://github.com/AuroraWright/TomatoBar/releases
  # TODO: package https://github.com/terhechte/postsack/releases

}
