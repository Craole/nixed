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
      perSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                (import rust)
                (self: super: { rustToolchain = super.rust-bin.fromRustupToolchainFile ./config/toolchain.toml; })
              ];
            };
          }
        );
    in
    {
      devShells = perSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # Core
              rustToolchain
              openssl
              pkg-config
              cargo-watch
              cargo-edit
              cargo-generate

              # Tools
              dust
              eza
              pls
              fd
              helix
              helix-gpt
              ripgrep
              just
              direnv
              treefmt
              tokei

              # Formatters
              mdformat
              nodePackages.prettier
              shellcheck
              shfmt
              taplo
              yamlfmt
            ];

            shellHook = ''
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

              project_root() {
                  # Check if the current directory or any parent directory is a Git repository
                  if git rev-parse --show-toplevel > /dev/null 2>&1; then
                      git rev-parse --show-toplevel
                  else
                      # If not a Git repository, search upward for a flake.nix file
                      dir="$PWD"
                      while [ "$dir" != "/" ]; do
                          if [ -f "$dir/flake.nix" ]; then
                              printf "%s" "$dir"
                              return
                          fi
                          dir=$(dirname "$dir")
                      done

                      # If flake.nix is not found, print an error message and exit
                      echo "Error: Could not find project root (either a Git repository or flake.nix)" >&2
                      return 1
                  fi
              }

              project_info(){
                eko "$(versions)"
                eko "$(aliases)"
              }

              project_init(){
                h1 "Project"

                if [ -f Cargo.toml ]; then
                  for file in Cargo.toml flake.nix; do
                    prj="$(basename "$(project_root)")"
                    tmp="$(mktemp)"
                    sed -e "s|packages\.default = self'\.packages\.trust|packages\.default = self'\.packages\.$prj|" \
                      -e "s|^name = .*|name = \"$prj\"|" \
                      "$file" >"$tmp"
                    mv -- "$tmp" "$file"
                  done
                else
                  cargo init
                fi

                cargo run --release
              }

              fmt(){
                treefmt \
                  --tree-root="$PRJ_ROOT" \
                  --config-file "$PRJ_ROOT/config/treefmt.toml" \
                  --allow-missing-formatter \
                  --ci
              }

              #/> Variables <\#
              export DIRENV_LOG_FORMAT=""
              export PRJ_ROOT="$(project_root)"

              #/> Aliases <\#
              alias A='cargo add'
              alias B='cargo build --release'
              alias C='cargo clean'
              alias D='dust --reverse'
              alias E='hx'
              alias F='fmt'
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
              alias treefmt='treefmt --config-file "$PRJ_ROOT/config/treefmt.toml" --tree-root="$PRJ_ROOT"'

              #/> Initialize <\#
              project_info
              project_init
            '';
          };
        }
      );
    };
}
