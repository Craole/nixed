#!/bin/sh
# shellcheck disable=SC2034

#/> Functions <\#
print_block() { printf "%s\n\n" "$*"; }
print_status() {
  unset app icon dep err
  while [ "$#" -gt 0 ]; do
    case "$1" in
    --success) icon="🟢" ;;
    --failure) icon="🔴" ;;
    --app) [ "$2" ] && app="$2" ;;
    --dependency) [ "$2" ] && dep="$2" ;;
    --error) [ "$2" ] && err="$2" ;;
    esac
    shift
  done

  [ "$app" ] && printf "%s %s\n" "$icon" "$app"
  [ "$dep" ] && printf "$(tput setaf 1)Missing dependency: $(tput sgr0)%s\n" "$dep" >&2
  [ "$err" ] && printf "$(tput setaf 1)Error: %s$(tput sgr0)\n" "$err" >&2
}
print_heading() { printf "|> %s <|\n" "$*"; }
app_available() {
  command -v "$1" >/dev/null 2>&1
}

versions() {
  apps="rustc cargo dust just ls code tokei hx treefmt"
  for app in $apps; do
    if app_available "$app"; then
      print_status --success --app "$app"
    else
      print_status --failure --app "$app"
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
    print_status --error "Failed to determine the project root (either a Flake or Git repository)"
    return 1
  fi
}

project_info() {
  print_heading "Tools"
  print_block "$(versions)"

  print_heading "Aliases"
  print_block "$(aliases)"

  PRJ_INFO=$(find -L "$PRJ_ROOT" -maxdepth 1 -iname "readme*" | head -n1)
}

project_init() {
  print_heading "Project"
  app_available cargo || {
    print_status \
      --error "Initialization failed" \
      --dependency "cargo"
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

project_update() {
  app_available nix && nix flake update
  app_available cargo && cargo update
  app_available geet && geet --push
}

create_file() {
  while [ "$#" -gt 0 ]; do
    case "$1" in
    */*) mkdir --parents "$(dirname "$1")" ;;
    esac

    touch "$1"

    shift
  done
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
PRJ_READ="${PRJ_ROOT}/docs"
DIRENV_LOG_FORMAT=""
set +o allexport

#/> Aliases <\#
if app_available pls; then
  alias ls='pls --almost-all --group-directories-first --color=always'
elif app_available eza; then
  alias ls='eza --almost-all --group-directories-first --color=always --icons=always'
  alias L='ls --long --git --git-ignore'
  alias La='ls --long --git'
  alias Lt='L --tree'
elif app_available lsd; then
  alias ls='lsd --almost-all --group-directories-first --color=always'
  alias L='ls --long --git --date=relative --hyperlink=auto --versionsort --total-size'
  alias Lt='L --tree'
else
  alias ls='ls --almost-all --group-directories-first --color=always'
  alias L='ls -l'
  alias Lt='L --recursive'
fi
app_available bat && alias cat='bat --style=plain'

app_available cargo && alias A='cargo add'
app_available cargo && alias B='cargo build --release'
app_available cargo && alias C='cargo clean'
app_available dust && alias D='dust --reverse'
app_available hx && alias E='hx'
app_available treefmt && alias F='treefmt --tree-root="$PRJ_ROOT" --config-file "$PRJ_CONF/treefmt.toml" --allow-missing-formatter --ci'
app_available cargo && alias G='cargo generate'
app_available hx && alias H='hx "$PRJ_ROOT"'
alias I='project_init'
app_available just && alias J='just'
alias K='exit'
alias M='mkdir --parents'
app_available cargo && alias N='cargo new'
app_available cargo && alias O='cargo outdated'
alias P='project_info'
app_available cargo && alias Q='cargo watch --quiet --clear --exec "run --quiet --"'
app_available cargo && alias R='cargo run --release'
app_available cargo && alias S='cargo search'
alias T='create_file'
alias U='project_update'
app_available code && alias V='code "$PRJ_ROOT"'
app_available cargo && alias W='cargo watch --quiet --clear --exec "run --"'
app_available cargo && alias X='cargo remove'
alias Y='cat "$PRJ_INFO"'
alias Z='tokei'

#/> Initialize <\#
project_info
project_init
