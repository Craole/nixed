{ pkgs, ... }:

let
  #@ nixpkgs-fmt
  nixpkgsFmt = pkgs.nixpkgs-fmt;

  #@ rustc
  rustc = pkgs.rustc;

  #@ shellcheck
  shellcheck = pkgs.shellcheck;

in
[
  nixpkgsFmt
  rustc
  shellcheck
]
