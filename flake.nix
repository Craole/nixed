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
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    devenv.url = "github:cachix/devenv/latest";
    templates_NixOS.url = "github:NixOS/templates";
    templates_nix-way.url = "github:the-nix-way/dev-templates";
  };

  outputs =
    {
      # self,
      # nixpkgs,
      # devenv,
      templates_NixOS,
      templates_nix-way,
      ...
    }:
    {
      templates = {
        rubyrails = {
          path = ./export/ruby_on_rails;
          description = "Ruby on Rails";
        };
        rustos = {
          path = ./export/rust_leptos;
          description = "Rust Web Development Environment [Nightly, Leptos], using fenix";
        };
        rusties = {
          path = ./export/rust_workspaces;
          description = "Rust Development Environment [Nightly] [Cargo Workspaces], using fenix";
        };
        rustly = {
          path = ./export/rustly;
          description = "Rust Development Environment [Nightly]";
        };
        trust = {
          path = ./export/trust;
          description = "Rust Development Environment";
        };
      } // templates_NixOS.templates // templates_nix-way.templates;
    };
}
