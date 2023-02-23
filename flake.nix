#DOC=================================================================<#
#@ Project Structure
#|   .
#|   ├── configuration
#|   │   └── default.nix
#|   └── flake.nix

#@ Project File
#| flake.nix
#>=================================================================<#

{
  description = "Dev Environment Flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: {
    configuration = flake-utils.lib.importDir ./configuration {
      inherit (flake-utils) lib;
      inherit (nixpkgs) pkgs;
    };
  };
}
