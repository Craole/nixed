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
      locateDir =
        {
          base ? ./.,
          direction ? "down",
          items,
        }:

        let
          #| Validate the direction parameter
          _ =
            if direction != "up" && direction != "down" then
              throw "Invalid direction: must be 'up' or 'down'"
            else
              null;

          #| Ensure items is a list
          itemList = if builtins.isList items then items else [ items ];

          #| Function to check if a directory contains any of the target items
          containsItem = dir: builtins.any (item: builtins.pathExists (dir + "/" + item)) itemList;

          # Recursive function to search upwards in the directory tree
          searchUp =
            dir:
            if containsItem dir then
              dir
            else
              let
                parent = builtins.dirOf dir;
              in
              if parent == dir then null else searchUp parent;

          # Recursive function to search downwards in the directory tree
          searchDown =
            dir:
            let
              subdirs = builtins.filter (
                name:
                builtins.pathExists (dir + "/" + name) && builtins.isAttrs (builtins.readDir (dir + "/" + name))
              ) (builtins.attrNames (builtins.readDir dir));
              # subdirs = builtins.filter builtins.isDirectory (builtins.attrNames (builtins.readDir dir));
              found = builtins.filter containsItem (map (subdir: dir + "/" + subdir) subdirs);
            in
            if found != [ ] then
              builtins.head found
            else
              builtins.any (subdir: searchDown (dir + "/" + subdir)) subdirs;

        in
        if direction == "up" then searchUp base else searchDown base;

      # configPath = ./.config;
      configPath = locateDir {
        base = ./.;
        direction = "down";
        items = [
          "toolchain.toml"
          "init.sh"
        ];
      };

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
                  toolchain = super.rust-bin.fromRustupToolchainFile  (builtins.trace configPath "${configPath}/toolchain.toml");
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
