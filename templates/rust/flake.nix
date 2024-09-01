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
      # configPath = ./.config;

    let
      locateDir = rootPath: possible_children: search_direction: let
        check = file: builtins.pathExists (path + "/" + file);
      in
        if check "toolchain.toml" && check "init.sh" then
          path
        else
          builtins.throw "Configuration path not found";

      configPath = locateSubdir ./.;

      perSystem =
        f:
        nixpkgs.lib.genAttrs (import systems) (
          system:
          f {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
                (import rust)
                (self: super: {
                  toolchain = super.rust-bin.fromRustupToolchainFile "${configPath}/toolchain.toml";
                })
                # (self: super: { toolchain = super.rust-bin.fromRustupToolchainFile ./.config/toolchain.toml; })
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
              # Dependencies
              openssl
              pkg-config

              # Core
              toolchain
              cargo-watch
              cargo-edit
              cargo-generate

              # Utilities
              bat
              direnv
              dust
              eza
              fd
              helix
              just
              pls
              ripgrep
              tokei
              trashy
              treefmt

              # Formatters
              mdformat
              nodePackages.prettier
              shellcheck
              shfmt
              taplo
              yamlfmt
            ];

            shellHook = ''
              . ${configPath}/init.sh
            '';
          };
        }
      );
    };
}
