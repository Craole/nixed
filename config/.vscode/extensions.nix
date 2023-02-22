{ pkgs, ... }:

let
  vscodeExtensions = pkgs.vscode-extensions.overrideAttrs (oldAttrs: {
    extensions = oldAttrs.extensions ++ [
      { publisher = "PKief"; extensionId = "material-icon-theme"; version = "4.4.1"; }
      { publisher = "Equinusocio"; extensionId = "material-theme"; version = "3.9.7"; }
    ];
  });

  extensions = [
    { publisher = "matklad"; extensionId = "rust-analyzer"; }
    { publisher = "tamasfe"; extensionId = "even-better-toml"; }
    { publisher = "foxundermoon"; extensionId = "shell-format"; }
    { publisher = "timonwong"; extensionId = "shellcheck"; }
  ];

  languageConfig = {
    rust = {
      "rust-analyzer.enable" = true;
      "editor.formatOnSave" = true;
    };
    toml = {
      "editor.defaultFormatter" = "tamasfe.even-better-toml";
    };
    shellscript = {
      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.formatOnPaste" = true;
      "editor.formatOnSaveFilePattern" = "*.sh";
      "editor.defaultFormatter" = "foxundermoon.shell-format";
    };
    bash = {
      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.formatOnPaste" = true;
      "editor.formatOnSaveFilePattern" = "*.bash";
      "editor.defaultFormatter" = "foxundermoon.shell-format";
    };
    nix = {
      "editor.formatOnSave" = true;
      "editor.formatOnType" = true;
      "editor.formatOnPaste" = true;
      "editor.formatOnSaveFilePattern" = "*.nix";
    };
    json = {
      "editor.defaultFormatter" = "vscode.json-language-features";
    };
  };

in
vscodeExtensions.override {
  configuration = {
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.colorTheme" = "Material Darker";
    "editor.rulers" = [ 80 ];
    "files.exclude" = {
      "**/.git" = true;
      "**/.DS_Store" = true;
      "**/*.o" = true;
      "**/*.d" = true;
      "**/*.rmeta" = true;
      "**/target/" = true;
    };
    "git.enableSmartCommit" = true;
    "telemetry.enableCrashReporter" = false;
    "telemetry.enableTelemetry" = false;
    "files.associations" = {
      "*.sh" = "shellscript";
      "*.bash" = "bash";
      "*.nix" = "nix";
      "*.rs" = "rust";
      "*.json" = "json";
      "*.toml" = "toml";
    };
  } // languageConfig // options.vscode;
}
