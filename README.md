# nixed_rust

## Description

A portable template for setting up a Rust development environment using nix, that allows users to set optional features, dependencies, IDEs, targets, and toolchains.

## Table of Contents

- [Description](#description)
- [Features](#features)
  - [Primary](#primary)
  - [Optional](#optional)
- [Dependencies](#dependencies)
- [Usage](#usage)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## Features

### Primary

- Allow users to set/enable optional features.
- Use flake-utils to maintain portability.
- Take a modular approach to reduce code length.
- Deploy using one command to run nix flake init and nix develop.
- Store options and information in a separate config file.
- Initialize rust project in a subfolder with the project name.
- Integrate with cargo.toml.

### Optional

- Set up an IDE with editing and formatting tools for rust, nix, and json files (e.g., vscode, helix, neovim, emacs).
- Allow users to set project information for the cargo.toml (e.g., name, version, authors).
- Allow users to set dependencies with optional feature flags in cargo.toml (e.g., cargo add serde --feature derive).
- Allow users to set targets (e.g., wasm).
- Allow users to set toolchain (e.g., nightly, beta).

## Dependencies

- nix

## Usage

```sh
#| Clone the repository.
project_name="nixed_rust"
git clone https://github.com/Craole/nixed_rust.git "$project_name"
cd "$project_name"

#| Initialize the flake
nix flake init

#| Enter a development environment for the flake:
nix develop
```

## Project Structure

```fd | as-tree
.
├── config
│   ├── overlays
│   │   └── rust.nix
│   ├── options
│   │   ├── dependencies.nix
│   │   ├── ide.nix
│   │   ├── gitignore.nix
│   │   ├── project.nix
│   │   ├── targets.nix
│   │   └── toolchain.nix
│   ├── derivations
│   │   ├── cargo.nix
│   │   ├── nixfmt.nix
│   │   ├── rust.nix
│   │   ├── rustfmt.nix
│   │   ├── rls.nix
│   │   └── rust-analyzer.nix
├── src
│   ├── modules
│   │   ├── mod1
│   │   │   ├── mod.rs
│   │   └── mod.rs
│   ├── libraries
│   │   ├── lib1
│   │   │   ├── mod.rs
│   │   └── mod.rs
│   └── main.rs
├── cargo.toml
└── flake.nix
```

|Path|Description|
|---|---|
|[./config](https://github.com/Craole/nixed_rust/tree/master/config)| Contains subdirectories for overlays, options, and derivations.|
|[./config/overlays](https://github.com/Craole/nixed_rust/tree/master/config/overlays)| Import options and overlays to set up a Rust development environment.
|[./config/options](https://github.com/Craole/nixed_rust/tree/master/config/options)| Specify options and information such as dependencies, IDE, project information, targets, and toolchains.
|[./config/derivations](https://github.com/Craole/nixed_rust/tree/master/config/derivations)| Nix derivations for Cargo, rustc, rustfmt, rls, rust-analyzer, and any other modular derivations.
|[./src](https://github.com/Craole/nixed_rust/tree/master/src)| Project directory.
|[./cargo.toml](https://github.com/Craole/nixed_rust/tree/master/cargo.toml)| Cargo.
|[./flake.nix](https://github.com/Craole/nixed_rust/tree/master/flake.nix)| Flake.

## Examples

See [EXAMPLES.md](CONTRIBUTING.md).

## Contributing

See [CONTRIBUTING.md](https://github.com/Craole/nixed_rust/blob/master/CONTRIBUTING.md).

## License

See [LICENSE.md](https://github.com/Craole/nixed_rust/blob/master/LICENSE.md).
