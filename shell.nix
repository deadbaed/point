{
  sources ? import ./npins,
  pkgs ? import sources.nixpkgs { },
}:

pkgs.mkShellNoCC {
  packages = with pkgs; [
    npins
    nix-output-monitor
    git
    nixfmt
    nixfmt-tree
    nixd
  ];
  env = {
    NPINS_DIRECTORY = "${builtins.getEnv "HOME"}/point/npins";
  };
}
