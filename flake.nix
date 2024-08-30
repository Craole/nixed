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
  description = "Development Environment Templates";
  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # devenv.url = "github:cachix/devenv/latest";
    templates_NixOS.url = "github:NixOS/templates";
    templates_nix-way.url = "github:the-nix-way/dev-templates";
  };

  outputs =
    {
      self,
      # nixpkgs,
      # devenv,
      templates_NixOS,
      templates_nix-way,
      ...
    }:
    {
      templates = {
        cc-rails = {
          path = ./export/rails;
          description = "Ruby on Rails";
        };
        cc-rust = {
          path = ./export/rust;
          description = "Rust Development Environment";
        };
        cc-rust-leptos = {
          path = ./export/rust_leptos;
          description = "Rust Web Development Environment [Nightly, Leptos], using fenix";
        };
        cc-rustpaces = {
          path = ./export/rust_workspaces;
          description = "Rust Development Environment [Nightly] [Cargo Workspaces], using fenix";
        };
        cc-rustly = {
          path = ./export/rustly;
          description = "Rust Development Environment [Nightly]";
        };
        cc-rust_plus = {
          path = ./export/rust_plus;
          description = "Rust Development Environment";
        };
      } // templates_NixOS.templates // templates_nix-way.templates;
      defaultTemplate = self.templates.cc-rust;
    };
}
