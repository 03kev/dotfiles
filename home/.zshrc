alias reload='exec zsh -l'
alias reloadenv="source ~/.zshenv"

# ──────────────────── THEME (EARLY) ───────────────────────

THEME_FILE="$HOME/.zsh/selected_theme"

if [[ -r $THEME_FILE ]]; then
  ZSH_THEME_MODE=$(<"$THEME_FILE")
else
  ZSH_THEME_MODE=dark
fi

_apply_theme_early() {
  case "$ZSH_THEME_MODE" in
    light)
      printf '\033]50;SetProfile=White\a'
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#abaaaa'
      export NVIM_THEME=light
      ;;
    *)
      printf '\033]50;SetProfile=Black\a'
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#444444'
      export NVIM_THEME=dark
      ;;
  esac
}

_apply_theme_early

# ───────────────────────────────────────────────────────────

source "$HOME/.zsh/functions.zsh"

source $HOME/.zsh/profiles/ohmyzsh.zsh
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ──────────────────── THEME (RUNTIME) ─────────────────────

_apply_theme_runtime() {
  [[ -f ~/.p10k-theme.zsh ]] && source ~/.p10k-theme.zsh
}

set_theme() {
  local mode=$1
  if [[ $mode != light && $mode != dark ]]; then
    echo "Usage: set_theme {light|dark}"
    return 1
  fi
  echo "$mode" >| "$THEME_FILE"
  ZSH_THEME_MODE=$mode
  _apply_theme_early
  _apply_theme_runtime
}

alias light='set_theme light'
alias dark='set_theme dark'

_apply_theme_runtime

# ─────────────────── NVIM CONFIG ──────────────────────────

if [[ -z ${_MY_COMPINIT_DONE-} ]]; then
  typeset -g _MY_COMPINIT_DONE=1
  autoload -Uz compinit
  compinit -i
fi

nvimc() {
  local config_dir=$HOME/.config/nvim-configs

  if [[ $1 == "-l" ]]; then
    echo "Available configurations:"
    ls -1 "$config_dir"
    return
  fi

  local config_name=$1
  shift   # so $@ is now everything after the config name

  NVIM_APPNAME="nvim-configs/${config_name}" command nvim "$@"
}

_list_files_in_current_dir() {
    _files
}

_nvim_config_autocomplete() {
    local config_dir="$HOME/.config/nvim-configs"
    local configs=($(ls -1 "$config_dir"))
    _arguments \
        '1: :(${configs[@]})' \
        '2: :_list_files_in_current_dir'
}

compdef _nvim_config_autocomplete nvimc

# ───────────────────────────────────────────────────────────
