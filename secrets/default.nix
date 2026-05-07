{
  sources ? import ../npins,
  pkgs ? import sources.nixpkgs { },
  config,
  agenix ? sources.agenix,
}:
let
  agenixBin = pkgs.callPackage "${agenix}/pkgs/agenix.nix" { };
  privateKey = "${config.home.homeDirectory}/.ssh/id_agenix";
in
{
  imports = [
    "${agenix}/modules/age-home.nix"
  ];

  age.identityPaths = [ privateKey ];

  home.packages = [
    agenixBin # encrypt secrets
    (pkgs.writeShellScriptBin "agenix-encrypt" ''
      ${pkgs.lib.getExe' agenixBin "agenix"} -e "$1" -i ${privateKey}
    '')
  ];
}
