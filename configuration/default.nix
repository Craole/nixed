#DOC=================================================================<#
#@ Example Configuration
#|   This is an example configuration for the dev environment flake.
#|   It defines a package that installs the 'hello' program.
#|
#|   This configuration can be imported and used in any flake that depends on
#|   the 'dev-environment-flake'.
#>=================================================================<#

# { pkgs }:

# let
#   inherit (pkgs) stdenv;
# in

# stdenv.mkDerivation {
#   name = "hello";
#   src = pkgs.fetchurl {
#     url = "http://ftp.gnu.org/gnu/hello/hello-2.10.tar.gz";
#     sha256 = "1m4d09wx20c0krmxzp07jy1xq9q3q2ai2smj1aw7s6ajb96d72cr";
#   };
#   buildInputs = [ pkgs.gnumake ];
#   installPhase = ''
#     make install prefix=$out
#   '';
# }
