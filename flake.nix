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
    devenv.url = "github:cachix/devenv/latest";
    templates_NixOS.url = github:NixOS/templates;
    templates_nix-way.url = "github:the-nix-way/dev-templates";
  };

  outputs = { self, devenv, templates_NixOS, templates_nix-way, ... }: {
    templates = {
      rust-fenix = {
        path = ./templates/rust_fenix;
        description = "Rust Development Environment [Nightly]";
      };
      rust-leptos = {
        path = ./templates/rust_leptos;
        description = "Rust Web Development Environment [Nightly, Leptos], using fenix";
      };
      rust-workspaces = {
        path = ./templates/rust_workspaces;
        description = "Rust Development Environment [Nightly] [Cargo Workspaces], using fenix";
      };
    }
    // templates_NixOS.templates
    // templates_nix-way.templates;
  };
}
