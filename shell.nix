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

    # lsps
    luajitPackages.lua-lsp
    vscode-langservers-extracted # html,css,json,eslint
    nixd
  ];
  env = {
    NPINS_DIRECTORY = "${builtins.getEnv "HOME"}/point/npins";
  };
}
