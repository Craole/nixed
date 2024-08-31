{
  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    rust.url = "github:oxalica/rust-overlay";
    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # flake-parts.url = "github:hercules-ci/flake-parts";
    # flake-root.url = "github:srid/flake-root";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      rust,
      treefmt,
    }:
    let
      modules = ./config;
      perSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                (import rust)
                (self: super: { toolchain = super.rust-bin.fromRustupToolchainFile "${modules}/toolchain.toml"; })
              ];
            };
          }
        );

      treefmtEval = perSystem (
        pkgs:
        treefmt.lib.evalModule pkgs {
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
        }
      );
    in
    {
      formatter = perSystem ({ pkgs }: treefmtEval.${pkgs.system}.config.build.wrapper);
      checks = perSystem (
        { pkgs }:
        {
          formatting = treefmtEval.${pkgs.system}.config.build.check self;
        }
      );

      devShells = perSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # Core
              toolchain
              openssl
              pkg-config
              cargo-watch
              cargo-edit
              cargo-generate

              # Tools
              dust
              eza
              fd
              helix
              helix-gpt
              ripgrep
              just
              direnv
              # treefmt
            ];

            shellHook = ''
              #/> Variables <\#
              export PRJ="$PWD"
              export DIRENV_LOG_FORMAT=""

              #/> Functions <\#
              eko(){ printf "%s\n\n" "$*";}
              h1(){ printf "\\033[1m|> %s <|\\033[0m\\n" "$*" ;}
              versions(){
                h1 "Versions"
                apps="rustc cargo hx"
                for app in $apps; do
                  "$app" --version
                done
              }

              aliases(){
                h1 "Aliases"
                alias | rg --color=never "alias [A-Z]="
              }

              project_info(){
                eko "$(versions)"
                eko "$(aliases)"
              }

              project_init(){
                h1 "Project"

                if [ -f Cargo.toml ]; then
                  PRJ="$(basename "$PWD")"
                  for file in Cargo.toml flake.nix; do
                    tmp="$(mktemp)"
                    sed -e "s|packages\.default = self'\.packages\.trust|packages\.default = self'\.packages\.$PRJ|" \
                      -e "s|^name = .*|name = \"$PRJ\"|" \
                      "$file" >"$tmp"
                    mv -- "$tmp" "$file"
                  done
                else
                  cargo init
                fi

                cargo run --release
              }

              #/> Aliases <\#
              alias A='cargo add'
              alias B='cargo build --release'
              alias C='cargo clean'
              alias D='dust --reverse'
              alias E='hx'
              alias F='treefmt'
              alias G='cargo generate'
              alias H='hx .'
              alias I='project_info'
              alias ls='eza --icons=always --almost-all --group-directories-first'
              alias L='ls --long'
              alias N='cargo new'
              alias Q='cargo watch --quiet --clear --exec "run --quiet --"'
              alias R='cargo run --release'
              alias S='cargo search'
              alias T='ls --tree'
              alias V='code .'
              alias W='cargo watch --quiet --clear --exec "run --"'
              alias X='cargo remove'

              #/> Initialize <\#
              project_info
              project_init
            '';
          };
        }
      );
    };
}
