{
  description = "Flake providing aya-tool for building rust bpf packages";

  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

  outputs =
    { self, nixpkgs }:
    {
      overlays.default = final: prev: {
        aya-tool-unwrapped = final.callPackage ./aya-tool/unwrapped.nix { };
        aya-tool = final.callPackage ./aya-tool/default.nix { };
      };
      packages =
        nixpkgs.lib.genAttrs
          [
            "aarch64-darwin"
            "aarch64-linux"
            "x86_64-darwin"
            "x86_64-linux"
          ]
          (
            system:
            let
              pkgs = import nixpkgs {
                inherit system;
                overlays = [ self.overlays.default ];
              };
            in
            {
              inherit (pkgs) aya-tool aya-tool-unwrapped;
              default = pkgs.aya-tool;
            }
          );
    };

}
