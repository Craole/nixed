# configuration/default.nix

{ utils }:

{
  packages = import ./packages/default.nix { inherit utils; };
  utilities = import ./utilities/default.nix { inherit utils; };
}
