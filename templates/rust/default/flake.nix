{

  inputs = {
    systems.url = "github:nix-systems/default";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    rust.url = "github:oxalica/rust-overlay";
  };

  outputs = { nixpkgs, ... }:
  let
    # Define your path here
    configPath = ./.config;

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
        echo "configPath is: ${debugConfigPath}" > $out/debug.txt
        echo "toolchain path is: ${debugToolchainPath}" >> $out/debug.txt
      '';
    };
  };
}
