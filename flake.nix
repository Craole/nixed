{
  description = "Development Environment Templates";
  inputs = {
    NixOS.url = "github:NixOS/templates";
    The-Nix-Way.url = "github:the-nix-way/dev-templates";
  };

  outputs =
    {
      self,
      NixOS,
      The-Nix-Way,
      ...
    }:
    let
      templatesPath = ./templates;
    in
    {
      templates =
        NixOS.templates
        // The-Nix-Way.templates
        // {
          # Rust
          rust = {
            description = "Rust Development Environment";
            path = templatesPath + "/rust/default";
          };
          rust-mono = {
            description = "Rust Development Environment [Cargo Workspaces]";
            path = templatesPath + "/rust/workspaces";
          };
          rust-bi = {
            description = "Business Intelligence Stack [Rust, Pydantic, Polars, Plotters, Nom]";
            path = templatesPath + "/rust/pbi";
          };
          rust-ds = {
            description = "Business Intelligence Stack [Rust, Polars, Linfa, Plotters]";
            path = templatesPath + "/rust/data-sci";
          };
          rust-aas = {
            description = "Web Stack [Rust, Axum, Askama, SurrealDB ]";
            path = templatesPath + "/rust/raas";
          };
          rust-ats = {
            description = "Web Stack [Rust, Actix, Tera, SQLx]";
            path = templatesPath + "/rust/rats";
          };
          rust-leptos = {
            description = "Rust Web Development [Leptos]";
            path = templatesPath + "/rust/leptos";
          };
          rust-loco = {
            description = "Rust Web Development [LocoRS]";
            path = templatesPath + "/rust/loco";
          };

          # Ruby
          rails = {
            description = "Ruby on Rails";
            path = templatesPath + "/ruby/rails";
          };
        };
      defaultTemplate = self.templates.rust;
    };
}
