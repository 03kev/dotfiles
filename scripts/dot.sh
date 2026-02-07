#!/usr/bin/env bash
set -euo pipefail

DOT="$HOME/.dotfiles"
SRC="$DOT/home"

usage() { echo "Usage: dot add <path-in-home> | dot apply" >&2; exit 1; }

rel() {
  local p="$1"
  [[ "$p" = /* ]] || p="$HOME/$p"
  [[ "$p" == "$HOME/"* ]] || { echo "dot: must be under \$HOME: $p" >&2; exit 1; }
  echo "${p#"$HOME/"}"
}

link_one() {
  local r="$1"
  local dst="$HOME/$r"
  local src="$SRC/$r"

  # ignore junk
  case "$r" in
    *"/.DS_Store"|".DS_Store") return 0 ;;
    ".zsh/selected_theme") return 0 ;;
  esac

  # source must exist in repo to link it
  [[ -e "$src" || -L "$src" ]] || {
    echo "dot: skip ~/$r (missing in repo: $src)" >&2
    return 0
  }

  mkdir -p "$(dirname "$dst")"

  # if already correct symlink, do nothing
  if [[ -L "$dst" ]]; then
    local cur
    cur="$(readlink "$dst" || true)"

    # normalize relative symlinks for comparison
    local want="$src"
    if [[ "$cur" == "$want" ]]; then
      echo "dot: ok (already linked) ~/$r"
      return 0
    fi

    # if it's a symlink but to something else, don't touch automatically
    echo "dot: skip ~/$r (symlink points elsewhere: $cur)" >&2
    echo "dot: fix manually:" >&2
    printf "  rm '%s' && ln -s '%s' '%s'\n" "$dst" "$src" "$dst" >&2
    return 0
  fi

  # if real file/dir exists, don't touch automatically
  if [[ -e "$dst" ]]; then
    echo "dot: skip ~/$r (exists and is not a symlink)" >&2
    echo "dot: fix manually (WARNING: removes existing path):" >&2
    printf "  rm -rf '%s' && ln -s '%s' '%s'\n" "$dst" "$src" "$dst" >&2
    return 0
  fi

  ln -s "$src" "$dst"
  echo "dot: linked ~/$r"
}

apply_config_children() {
  local src_cfg="$SRC/.config"
  local dst_cfg="$HOME/.config"

  [[ -d "$src_cfg" ]] || return 0

  # ~/.config deve essere una directory reale, non un symlink
  if [[ -L "$dst_cfg" ]]; then
    echo "dot: ERROR: ~/.config is a symlink. Refusing to apply config children." >&2
    echo "dot: Fix manually:" >&2
    echo "  rm ~/.config && mkdir -p ~/.config" >&2
    return 1
  fi
  mkdir -p "$dst_cfg"

  # Linka solo i figli: ~/.config/<name> -> ~/.dotfiles/home/.config/<name>
  shopt -s nullglob dotglob
  for child in "$src_cfg"/*; do
    local name
    name="$(basename "$child")"
    [[ "$name" == ".DS_Store" ]] && continue
    link_one ".config/$name"
  done
  shopt -u nullglob dotglob
}

cmd="${1:-}"; shift || true
case "$cmd" in
  add)
    p="${1:-}"; [[ -n "$p" ]] || usage
    r="$(rel "$p")"

    # Non permettere di "adottare" l'intera ~/.config come singolo symlink.
    if [[ "$r" == ".config" ]]; then
      echo "dot: refusing to manage ~/.config as a whole. Add specific children (e.g. ~/.config/karabiner)." >&2
      exit 1
    fi

    mkdir -p "$(dirname "$SRC/$r")"
    [[ -e "$SRC/$r" || -L "$SRC/$r" ]] && { echo "dot: already exists in repo: $SRC/$r" >&2; exit 1; }

    mv "$HOME/$r" "$SRC/$r"
    link_one "$r"
    ;;
  apply)
    # 1) Applica tutto tranne .config come entry top-level
    (cd "$SRC" && find . -mindepth 1 -maxdepth 1 -print0) | while IFS= read -r -d '' p; do
      r="${p#./}"
      [[ "$r" == ".config" ]] && continue
      link_one "$r"
    done

    # 2) Per .config: linka i figli, non la directory intera
    apply_config_children
    ;;
  *) usage ;;
esac
