#DOC==========================================<#
#@ Project Structure
#|   .
#|   ├── configuration
#|   │   ├── default.nix
#|   │   └── devShell.nix
#|   └── flake.nix

#@ Project File
#| flake.nix
#>============================================<#

{
  description = "Development Environment";
  inputs = {
    official-templates.url = github:NixOS/templates;
  };

  outputs = { self, official-templates, ... }: {
    templates = {
      rust-fenix = {
        path = ./templates/rust_fenix;
        description = "Rust Development Environment [Nightly], using fenix";
      };
      rust-hello = {
        path = ./templates/rust_hello;
        description = "Simple Hello World in Rust";
      };
    }
    // official-templates.templates;
  };
}
