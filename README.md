# nixed_rust

## Description

A modular Nix flake for setting up a Rust development environment. It allows users to set optional features, dependencies, IDEs, targets, and toolchains. The project takes a modular approach to reduce code length and maintain portability.

## Table of Contents

- [Description](#description)
- [Features](#features)
- [Dependencies](#dependencies)
- [Options](#options)
- [Usage](#usage)
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

### Optionional

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

### [config]()

The config directory contains subdirectories for overlays, options, and derivations.

### config/overlays

The overlays directory contains a rust-dev-env.nix file that imports options and overlays to set up a Rust development environment.

### Options

The options directory contains files for specifying options and information such as dependencies, IDEs, project information, targets, and toolchains.

### Derivations
The derivations directory contains Nix derivations for Cargo, rustc, rustfmt, rls, rust-analyzer, and any other modular derivations.

This will create a new directory for the Rust project, set up the dependencies, and initialize the project in a subfolder with the project name.

To customize the options, edit the files in the config/options directory. This allows users to set project information, dependencies, targets, and toolchains.

To add an IDE, edit the config/options/ide.nix file to include the desired IDE.
Conclusion

NixDev Rust is a modular and customizable

## Contributing

See [CONTRIBUTING.md](https://github.com/Craole/nixed_rust/blob/master/CONTRIBUTING.md).

## License

See [LICENSE.md](https://github.com/Craole/nixed_rust/blob/master/LICENSE.md).
