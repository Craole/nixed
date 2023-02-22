{ pkgs ? import <nixpkgs> { } }:
let
  vscodeExtensions = import ./extensions.nix { inherit pkgs; };
  vscodeConfig = import ./vscode.nix { inherit pkgs vscodeExtensions; };
in
pkgs.vscode.override {
  extensions = vscodeExtensions;
  config = vscodeConfig;
}
