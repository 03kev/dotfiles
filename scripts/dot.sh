#!/usr/bin/env bash
set -euo pipefail

DOT="${DOTFILES_DIR:-$HOME/.dotfiles}"
SRC="$DOT/home"

APPLY=0
MERGE_EXISTING_DIRS=0
CONFLICTS_ONLY=0
HAD_CONFLICTS=0
PLANNED_DIRS=""

usage() {
  cat >&2 <<'EOF'
Usage:
  dot plan [--merge-existing-dirs]
  dot apply [--merge-existing-dirs]
  dot conflicts [--merge-existing-dirs]
  dot add <path-in-home>
  dot adopt <path-in-home>
  dot replace <path-in-home>

Default policy:
  - never remove or overwrite existing files
  - never symlink ~/.config itself
  - link ~/.config children one by one
  - treat existing real directories as conflicts unless --merge-existing-dirs is used
EOF
  exit 1
}

exists() {
  [[ -e "$1" || -L "$1" ]]
}

home_label() {
  local p="$1"
  if [[ "$p" == "$HOME" ]]; then
    printf "~"
  elif [[ "$p" == "$HOME/"* ]]; then
    printf "~/%s" "${p#"$HOME/"}"
  else
    printf "%s" "$p"
  fi
}

rel() {
  local p="$1"
  [[ "$p" = /* ]] || p="$HOME/$p"
  [[ "$p" == "$HOME/"* ]] || {
    echo "dot: must be under \$HOME: $p" >&2
    exit 1
  }
  echo "${p#"$HOME/"}"
}

is_ignored() {
  local r="$1"
  case "$r" in
    ".DS_Store"|*"/.DS_Store"|".zsh/selected_theme") return 0 ;;
    *) return 1 ;;
  esac
}

emit() {
  local kind="$1"
  shift

  if [[ "$CONFLICTS_ONLY" -eq 1 && "$kind" != "conflict" ]]; then
    return 0
  fi

  printf "dot: %s %s\n" "$kind" "$*"
}

conflict() {
  HAD_CONFLICTS=1
  emit "conflict" "$@"
}

backup_path() {
  local r="$1"
  local dst="$HOME/$r"
  local backup_root="$DOT/backups/$(date +%Y%m%d-%H%M%S)"
  local backup_dst="$backup_root/$r"

  mkdir -p "$(dirname "$backup_dst")"
  mv "$dst" "$backup_dst"
  emit "backup" "$(home_label "$dst") -> $backup_dst"
}

ensure_dir() {
  local dir="$1"

  [[ "$dir" == "$HOME" ]] && return 0

  if [[ -L "$dir" ]]; then
    conflict "$(home_label "$dir") is a symlink; refusing to use it as a container"
    return 1
  fi

  if [[ -e "$dir" && ! -d "$dir" ]]; then
    conflict "$(home_label "$dir") exists and is not a directory"
    return 1
  fi

  if [[ ! -d "$dir" ]]; then
    if [[ "$APPLY" -eq 1 ]]; then
      mkdir -p "$dir"
      emit "mkdir" "$(home_label "$dir")"
    else
      case $'\n'"$PLANNED_DIRS" in
        *$'\n'"$dir"$'\n'*) return 0 ;;
      esac
      PLANNED_DIRS="${PLANNED_DIRS}${dir}"$'\n'
      emit "would mkdir" "$(home_label "$dir")"
    fi
  fi
}

link_missing() {
  local src="$1"
  local dst="$2"

  ensure_dir "$(dirname "$dst")" || return 0

  if [[ "$APPLY" -eq 1 ]]; then
    ln -s "$src" "$dst"
    emit "linked" "$(home_label "$dst") -> $src"
  else
    emit "would link" "$(home_label "$dst") -> $src"
  fi
}

handle_path() {
  local r="$1"
  local src="$SRC/$r"
  local dst="$HOME/$r"

  is_ignored "$r" && return 0

  if ! exists "$src"; then
    emit "skip" "~/$r (missing in repo)"
    return 0
  fi

  if [[ "$r" == ".config" ]]; then
    apply_config_children
    return 0
  fi

  if [[ -L "$dst" ]]; then
    local cur
    cur="$(readlink "$dst" || true)"
    if [[ "$cur" == "$src" ]]; then
      emit "ok" "~/$r"
    else
      conflict "~/$r is a symlink to $cur, expected $src"
    fi
    return 0
  fi

  if [[ -e "$dst" ]]; then
    if [[ -d "$src" && -d "$dst" ]]; then
      if [[ "$MERGE_EXISTING_DIRS" -eq 1 ]]; then
        emit "merge" "~/$r"
        handle_dir_children "$r"
      else
        conflict "~/$r is an existing directory; use --merge-existing-dirs to link missing children"
      fi
    else
      conflict "~/$r exists and is not the managed symlink"
    fi
    return 0
  fi

  link_missing "$src" "$dst"
}

handle_dir_children() {
  local r="$1"
  local dir="$SRC/$r"

  [[ -d "$dir" ]] || return 0

  shopt -s nullglob dotglob
  local child
  for child in "$dir"/*; do
    local name
    name="$(basename "$child")"
    handle_path "$r/$name"
  done
  shopt -u nullglob dotglob
}

apply_config_children() {
  local src_cfg="$SRC/.config"
  local dst_cfg="$HOME/.config"

  [[ -d "$src_cfg" ]] || return 0

  if [[ -L "$dst_cfg" ]]; then
    conflict "~/.config is a symlink; refusing to manage config children"
    return 0
  fi

  if [[ -e "$dst_cfg" && ! -d "$dst_cfg" ]]; then
    conflict "~/.config exists and is not a directory"
    return 0
  fi

  ensure_dir "$dst_cfg" || return 0

  shopt -s nullglob dotglob
  local child
  for child in "$src_cfg"/*; do
    local name
    name="$(basename "$child")"
    handle_path ".config/$name"
  done
  shopt -u nullglob dotglob
}

walk_home_entries() {
  [[ -d "$SRC" ]] || {
    echo "dot: missing source directory: $SRC" >&2
    exit 1
  }

  shopt -s nullglob dotglob
  local entry
  for entry in "$SRC"/*; do
    local name
    name="$(basename "$entry")"
    if [[ "$name" == ".config" ]]; then
      apply_config_children
    else
      handle_path "$name"
    fi
  done
  shopt -u nullglob dotglob
}

parse_apply_opts() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --merge-existing-dirs)
        MERGE_EXISTING_DIRS=1
        ;;
      -h|--help)
        usage
        ;;
      *)
        echo "dot: unknown option: $1" >&2
        usage
        ;;
    esac
    shift
  done
}

adopt_path() {
  local p="${1:-}"
  [[ -n "$p" ]] || usage

  local r
  r="$(rel "$p")"

  if is_ignored "$r"; then
    echo "dot: refusing to adopt ignored path: ~/$r" >&2
    exit 1
  fi

  if [[ "$r" == ".config" ]]; then
    echo "dot: refusing to manage ~/.config as a whole. Adopt specific children instead." >&2
    exit 1
  fi

  local src="$SRC/$r"
  local dst="$HOME/$r"

  exists "$dst" || {
    echo "dot: cannot adopt missing path: ~/$r" >&2
    exit 1
  }

  exists "$src" && {
    echo "dot: already exists in repo: $src" >&2
    exit 1
  }

  mkdir -p "$(dirname "$src")"
  mv "$dst" "$src"
  APPLY=1
  handle_path "$r"
}

replace_path() {
  local p="${1:-}"
  [[ -n "$p" ]] || usage

  local r
  r="$(rel "$p")"

  if is_ignored "$r"; then
    echo "dot: refusing to replace ignored path: ~/$r" >&2
    exit 1
  fi

  if [[ "$r" == ".config" ]]; then
    echo "dot: refusing to replace ~/.config. Replace specific children instead." >&2
    exit 1
  fi

  local src="$SRC/$r"
  local dst="$HOME/$r"

  if [[ ! -d "$src" ]]; then
    echo "dot: replace only works for directories present in dotfiles: $src" >&2
    exit 1
  fi

  if [[ -L "$dst" ]]; then
    local cur
    cur="$(readlink "$dst" || true)"
    if [[ "$cur" == "$src" ]]; then
      emit "ok" "~/$r"
      return 0
    fi

    backup_path "$r"
  elif [[ -e "$dst" ]]; then
    backup_path "$r"
  fi

  APPLY=1
  link_missing "$src" "$dst"
}

cmd="${1:-}"
shift || true

case "$cmd" in
  plan)
    APPLY=0
    parse_apply_opts "$@"
    walk_home_entries
    ;;
  apply)
    APPLY=1
    parse_apply_opts "$@"
    walk_home_entries
    ;;
  conflicts)
    APPLY=0
    CONFLICTS_ONLY=1
    parse_apply_opts "$@"
    walk_home_entries
    ;;
  add|adopt)
    [[ $# -eq 1 ]] || usage
    adopt_path "$1"
    ;;
  replace)
    [[ $# -eq 1 ]] || usage
    replace_path "$1"
    ;;
  -h|--help|"")
    usage
    ;;
  *)
    echo "dot: unknown command: $cmd" >&2
    usage
    ;;
esac

if [[ "$HAD_CONFLICTS" -eq 1 ]]; then
  exit 2
fi
