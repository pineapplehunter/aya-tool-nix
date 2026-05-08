{
  description = "Flake providing aya-tool for building rust bpf packages";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs =
    { self, nixpkgs }:
    {
      overlays.default = final: prev: {
        aya-tool = final.callPackage ./aya-tool.nix { };
      };
      packages =
        nixpkgs.lib.genAttrs [ "aarch64-darwin" "aarch64-linux" "x86_64-darwin" "x86_64-linux" ]
          (
            system:
            let
              pkgs = import nixpkgs {
                inherit system;
                overlays = [ self.overlays.default ];
              };
            in
            {
              inherit (pkgs) aya-tool;
              default = pkgs.aya-tool;
            }
          );
    };

}
