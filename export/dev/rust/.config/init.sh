#!/bin/sh
# shellcheck disable=SC2034

helpers_init() {
  print_block() {
    printf "%s\n\n" "$*"
  }

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
    [ "$dep" ] && {
      tput setaf 1
      printf "Missing dependency: " >&2
      tput sgr0
      printf "%s\n" "$dep" >&2
    }
    [ "$err" ] && {
      tput setaf 1
      printf "Error: %s\n" "$err" >&2
      tput sgr0
    }
  }

  print_heading() {
    tput setaf 4
    printf "|> %s <|\n" "$*"
    tput sgr0
  }

  app_available() {
    command -v "$1" >/dev/null 2>&1
  }

  pathof_flake_or_git() {
    #? Check if the current directory or any parent directory has a flake.nix file
    dir="$PWD"
    while [ "$dir" != "/" ]; do
      if [ -f "$dir/flake.nix" ]; then
        printf "%s" "$dir"
        return 0
      fi
      dir=$(dirname "$dir")
    done

    #? In the unlikely event that this is not a Flake, check if the current directory or any parent directory is a Git repository
    if git rev-parse --show-toplevel >/dev/null 2>&1; then
      git rev-parse --show-toplevel
    else
      #? If not a Git repository, print an error message and exit
      print_status --error "Failed to determine the project root (either a Flake or Git repository)"
      return 2
    fi
  }

  create_file() {
    while [ "$#" -gt 0 ]; do

      #? Create the parent directory if it doesn't exist
      case "$1" in
      */*) mkdir --parents "$(dirname "$1")" ;;
      esac

      #? Create the file
      touch "$1"

      shift
    done
  }

  find_first() {
    search_root="$PRJ_ROOT"
    search_depth=2
    search_type="file"

    while [ "$#" -gt 0 ]; do
      case "$1" in
      --path) [ "$2" ] && search_root=$2 ;;
      --target) [ "$2" ] && search_target="$2" ;;
      --depth) [ "$2" ] && search_depth="$2" ;;
      --type) search_type="$2" ;;
      *) search_target="$1" ;;
      esac
      shift
    done

    search_type="${search_type%"${search_type#?}"}"

    find \
      -L "$search_root" \
      -maxdepth "$search_depth" \
      -type "$search_type" \
      -iname "$search_target" |
      head -n1
  }
}

project_info() {

  variables() {
    #@ Variables @#
    #| Project Root Directory
    set -o allexport
    if pathof_flake_or_git >/dev/null 2>&1; then
      PRJ_ROOT="$(pathof_flake_or_git)"
    else
      pathof_flake_or_git
      return "$?"
    fi

    #| Project Config Directory
    PRJ_CONF="$(dirname "$(find_first --target "init*")")"

    #| Project Readme
    PRJ_INFO=$(find_first --target "readme*")

    #| Project Name
    PRJ_NAME="$(basename "$PRJ_ROOT")"

    #| Direnv Log Format
    app_available direnv && DIRENV_LOG_FORMAT=""
    
    set +o allexport

    print_heading "Variables"
    print_block "$(
      for var in PRJ_NAME PRJ_ROOT PRJ_CONF PRJ_INFO; do
        eval "val=\$$var"
        [ -n "$val" ] && printf '%s=%s\n' "$var" "$val"
      done
    )"
  }

  aliases() {
    #@ Aliases @#
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
    if [ -f "$PRJ_INFO" ]; then
      alias Y='cat "$PRJ_INFO"'
    else
      alias Y='project_info'
    fi
    alias Z='tokei'

    print_heading "Aliases"
    print_block "$(alias | grep "alias [A-Z]=")"
  }

  utilities() {
    print_heading "Utilities"
    print_block "$(
      apps="cargo code dust hx just rustc tokei treefmt"
      for app in $apps; do
        if app_available "$app"; then
          print_status --success --app "$app"
        else
          print_status --failure --app "$app"
        fi
      done
    )"
  }

  variables || return "$?"
  aliases
  utilities
}

project_init() {
  print_heading "Project"
  app_available cargo || {
    print_status \
      --error "Initialization failed" \
      --dependency "cargo"
    return 127
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

main() {
  helpers_init
  project_info || return "$?"
  project_init || return "$?"
} && main "$@"
