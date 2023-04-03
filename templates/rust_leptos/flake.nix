{
  description = "Rust Nightly Development Environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };
  outputs =
    { self
    , nixpkgs
    , flake-utils
    , rust-overlay
    ,
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [
        (import rust-overlay)
        (self: super: {
          rustToolchain = super.rust-bin.fromRustupToolchainFile ./rust-toolchain;
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
          openssl
          pkg-config
          cargo-edit
          cargo-watch
          cargo-generate

          #/> Tools <\#
          exa
          fd
          ripgrep
          helix
          sass
          grass-sass
        ];

        shellHook = ''
          #/> Aliases <\#
          alias ls='exa \
          	--icons \
          	--color-scale \
          	--header \
          	--no-user \
          	--git \
          	--group-directories-first \
            --all \
            --long \
          	--sort=.name
          '
          alias cI='cargo install'
          alias cR='cargo run --quiet'
          alias cW='cargo leptos watch'

          #/> Autostart <\#
          # Check if cargo-leptos is already installed
          cargo leptos -h &> /dev/null || cargo install cargo-leptos

          # Launch the development browser
          firefox http://localhost:3000/

          # Check if cargo-leptos is already installed
          cargo leptos watch
        '';
      };
    });
}
