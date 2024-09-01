{
  description = "Development Environment Templates";
  inputs = {
    templates_NixOS.url = "github:NixOS/templates";
    templates_nix-way.url = "github:the-nix-way/dev-templates";
  };

  outputs =
    {
      self,
      templates_NixOS,
      templates_nix-way,
      ...
    }:
    {
      templates = {
        dev-rust = {
          description = "Rust Development Environment";
          path = ./export/dev/rust;
        };
        dev-rust-plus = {
          description = "Rust Development Environment";
          path = ./export/dev/rust_plus;
        };
        dev-rust-mono = {
          path = ./export/rust/rust_workspaces;
          description = "Rust Development Environment [Nightly] [Cargo Workspaces], using fenix";
        };
        web-rails = {
          path = ./export/web/rails;
          description = "Ruby on Rails";
        };
        web-raas = {
          description = "Rust Web Development [Rust, Axum, Askama, SurrealDB]";
          path = ./export/web/rust_asa;
        };
        web-leptos  ={
          description = "Rust Web Development [Rust, Axum, Askama, SurrealDB]";
          path = ./export/web/leptos;
        };
      } // templates_NixOS.templates // templates_nix-way.templates;
      defaultTemplate = self.templates.cc-rust;
    };
}
