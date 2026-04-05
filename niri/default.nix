{
  sources ? import ../npins,
  pkgs ? import sources.nixpkgs { },
  config,
}:
{
  imports = [
    (import ./noctalia-shell.nix { inherit sources pkgs config; })
  ];

  home.packages = with pkgs; [
    niri
    xwayland-satellite
    xdg-desktop-portal
    xdg-desktop-portal-wlr
  ];
  services.polkit-gnome.enable = true;
  services.playerctld.enable = true;

  # niri config (symlink to wait less)
  xdg.configFile."niri/config.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/point/niri/config.kdl";

  # cursors
  gtk.enable = true;
  home.pointerCursor = {
    enable = true;
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };
}
