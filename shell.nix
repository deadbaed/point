{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
}:

pkgs.mkShellNoCC {
  packages = with pkgs; [
    npins
    nix-output-monitor
    git
  ];
}
