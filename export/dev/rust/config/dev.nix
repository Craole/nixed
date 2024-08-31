{ pkgs, toolchain, ... }:
{
  default = pkgs.mkShell {
    packages = with pkgs; [
      # Core
      toolchain
      openssl
      pkg-config
      cargo-watch
      cargo-edit
      cargo-generate

      # Tools
      dust
      eza
      pls
      fd
      helix
      helix-gpt
      ripgrep
      just
      direnv
      treefmt
      tokei

      # Formatters
      mdformat
      nodePackages.prettier
      shellcheck
      shfmt
      taplo
      yamlfmt
    ];

    shellHook = ''
      [ -f ./init ] && . ./init
    '';
  };
}
