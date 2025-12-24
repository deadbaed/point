{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
}:

pkgs.mkShellNoCC {
  packages = [
    pkgs.npins
    pkgs.nix-output-monitor
  ];
}
