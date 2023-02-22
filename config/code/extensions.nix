{ pkgs, ... }:

let
  extensions = [
    #@ even-better-toml
    {
      name = "even-better-toml";
      publisher = "tamasfe";
    }

    #@ rust-analyzer
    {
      name = "rust-analyzer";
      publisher = "matklad";
    }

    #@ shell-format
    {
      name = "shell-format";
      publisher = "foxundermoon";
    }

    #@ shellcheck
    {
      name = "shellcheck";
      publisher = "timonwong";
    }

    #@ material theme
    {
      name = "material-theme";
      publisher = "Equinusocio";
    }

    #@ material icon theme
    {
      name = "material-icon-theme";
      publisher = "PKief";
    }

    #@ prettier
    {
      name = "prettier";
      publisher = "esbenp";
    }
  ];

  getExtension = ext: pkgs.vscode-extensions.fetchFromGitHub {
    inherit (ext) name publisher;
    rev = ext.rev or null;
    sha256 = ext.sha256 or null;
  };

in
{
  extensions = lib.mapAttrsToList getExtension extensions;
}
