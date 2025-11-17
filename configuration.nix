{ self, config, pkgs, lib, inputs, ... }:
let
  username = "phil";
  tilesize = 30;
in
{
  nix = {
    optimise.automatic = true;
    settings = {
      trusted-users = [ username ];
      # Necessary for using flakes on this system.
      experimental-features = "nix-command flakes";

      # Additional binary caches
      substituters = [
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };
  };

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = self.rev or self.dirtyRev or null;

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
    finder = {
      ShowHardDrivesOnDesktop = true;
      ShowPathbar = true;
    };

    dock = {
      tilesize = tilesize;
      magnification = true;
      largesize = tilesize * 3;
      show-recents = false;
      persistent-others = [ "/Applications/" "/Users/${username}/Downloads"];
    };
    menuExtraClock.ShowSeconds = true;

    NSGlobalDomain = {
      AppleShowAllFiles = true;
      AppleShowAllExtensions = true;
    };
  };

  # homebrew
  homebrew.enable = true;
  environment.systemPath = [ config.homebrew.brewPrefix ]; # add homebew to PATH
  homebrew.brews = [ # formulae
    "mas" # mac app store, https://github.com/mas-cli/mas
    "imagesnap" # catpure images from webcam
  ];
  homebrew.casks = [ # graphical apps
    "background-music" # control sound of individual apps
    "calibre" # epub
    "cog-app" # audio player
    "discord"
    "ungoogled-chromium"
    "firefox"
    "imageoptim" # compress images
    "inkscape"
    "jordanbaird-ice" # menubar
    "gauntlet" # raycast alternative
    "ghostty"
    "handbrake-app"
    "keepassxc"
    "lulu" # firewall
    "nextcloud"
    "nheko"
    "obs"
    "openmtp" # android file transfer
    "orion" # test web browser
    "paintbrush" # simple image editor
    "pinta"
    "pocket-casts"
    "raycast"
    "spotify"
    "signal"
    "steam"
    "tor-browser"
    "transmission" # until nixpkgs has mac gui
    "veracrypt"
    "whatsapp"
  ];
  homebrew.masApps = { # mac app store apps
    # To find the app name with its id: https://github.com/mas-cli/mas?tab=readme-ov-file#-app-ids

    # misc
    Speedtest = 1153157709;
    Bitwarden = 1352778147;
    "Googly Eyes" = 6743048714;
    WireGuard = 1451685025;
    "Home Assistant" = 1099568401;
    Gapplin = 768053424;
    #"Moe Memos" = 1643902185; # iPad app
    "Mona for Mastodon" = 1659154653;

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
    Pages   = 409201541;
    Keynote = 409183694;

    # iLife
    iMovie = 408981434;

    # safari extensions
    SingleFile = 6444322545;
    UnTrap = 1637438059; # youtube
  };

  environment.systemPackages = with pkgs; [
    vim

    # gui apps
    appcleaner # unfree license
    audacity
    bruno
    cyberduck
    dbeaver-bin
    # gimp3 # FIXME: broken
    grandperspective
    josm
    # keepassxc # FIXME: broken
    keka # unfree license
    keycastr
    libreoffice-bin
    localsend
    # mumble # TODO: wait for https://github.com/NixOS/nixpkgs/pull/384691
    net-news-wire
    # nheko # FIXME: broken
    numi # unfree license
    rectangle
    # rpi-imager # FIXME: broken
    sloth-app
    sqlitebrowser # gui for sqlite
    stats # stats in menbar
    telegram-desktop
    unnaturalscrollwheels
    utm
    vlc-bin
    vscodium
    zed-editor
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "appcleaner"
      "numi"
      "keka"
    ];

  # TODO: package https://github.com/AuroraWright/TomatoBar/releases
  # TODO: package https://github.com/terhechte/postsack/releases
  # TODO: package https://github.com/openscopeproject/TrguiNG

}
