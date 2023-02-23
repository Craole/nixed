{ pkgs }:
let

  # Load configuration from config.toml
  config = builtins.parseTomlFile ./config.toml;

  # Define Rust overlay
  rust-overlay = pkgs.callPackage
    (builtins.fetchTarball {
      url = "https://github.com/oxalica/rust-overlay/archive/master.tar.gz";
    })
    { };

  # Set the Rust toolchain from config.toml
  rustChannel = config.toolchain.channel;
  rust = rust-overlay.rustChannels.${rustChannel};
  rustPackages = rust-overlay.rustPackageSet.${rustChannel};

in
{

  # Define default package
  defaultPackage = rustPackages.buildRustPackage {
    name = config.project.name;
    src = ./.;
    cargoSha256 = "TODO";
  };

  # Define overlays
  overlays = [
    rust-overlay
  ];

  # Define packages
  packages = [
    defaultPackage
  ];

  # Define tests
  tests = {
    mytest = {
      command = "${defaultPackage}/bin/mybinary --test";
      timeout = 60;
    };
  };

  # Define development shell
  devShell = with pkgs; mkShell {
    buildInputs = [
      rust
      rustPackages.cargo
      rustPackages.rustfmt
    ];
  };
}
