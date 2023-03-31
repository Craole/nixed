{
  description = "A Nix-flake-based Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-22.11";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , rust-overlay
    }:

    flake-utils.lib.eachDefaultSystem (system:
    let
      overlays = [
        (import rust-overlay)
        (self: super: {
          rustToolchain =
            let
              rust = super.rust-bin;
            in
            if builtins.pathExists ./rust-toolchain.toml then
              rust.fromRustupToolchainFile ./rust-toolchain.toml
            else if builtins.pathExists ./rust-toolchain then
              rust.fromRustupToolchainFile ./rust-toolchain
            else
              rust.stable.latest.default;
        })
      ];

      pkgs = import nixpkgs { inherit system overlays; };
    in
    {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          rustToolchain
          rust-analyzer
          openssl
          pkg-config
          cargo-edit
          cargo-watch
          exa
          fd
          ripgrep
        ];

        shellHook = ''
          ${pkgs.rustToolchain}/bin/cargo init
          ${pkgs.rustToolchain}/bin/rustc -vV

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
          alias find=fd
          alias grep=rg
          alias ll="ls --all --long"
        '';
      };
    });
}
