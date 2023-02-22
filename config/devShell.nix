{ options, nixpkgs, rust-overlay, ... }:

let
  pkgs = import nixpkgs {
    overlays = [ rust-overlay.overlay ];
    config = {
      allowUnfree = true;
      packageOverrides = pkgs: {
        rust = options.rust.override {
          packages = p: with p; [
            rust-analyzer
            rust-src
          ];
        };
        cargo = options.rust.cargo.override {
          cargoSha256 = pkgs.fetchurl {
            url = "https://github.com/rust-lang/cargo/archive/${options.toolchain}.tar.gz";
            sha256 = "0hbj51kl57bjpqvp75bjc9d7mqmp0nnpzsyvkzmb8p6ywqxvxwv5";
          };
        };
      };
    };
  };

  devShell = pkgs.mkShell {
    buildInputs = with pkgs; [
      rust
      cargo
      clippy
      rustfmt
      (if options.ide == "vscode" then vscodeExtensions else null)
    ];
  };

  vscodeExtensions = [
    pkgs.vscode-extensions.rust-analyzer
  ];

in devShell
