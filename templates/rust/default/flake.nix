{

  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    rust.url = "github:oxalica/rust-overlay";
  };

  outputs =
    { nixpkgs, ... }:
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
          containsItem = dir: builtins.any (item: builtins.pathExists (dir + "/${item}")) itemList;

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
                builtins.pathExists (dir + "/${name}") && builtins.isAttrs (builtins.readDir (dir + "/${name}"))
              ) (builtins.attrNames (builtins.readDir dir));
              found = builtins.filter containsItem (map (subdir: dir + "/${subdir}") subdirs);
            in
            if found != [ ] then
              builtins.head found
            else
              builtins.any (subdir: searchDown (dir + "/${subdir}")) subdirs;

          result = if direction == "up" then searchUp base else searchDown base;
        in
        # base;
        # if containsItem base then base else "no";
        result;

      configPath = locateDir {
        base = ./config;
        direction = "down";
        items = [
          "toolchain.toml"
          "init.sh"
        ];
      };

      # Define your path here
      # configPath = ./. + "/config";

      # Debugging output
      debugConfigPath = builtins.trace "configPath is: ${configPath}" configPath;
      debugToolchainPath = builtins.trace "toolchain path is: ${debugConfigPath}/toolchain.toml" "${debugConfigPath}/toolchain.toml";
    in
    {
      defaultPackage.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.stdenv.mkDerivation {
        pname = "debug-path";
        version = "1.0";

        buildInputs = [ ];

        installPhase = ''
          mkdir -p $out
          # echo "configPath is: ${debugConfigPath}" > $out/debug.txt
          # echo "toolchain path is: ${debugToolchainPath}" >> $out/debug.txt
        '';
      };
    };
}
