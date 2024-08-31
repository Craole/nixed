#!/bin/sh
# shellcheck disable=SC2034

#/> Functions <\#
print_block() { printf "%s\n\n" "$*"; }
print_error() {
  case "$1" in
  --dependency)
    printf "$(tput setaf 1)Missing dependency: $(tput sgr0)%s\\n" "$2" >&2
    ;;
  --app)
    printf "$(tput setaf 1)Y $(tput sgr0)%s\n" "$2" >&2
    ;;
  *)
    printf "$(tput setaf 1)%s$(tput sgr0)\\n" "$*" >&2
    ;;
  esac
}
print_success() {
  case "$1" in
  --app)
    printf "$(tput setaf 2)N $(tput sgr0)%s\\n" "$2"
    ;;
  *)
    printf "$(tput setaf 2)%s$(tput sgr0)\\n" "$*"
    ;;
  esac
}
print_heading() { printf "|> %s <|\n" "$*"; }

versions() {
  apps="rustc cargo hx"
  for app in $apps; do
    if command -v "$app" >/dev/null 2>&1; then
      # "$app" --version
      print_success --app "$app"
    else
      print_error --app "$app"
    fi
  done
}

aliases() {
  alias | grep "alias [A-Z]="
}

project_root() {
  #? Check if the current directory or any parent directory has a flake.nix file
  dir="$PWD"
  while [ "$dir" != "/" ]; do
    if [ -f "$dir/flake.nix" ]; then
      printf "%s" "$dir"
      return
    fi
    dir=$(dirname "$dir")
  done

  #? If flake.nix is not found, check if the current directory or any parent directory is a Git repository
  if git rev-parse --show-toplevel >/dev/null 2>&1; then
    git rev-parse --show-toplevel
  else
    #? If not a Git repository, print an error message and exit
    print_error "Error: Failed to determine the project root (either a Flake or Git repository)\n"
    return 1
  fi
}

project_info() {
  print_heading "Tools" && print_block "$(versions)"
  print_heading "Aliases" && print_block "$(aliases)"
}

project_init() {
  print_heading "Project"
  command -v cargo >/dev/null 2>&1 || {
    print_error --dependency "cargo"
    return 1
  }
  if [ -f Cargo.toml ]; then
    tmp="$(mktemp)"
    file="$PRJ_ROOT/Cargo.toml"
    sed "s|^name = .*|name = \"$PRJ_NAME\"|" "$file" >"$tmp"
    mv -- "$tmp" "$file"
  else
    cargo init
  fi

  [ -f "$PRJ_ROOT/.cargo/config.toml" ] || {
    mkdir --parents "$PRJ_ROOT/.cargo"
    ln --symbolic \
      "$PRJ_CONF/cargo.toml" \
      "$PRJ_ROOT/.cargo/config.toml"
  }

  cargo run --release
}

fmt() {
  treefmt \
    --tree-root="$PRJ_ROOT" \
    --config-file "$PRJ_ROOT/config/treefmt.toml" \
    --allow-missing-formatter \
    --ci
}

#/> Variables <\#
set -o allexport
PRJ_ROOT="$(project_root)"
PRJ_CONF="${PRJ_ROOT}/config"
PRJ_NAME="$(basename "${PRJ_ROOT}")"
DIRENV_LOG_FORMAT=""
set +o allexport
# export DIRENV_LOG_FORMAT PRJ_ROOT PRJ_CONF PRJ_NAME

#/> Aliases <\#
alias A='cargo add'
alias B='cargo build --release'
alias C='cargo clean'
alias D='dust --reverse'
alias E='hx'
alias F='fmt'
alias G='cargo generate'
alias H='hx .'
alias I='project_info'
alias ls='eza --icons=always --almost-all --group-directories-first'
alias L='ls --long'
alias N='cargo new'
alias Q='cargo watch --quiet --clear --exec "run --quiet --"'
alias R='cargo run --release'
alias S='cargo search'
alias T='ls --tree'
alias V='code .'
alias W='cargo watch --quiet --clear --exec "run --"'
alias X='cargo remove'
alias treefmt='treefmt --config-file "$PRJ_ROOT/config/treefmt.toml" --tree-root="$PRJ_ROOT"'

#/> Initialize <\#
project_info
project_init
