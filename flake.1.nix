{
  description = "My Flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      config = pkgs.config.fromTOML ./configuration/config.toml;
      packages = import ./configuration/packages.nix { inherit pkgs config; };
      crates = import ./configuration/crates.nix { inherit pkgs config; };
    in
    {
      defaultPackage = myProgram;
    }
  );
}
