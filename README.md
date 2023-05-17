# nixed - Nix flake templates for Development

[![built with nix](https://builtwithnix.org/badge.svg)](https://builtwithnix.org)

## The Templates
This is an amalgamtion of templates from several sources including my own derivations:

- [The Nix Way - Dev Templates](https://github.com/the-nix-way/dev-templates)
- [NixOS Templates](https://github.com/NixOS/templates)
- [Nixed](./templates)

List all available templates using:

```sh
nix flake show github:Craole/nixed
```

## Initialization

To initialize (where `${ENV}` is listed in the table below):

```sh
# Current Poject
nix flake init --template github:Craole/nixed#${ENV}

# New Project
nix flake new --template github:Craole/nixed#${ENV} ${NEW_PROJECT_DIRECTORY}
```

Here's an example for the Rust Nightly template ([`rustly`](./templates/rustly))

```shell
# Current Poject
nix flake init --template github:Craole/nixed#rustly

# New Project
nix flake new --template github:Craole/nixed#rust ${NEW_PROJECT_DIRECTORY}
```

## How to use the templates

Once your preferred template has been initialized, you can use the provided shell in two ways:

1. If you have [`nix-direnv`][nix-direnv] installed, you can initialize the environment by running `direnv allow`.
2. If you don't have `nix-direnv` installed, you can run `nix develop` to open up the Nix-defined shell.
