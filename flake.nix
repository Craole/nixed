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
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: {
    utils = builtins.getFlake flake-utils;
    configuration = utils.lib.importDir ./configuration {
      inherit utils;
    };
  };
}
