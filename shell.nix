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
  env = {
    NPINS_DIRECTORY = "${builtins.getEnv "HOME"}/point/npins";
  };
}
