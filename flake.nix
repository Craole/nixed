#DOC=================================================================<#
#@ Project Structure
#|   .
#|   ├── configuration
#|   │   └── default.nix
#|   └── flake.nix

#@ Project File
#| flake.nix
#>=================================================================<#

# {
#   description = "Dev Environment Flake";
#   inputs = {
#     nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
#     flake-utils.url = "github:numtide/flake-utils";
#   };

#   outputs = { self, nixpkgs, flake-utils }:
#     let
#       utils = flake-utils.lib;
#     in
#     {
#       utils = utils;
#       configuration = utils.importDir ./configuration {
#         inherit utils;
#       };
#     };
# }

{
  description = "My Nix development environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        configuration = import ./configuration { inherit pkgs; };
      in
      { defaultPackage.${system} = configuration; }
    );
}
