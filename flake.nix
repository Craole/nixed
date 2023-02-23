{
  description = "My Nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      configuration = import ./configuration;
    in
    {
      # Use your module here
      outputs = { self, nixpkgs, configuration }: { };
    };
}
