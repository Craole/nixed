{
  description = "Rust Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      utils = import flake-utils {
        inherit inputs;
      };

      overlays = [ import ./config/overlays/rust-dev-env.nix ];

    in
      utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
          config = import ./config/options {};
          rustEnv = pkgs.mkShell {
            buildInputs = [
              pkgs.rust
              pkgs.cargo
              pkgs.rls
              pkgs.rustfmt
              pkgs.rust-analyzer
              # add other build inputs here
            ];
            # set environment variables here
          };
        in {
          devEnv = {
            buildInputs = [
              rustEnv
              pkgs.cacert
              # add other devEnv inputs here
            ];
            path = [ "devEnv" ];
          };
        }
      );
}
