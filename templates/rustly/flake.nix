{
  description = "Rust Nightly Development Environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      overlays = [
        (import rust-overlay)
        (self: super: {
          rustToolchain = super.rust-bin.fromRustupToolchainFile ./rust-toolchain;
        })
      ];
      pkgs = import nixpkgs {inherit system overlays;};
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          #/> Language-specific <\#
          rustToolchain
          rust-analyzer
          # rust-analyzer-nightly
          # rust-analyzer-unwrapped
          openssl
          pkg-config
          cargo-edit
          cargo-watch

          #/> Tools <\#
          exa
          fd
          ripgrep

          #/> Editor <\#
          (vscode-with-extensions.override {
            vscodeExtensions = with vscode-extensions;
              [
                #| Rust
                rust-lang.rust-analyzer
                serayuzgur.crates

                #| TOML
                tamasfe.even-better-toml

                #| ShellScript
                timonwong.shellcheck

                #| Nix
                kamadorueda.alejandra
                jnoortheen.nix-ide
                bbenoist.nix
                mkhl.direnv

                #| Web Development
                bradlc.vscode-tailwindcss

                #| Settings
                vadimcn.vscode-lldb
                formulahendry.code-runner
                vscode-icons-team.vscode-icons
                ms-vscode-remote.remote-ssh
              ]
              ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                {
                  name = "remote-ssh-edit";
                  publisher = "ms-vscode-remote";
                  version = "0.47.2";
                  sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
                }
              ];
          })
        ];

        shellHook = ''
          #/> Aliases <\#
          alias ls='exa \
          	--icons \
          	--color-scale \
          	--header \
          	--no-user \
          	--git \
          	--group-directories-first \
            --all \
            --long \
          	--sort=.name
          '
          alias ll='ls --all --long'
          alias cR='cargo run --quiet'
          alias cW='cargo watch \
              --quiet \
              --clear \
              --exec \
              "run --quiet --"
          '
          alias rV='rustc -vV'
          alias codeEdit='code .'
          alias find="fd"
          alias grep="rg"

          #/> Autostart <\#
          rV && cR
        '';
      };
    });
}
