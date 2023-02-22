{ pkgs, rustOverlay, config }:

pkgs.mkShell
{
  buildInputs = [
    rustOverlay.override
    {
      packages = p: with p; [
        cargo
        rustc
        rust-analyzer
        (map depToNix config.options.dependencies)
      ];
    }
  ];
}

  # Helper function to convert a dependency listed in `config.toml` to its corresponding Nix package.
  depToNix
  dep = pkgs.callPackage (pkgs.fetchFromGitHub {
owner = "nix-community";
repo = "crates2nix";
rev = "42fdd1a1090b9ef9b14491db1f89e390eeb23d58";
sha256 = "1mx8sgz7cjg9j9hvh2szy4bw8cg1klwycxjqy4q7n3b3qapbb2ry";
}) {
cargoSha256 = pkgs.fetchurl {
url = "https://github.com/rust-lang/cargo/archive/${dep.toolchain}.tar.gz";
sha256 = dep.cargoSha256;
};
crate = dep.crate;
version = dep.version;
features = dep.features;
}
