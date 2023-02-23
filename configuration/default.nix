{ pkgs, ... }:

let
  utils = import ./utils.nix { inherit (pkgs) runCommand; };
in
{
  # Your module definition here, using the utils module
}
