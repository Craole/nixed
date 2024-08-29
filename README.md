# nixed - Nix Template Flakes

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
#| Current Poject
nix flake init --template github:Craole/nixed#${ENV}

#| New Project
nix flake new --template github:Craole/nixed#${ENV} ${NEW_PRJ_DIR}
```

Here's an example for the Rust Nightly template ([`trust`](./templates/trust))

```shell
# Current Poject
nix flake init --template github:Craole/nixed#trust

# New Project
nix flake new --template github:Craole/nixed#trust ${NEW_PRJ_DIR}
```

## How to use the templates

Once your preferred template has been initialized, you can use the provided shell in two ways:

1. If [`nix-direnv`](nix-direnv) is installed, it may be used to initialize the environment via `direnv allow`.
2. Otherwise, running `nix develop` will also initialize the environment.
