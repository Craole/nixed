{
  description = "A Nix-flake-based Ruby development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [ ruby_3_3 libyaml postgresql ];

          shellHook = ''
            # | Ensure that Bundler installs gems in the current directory
            export BUNDLE_PATH=./.bundle
            export RUBY_BIN="./.bundle/ruby/3.3.0/bin/"
            export PATH=$RUBY_BIN:$PATH

            # | Check for Gemfile and run bundle install if necessary
            [ -f Gemfile ] && bundle install

            # | Validate installation
            ruby --version
            postgres --version
            rails --version
          '';
        };
      });
}
