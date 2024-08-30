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
              just
              direnv
            ];

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
              alias A='cargo add'
              alias B='cargo build --release'
              alias C='cargo clean'
              alias F='treefmt'
              alias N='cargo new'
              alias Q='cargo watch --quiet --clear --exec "run --quiet --"'
              alias R='cargo run'
              alias W='cargo watch --quiet --clear --exec "run --"'
              alias X='cargo remove'

              #/> Information <\#
              rustc --version
              cargo --version
              alias
            '';
          };
        }
      );
    };
}
