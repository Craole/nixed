# default.nix

{
  rustToolchain = "nightly";
  name = "myproject";
  targets = ["native" "wasm32-unknown-unknown"];
  crates = ["serde" "mycrate2"];
}
