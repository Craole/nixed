{ pkgs }:

{
  someVariable = "Hello, world!";
  someFunction = arg: pkgs.runCommand "someFunction" { } ''
    echo ${arg} > $out
  '';
}
