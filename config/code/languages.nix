{ pkgs }:

let
  # List of language extensions and servers to install for Rust
  rustLang = {
    extensions = [
      "rust-analyzer"
    ];
    servers = [
      pkgs.rls
    ];
  };

  # List of language extensions and servers to install for Nix
  nixLang = {
    extensions = [
      "nix-language-server"
    ];
    servers = [
      pkgs.nix-language-server
    ];
  };

  # List of language extensions and servers to install for Shell
  shellLang = {
    extensions = [
      "shell-format"
      "shellcheck"
    ];
    servers = [ ];
  };

  # List of language extensions and servers to install for JSON
  jsonLang = {
    extensions = [ ];
    servers = [ ];
  };

  # List of language extensions and servers to install for TOML
  tomlLang = {
    extensions = [
      "even-better-toml"
    ];
    servers = [ ];
  };

in
{
  rust = rustLang;
  nix = nixLang;
  shell = shellLang;
  json = jsonLang;
  toml = tomlLang;
}
