{ pkgs, ... }:

let
  # Configure rustfmt to format Rust code
  rustFmt = {
    extension = "rs";
    cmd = "${pkgs.rustfmt}/bin/rustfmt";
    args = [
      "--edition=2021"
      "--config=join_imports=true",
      "--config=merge_imports=true",
      "--config=reorder_imports=true",
      "--config=normalize_comments=true",
      "--config=normalize_doc_attributes=true",
      "--config=normalize_macros=true",
    ];
  };

  # Configure shfmt to format Shell code
  shFmt = {
    extension = "sh";
    cmd = "${pkgs.shfmt}/bin/shfmt";
    args = [
      "-i"
      "2"
      "-ci"
      "-bn"
      "-sr"
      "-kp"
      "-s"
      "-d"
    ];
  };

  # Configure prettier to format JSON code
  jsonFmt = {
    extension = "json";
    cmd = "${pkgs.prettier}/bin/prettier";
    args = [
      "--write",
      "--parser",
      "json"
    ];
  };

in
[
  rustFmt
  shFmt
  jsonFmt
]
