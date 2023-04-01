{
  description = "Rust Nightly Development Environment";
  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
      flake-utils.url = "github:numtide/flake-utils";
      rust-overlay.url = "github:oxalica/rust-overlay";
    };
  outputs =
    { self, nixpkgs, flake-utils, rust-overlay }:

    flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [
        (import rust-overlay)
        (self: super: {
          rustToolchain = super.rust-bin.fromRustupToolchainFile ./Rust.toml;
        })
      ];
      pkgs = import nixpkgs { inherit system overlays; };
    in
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          #/> Language-specific <\#
          rustToolchain
          # rust-analyzer
          # rust-analyzer-nightly
          rust-analyzer-unwrapped
          openssl
          pkg-config
          cargo-edit
          cargo-watch

          #/> Tools <\#
          exa
          fd
          ripgrep

          #/> Editor <\#
          vscode
          vscode-extensions.rust-lang.rust-analyzer-nightly
        ];

        shellHook = ''
          #/> Aliases <\#
          ls() {
            exa \
          	--icons \
          	--color-scale \
          	--header \
          	--no-user \
          	--git \
          	--group-directories-first \
          	--sort=.name \
          	"$@"
          }
          ll(){ ls --all --long "$@" ;}
          cR(){ cargo run --quiet ;}
          cW(){
            cargo watch \
              --quiet \
              --clear \
              --exec \
              "run --quiet --"
          }
          rV(){ rustc -vV ;}

          alias find="fd"
          alias grep="rg"

          #/> Autostart <\#
          # ${pkgs.rustToolchain}/bin/rustc -vV
          # ${pkgs.rustToolchain}/bin/cargo run --quiet
          rV && cR
        '';
      };
    });
}
