{
  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nur.url = "github:nix-community/NUR";
    rust.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      rust,
    }:
    let
      forEachSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                (import rust)
                (self: super: { rustToolchain = super.rust-bin.fromRustupToolchainFile ./rust-toolchain; })
              ];
            };
          }
        );
    in
    {
      devShells = forEachSystem (
        { pkgs }:
        {
          default = pkgs.mkShellNoCC { packages = [ pkgs.nur.repos.liyangau.case-cli ]; };
        }
      );
    };
}
