sudo darwin-rebuild switch \
	-I darwin-config=./configuration.nix \
	-I nixpkgs=$(npins get-path nixpkgs) \
	-I darwin=$(npins get-path nix-darwin) \
	-I home-manager=$(npins get-path home-manager) \
	-I catppuccin-bat=$(npins get-path catppuccin-bat) \
	-I catppuccin-delta=$(npins get-path catppuccin-delta) \
	--show-trace
