{ config, pkgs, ... }:

let

  vscode = pkgs.vscode-extensions.buildVscodeExtension {
    name = "vscode";
    src = ./.;
    outputDir = "out";
    sourceRoot = ./.;
    extensionRoot = ./.;
    vscodeVersion = "${config.vscode.version}";
    publisher = "my-organization";
    displayName = "My IDE";
    extensionId = "my-ide";
  };

in
{

  environment.systemPackages = with pkgs; [
    vscode
  ];

  # Configure the default language options, formatters and linters for various file types
  services.vscode-extensions = {
    enable = true;
    extensions = {
      "dbaeumer.vscode-eslint" = {
        version = "2.1.28";
        settings = {
          "editor.formatOnSave" = true;
          "[javascript]" = {
            "editor.formatOnSave" = false;
          };
          "[javascriptreact]" = {
            "editor.formatOnSave" = false;
          };
          "[typescript]" = {
            "editor.formatOnSave" = false;
          };
          "[typescriptreact]" = {
            "editor.formatOnSave" = false;
          };
        };
      };
      "timonwong.shellcheck" = {
        version = "0.12.0";
      };
      "foxundermoon.shell-format" = {
        version = "1.5.5";
      };
      "tamasfe.even-better-toml" = {
        version = "0.2.2";
      };
      "esbenp.prettier-vscode" = {
        version = "6.1.1";
        settings = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;
          "[json]" = {
            "editor.defaultFormatter" = "esbenp.prettier-vscode";
          };
        };
      };
      "nix-community.vscode-nix-linter" = {
        version = "0.0.18";
      };
      "matklad.rust-analyzer" = {
        version = "0.1.0";
      };
      "pkief.material-icon-theme" = {
        version = "4.6.0";
      };
      "equinusocio.vsc-material-theme" = {
        version = "3.10.0";
      };
    };
  };

}
