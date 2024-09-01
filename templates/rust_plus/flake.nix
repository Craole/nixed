{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    rust-flake = {
      url = "github:juspay/rust-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    cargo-doc-live.url = "github:srid/cargo-doc-live";
    treefmt-nix.url = "github:numtide/treefmt-nix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = with inputs; [
        treefmt-nix.flakeModule
        rust-flake.flakeModules.default
        rust-flake.flakeModules.nixpkgs
        process-compose-flake.flakeModule
        cargo-doc-live.flakeModule
      ];
      perSystem =
        {
          config,
          self',
          pkgs,
          lib,
          ...
        }:
        {
          treefmt.config = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              rustfmt.enable = true;
              taplo.enable = true;
              yamlfmt.enable = true;
              mdformat.enable = true;
              shfmt.enable = true;
              shellcheck.enable = true;
              prettier.enable = true;
            };
            settings.formatter = {
              mdformat = {
                includes = [
                  "*.md"
                  "LICENSE"
                  "README"
                ];
              };
              shfmt = {
                includes = [
                  "*.sh"
                  "justfile"
                ];
              };
              taplo = {
                includes = [
                  "*.toml"
                  "rust-toolchain"
                ];
              };
            };
          };

          devShells.default = pkgs.mkShell {
            inputsFrom = [
              self'.devShells.rust
              config.treefmt.build.devShell
            ];

            packages =
              [ config.process-compose.cargo-doc-live.outputs.package ]
              ++ (with pkgs; [
                cargo-watch
                dust
                eza
                just
                direnv
              ]);

            shellHook = ''
              #/> Project Name <\#
              PRJ="$(basename "$PWD")"
              for file in Cargo.toml flake.nix; do
                tmp="$(mktemp)"
                sed -e "s|packages\.default = self'\.packages\.trust|packages\.default = self'\.packages\.$PRJ|" \
                  -e "s|^name = .*|name = \"$PRJ\"|" \
                  "$file" >"$tmp"
                mv -- "$tmp" "$file"
              done

              #/> Variables <\#
              export PRJ="$PWD"
              export DIRENV_LOG_FORMAT=""

              #/> Aliases <\#
              alias Ca='cargo add'
              alias Cx='cargo remove'
              alias Cr='cargo run'
              alias Cb='cargo build --release'
              alias Cw='cargo watch --quiet --clear --exec "run --"'
              alias Cq='cargo watch --quiet --clear --exec "run --quiet --"'
              alias Cc='cargo clean'
              alias Fmt='treefmt'

              #/> Information <\#
              rustc --version
              cargo --version
              alias
            '';
          };
          packages.default = self'.packages.trust;
        };
    };
}
