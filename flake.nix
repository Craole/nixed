{
  description = "My simple flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs = { self, nixpkgs }: {
    defaultPackage = self.overlay {
      # Import the default.nix file from the configuration directory
      configuration = import ./configuration { inherit (nixpkgs) pkgs; };
    };
  };
}
