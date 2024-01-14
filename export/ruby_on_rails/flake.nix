{
  description = "A Nix-flake-based Ruby development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [
        (self: super: {
          ruby = super.ruby_3_3;
        })
      ];
      pkgs = import nixpkgs {inherit overlays system;};
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          ruby
          libyaml
        ];

        shellHook = ''
          # ${pkgs.ruby}/bin/ruby --version
          [ -f Cargo.toml ] || ${pkgs.ruby}/bin/bundle install

          alias R='bin/rails'
          alias Rss='binrails server s'
        '';
      };
    });
}
