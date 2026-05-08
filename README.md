# aya-tool-nix

Nix flake providing [aya-tool](https://github.com/aya-rs/aya) — a command-line utility for generating Rust bindings for Linux kernel types in eBPF programs.

## About

[Aya](https://github.com/aya-rs/aya) is a pure Rust library for writing eBPF programs. This flake packages `aya-tool`, which generates Rust bindings for kernel types using bpftool.

## Flake Outputs

| Output | Description |
|--------|-------------|
| `packages.default` | The `aya-tool` package (v0.13.1) |
| `overlays.default` | Nixpkgs overlay adding `aya-tool` |

Supported systems: `x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, `aarch64-darwin`

## Usage

### As a Flake Input

Add to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    aya-tool-nix.url = "github:pineapplehunter/aya-tool-nix";
  };

  outputs = { nixpkgs, aya-tool-nix, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ aya-tool-nix.overlays.default ];
      };
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        packages = [ pkgs.aya-tool ];
      };
    };
}
```

### Using the Overlay

```nix
{
  nixpkgs.overlays = [ (import ./path/to/aya-tool-nix).overlays.default ];
}
```

Then use `pkgs.aya-tool` in your configuration.

### Running Directly

```bash
nix run "github:pineapplehunter/aya-tool-nix"
```

Or locally:

```bash
nix run
```

### Building the Package

```bash
nix build
./result/bin/aya-tool --help
```

## Example: Generate Kernel Type Bindings

```bash
nix run -- generate task_struct > src/vmlinux.rs
```

This generates Rust bindings for `task_struct` that can be used in Aya eBPF programs.
