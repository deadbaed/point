## initial build

```shell
nix-build -E 'let
     np = import ./npins/default.nix;
     nixpkgs = (np."nixpkgs-26.05-darwin" {}).outPath;
     nix-darwin = (np.nix-darwin {}).outPath;
   in import nix-darwin { inherit nixpkgs; }' -I darwin-config=/Users/phil/point/machines/darwin/configuration-small.nix
```

```shell
sudo ./result-5/activate
```


## other builds

```shell
sudo darwin-rebuild switch
```
