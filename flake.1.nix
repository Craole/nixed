{
  description = "A devShell example";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          buildInputs = [
            openssl
            pkg-config
            exa
            fd
            # rust-bin.stable.latest.default
            rust-bin.nightly."2023-02-05".default
            # rust-bin.beta.latest.default
            # rust-bin.selectLatestNightlyWith (toolchain: toolchain.default) # or `toolchain.minimal`
            # cargo-binstall
            cargo-generate
            cargo-watch
            cargo-deps
            cargo-limit
            cargo-update
          ];

          shellHook = ''
            alias ls="exa --all --color-scale --icons"
            alias find=fd
          '';
        };
      }
    );
}
