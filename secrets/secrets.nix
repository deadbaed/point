# This secrets.nix file is not imported into your Nix configuration.
# It's only used for the agenix CLI tool to know which public keys to use for encryption.
let
  pubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIGEAHLWZNYMD3rFX3lyEyuKOSXEFsk+Sx+gPcGPW1IH";
  config = {
    publicKeys = [ pubkey ];
    armor = true;
  };
  secretNames = [ "wakapi-api" ];
in
builtins.listToAttrs (
  map (path: {
    name = "${path}.age";
    value = config;
  }) secretNames
)
