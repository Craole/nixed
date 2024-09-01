{
  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # rust.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      # rust,
    }:
    let
      perSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                (import rust)
                (self: super: { toolchain = super.rust-bin.fromRustupToolchainFile ./.config/toolchain.toml; })
              ];
            };
          }
        );
    in
    {
      devShells = perSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # Dependencies
              # openssl
              # pkg-config

              # Core
              # toolchain
              # cargo-watch
              # cargo-edit
              # cargo-generate

              # Tools
              dust
              bat
              eza
              pls
              fd
              helix
              helix-gpt
              ripgrep
              just
              direnv
              treefmt
              tokei

              # Formatters
              mdformat
              nodePackages.prettier
              shellcheck
              shfmt
              taplo
              yamlfmt
            ];

            shellHook = ''
              . ./.config/init.sh
            '';
          };
        }
      );
    };
}
