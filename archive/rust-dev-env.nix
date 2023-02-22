self: super:
{
  rust-dev-env = super.rust-dev-env // {
    config = {
      ide = super.rust-dev-env.config.ide or "vscode";
      targets = super.rust-dev-env.config.targets or [ "wasm32-unknown-unknown" ];
      toolchain = super.rust-dev-env.config.toolchain or "stable";
      crates = super.rust-dev-env.config.crates or [ "serde" "features" "derive" ];
      # add other configuration options here
    };
  };
}
