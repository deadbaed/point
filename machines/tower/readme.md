## initial build

requires npins >= 0.4

```shell
export CURRENT_NIXOS_CHANNEL=nixos-26.05
nixos-rebuild switch -I nixpkgs=$(npins get-path $CURRENT_NIXOS_CHANNEL) -I nixos-config=nixos/tower/configuration.nix
```

## other builds

regular `nixos-rebuild switch |& nom`
