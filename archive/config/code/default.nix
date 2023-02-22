{ pkgs, options, ... }:

let
  vscode = import ./vscode.nix { inherit pkgs options; };

in with pkgs; {

  environment.systemPackages = [
    vscode
    # any other system packages you need
  ];

  home.file.".vscode/extensions.json".source = ./extensions.json;
  home.file.".config/Code/User/settings.json".source = ./settings.json;

}
