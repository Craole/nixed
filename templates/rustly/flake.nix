{
  description = "Rust Nightly Development Environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [
        (import rust-overlay)
        (self: super: {
          rustToolchain = super.rust-bin.fromRustupToolchainFile ./rust-toolchain;
        })
      ];
      pkgs = import nixpkgs {inherit system overlays;};
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          rustToolchain
          openssl
          pkg-config
          cargo-edit
          cargo-watch
          cargo-generate
        ];

        shellHook = ''
          #/> Aliases <\#
          alias Ca='cargo add'
          alias Cx='cargo remove'
          alias Cr='cargo run'
          alias Cb='cargo build'
          alias Cw='cargo watch --quiet --clear --exec "run --quiet --"'

          #/> Autostart <\#
          [ -f Cargo.toml ] || cargo init
          rustc -vV
          type Ca
          type Cx
          type Cr
          type Cb
          type Cw
        '';
      };
    });
}
