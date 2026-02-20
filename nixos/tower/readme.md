## initial build

requires npins >= 0.4

```shell
nixos-rebuild switch -I nixpkgs=$(npins get-path nixpkgs) -I nixos-config=nixos/tower/configuration.nix
```

## other builds

regular `nixos-rebuild switch |& nom`
