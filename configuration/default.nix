#DOC=================================================================<#
#@ Example Configuration
#|   This is an example configuration for the dev environment flake.
#|   It defines a package that installs the 'hello' program.
#|
#|   This configuration can be imported and used in any flake that depends on
#|   the 'dev-environment-flake'.
#>=================================================================<#

#DOC==========================================<#
#@ File Name: default.nix
#>============================================<#

{ pkgs }:

with pkgs;

let
  myPackage = stdenv.mkDerivation {
    name = "my-package";
    src = null;
    buildInputs = [ cowsay ];
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      echo "Hello, World!" | cowsay > $out/bin/hello
      chmod +x $out/bin/hello
    '';
  };
in
{
  default = myPackage;
}
