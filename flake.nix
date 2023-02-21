# flake.nix

{
  description = "Nix develop template for Rust";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: {

    devShell = flake-utils.lib.eachDefaultSystem (system:

      let
        pkgs = nixpkgs.legacyPackages.${system};
        rustNightly = pkgs.rustChannels.nightly;
        rustAnalyzer = pkgs.rust-analyzer;
        vscode = pkgs.vscode;
      in

      with pkgs; {
        name = "rust-dev-${system}";

        buildInputs = [
          rustNightly
          rustAnalyzer
          vscode
        ];

        shellHook = ''
          export RUSTFLAGS="-C target-cpu=native"
          export CARGO_HOME="${PWD}/.cargo"
        '';

        nativeBuildInputs = [
          pkgs.cargo
        ];

        cargoBuildInputs = [
          rustNightly
          rustAnalyzer
        ];

        cargoInputs = [
          pkgs.cargo
        ];

        cargoEnv = {
          CARGO_HOME = "${PWD}/.cargo";
        };

        features = {
          inherit system pkgs rustNightly;
          default = {
            project = { name = "my-project"; };
            toolchain = { channel = "nightly"; };
            targets = [ "wasm32-unknown-unknown" ];
            crates = [ "my-crate" ];
          };
        };

        defaultPackage = with pkgs; {
          name = features.project.name;
          buildInputs = [
            rustNightly
            rustAnalyzer
            cargo
          ];

          phases = [ "buildPhase" ];

          buildPhase = ''
            export RUSTFLAGS="-C target-cpu=native"
            export CARGO_HOME="${PWD}/.cargo"
            cargo init
            cargo install cargo-edit

            for crate in ${features.crates}; do
              cargo add $crate
            done
          '';
        };
      }
    );
  };
}
