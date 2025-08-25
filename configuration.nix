{ self, config, pkgs, lib, inputs, ... }:
let
  username = "phil";
in
{
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

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
    "cog" # audio player
    "discord"
    "ungoogled-chromium"
    "firefox"
    "imageoptim" # compress images
    "jordanbaird-ice" # menubar
    "gauntlet" # raycast alternative
    "handbrake"
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
    # misc
    Speedtest = 1153157709;
    Bitwarden = 1352778147;
    "Googly Eyes" = 6743048714;
    WireGuard = 1451685025;
    "Home Assistant" = 1099568401;
    Gapplin = 768053424;

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
    JSONPeep = 1458969831;
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
