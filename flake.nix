{
  description = "My Rust project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, rust-overlay, flake-utils }:
    let
      # Import the various modules
      options = import ./config/options.nix { inherit (self) inputs; };
      gitignore = import ./config/ignore.nix { inherit (options); };
      devShell = import ./config/devShell.nix { inherit (options nixpkgs rust-overlay); };
      vscode = import ./config/vscode.nix { inherit (options nixpkgs rust-overlay); };

      # Define the output types
      outputs = {
        defaultPackage = devShell;
        vscode = if options.ide == "vscode" then vscode else null;
        gitignore = gitignore;
      };
    in outputs;
}
