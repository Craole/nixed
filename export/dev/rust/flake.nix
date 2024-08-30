{
  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    rust.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      self,
      nixpkgs,
      systems,
      rust,
    }:
    let
      forEachSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                (import rust)
                (self: super: { rustToolchain = super.rust-bin.fromRustupToolchainFile ./rust-toolchain; })
              ];
            };
          }
        );
    in
    {
      devShells = forEachSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # Core
              rustToolchain
              openssl
              pkg-config

              # Tools
              cargo-watch
              cargo-edit
              cargo-generate
              dust
              eza
              fd
              helix
              helix-gpt
              ripgrep
              just
              direnv
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
                rustc --version
                cargo --version
                hx --version
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
