{ inputs, ... }:

let
  config = inputs.config.toml;
in
{
  rust = inputs.rust-overlay.rust;
  target = config.project.target or "x86_64-unknown-linux-gnu";
  packages = config.options.dependencies or [];
  packageSet = inputs.nixpkgs;
  ide = config.options.ide or "none";
  toolchain = config.options.toolchain or "nightly";
}
