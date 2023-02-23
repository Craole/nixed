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
  inputs = { };

  outputs = { self, nixpkgs }: {
    utils = nixpkgs.flake-utils;
    configuration = utils.lib.importDir ./configuration {
      inherit utils;
    };
  };
}
