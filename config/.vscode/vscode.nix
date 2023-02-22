{ pkgs, vscodeExtensions }:

{
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

  # Add Rust and TOML language-specific configuration
  languageConfig = {
    rust = {
      "rust-analyzer.enable" = true;
      "editor.formatOnSave" = true;
    };
    toml = {
      "editor.defaultFormatter" = "tamasfe.even-better-toml";
    };
  } // languageConfig // options.vscode;

  # Add Shell, Bash, Nix, and JSON language-specific configuration
  shellConfig = {
    "editor.formatOnSave" = true;
    "editor.formatOnType" = true;
    "editor.formatOnPaste" = true;
    "editor.formatOnSaveFilePattern" = "*.sh";
    "editor.defaultFormatter" = "foxundermoon.shell-format";
  };
  bashConfig = {
    "editor.formatOnSave" = true;
    "editor.formatOnType" = true;
    "editor.formatOnPaste" = true;
    "editor.formatOnSaveFilePattern" = "*.bash";
    "editor.defaultFormatter" = "foxundermoon.shell-format";
  };
  nixConfig = {
    "editor.formatOnSave" = true;
    "editor.formatOnType" = true;
    "editor.formatOnPaste" = true;
    "editor.formatOnSaveFilePattern" = "*.nix";
  };
  jsonConfig = {
    "editor.defaultFormatter" = "vscode.json-language-features";
  };
  options.vscode = {
    "language.shellscript" = shellConfig;
    "language.bash" = bashConfig;
    "language.nix" = nixConfig;
    "language.json" = jsonConfig;
  };
}
