{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      # Read the toolchain information from the config file
      config = builtins.fromTOML (builtins.readFile ./config.toml);
      toolchain = config.toolchain or "stable";
    in
    {
      # Define the Rust toolchain we want to use
      rustChannel = if toolchain == "beta" then "beta" else if toolchain == "nightly" then "nightly" else "stable";

      # Import the Rust package set from nixpkgs
      pkgs = import nixpkgs {
        inherit rustChannel;
      };

      # Define the Rust development environment
      shell = pkgs.mkShell {
        name = "rust-dev";
        buildInputs = with pkgs; [
          rustup
          rustc
          cargo
          clippy
          rust-analyzer
        ];
      };

      # Define the default package
      defaultPackage = pkgs.rustPlatform.buildRustPackage {
        name = "my-rust-project";
        src = ../environment/.;
        buildInputs = with pkgs; [
          rustup
          rustc
          cargo
          clippy
          rust-analyzer
        ];
      };
    };
}
