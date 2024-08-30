{
  description = "Rust Nightly Development Environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    rust.url = "github:oxalica/rust-overlay";
  };
  outputs =
    {
      self,
      nixpkgs, systems,
      rust,
    }:
    
    let
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [
          (import rust-overlay)
          (self: super: { rustToolchain = super.rust-bin.fromRustupToolchainFile ./rust-toolchain; })
        ];
        pkgs = import nixpkgs { inherit system overlays; };
      in
      {
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
            alias Cw='cargo watch --quiet --clear --exec "run --"'
            alias Cwq='cargo watch --quiet --clear --exec "run --quiet --"'

            #/> Autostart <\#
            [ -f Cargo.toml ] || cargo init
            rustc -vV
            type Ca
            type Cx
            type Cr
            type Cb
            type Cw
            type Cwq
          '';
        };
      }
    );
}
