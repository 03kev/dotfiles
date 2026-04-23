THEME_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles"
DEFAULT_THEME_FILE="$THEME_STATE_DIR/theme"

# Theme contract:
# - ~/.local/state/dotfiles/theme is the persisted global default for new tabs and shells.
# - integrations may publish the live `theme_mode` to terminal-specific runtimes.

_read_default_theme_mode() {
  if [[ -r $DEFAULT_THEME_FILE ]]; then
    local mode
    mode=$(<"$DEFAULT_THEME_FILE")
    [[ $mode == light ]] && print -r -- light && return
    [[ $mode == dark ]] && print -r -- dark && return
  fi

  print -r -- dark
}

_persist_default_theme_mode() {
  mkdir -p "$THEME_STATE_DIR"
  print -r -- "$1" >| "$DEFAULT_THEME_FILE"
}

ZSH_THEME_MODE=$(_read_default_theme_mode)

for theme_module in "$HOME"/.zsh/theme/*.zsh(N); do
  source "$theme_module"
done
unset theme_module

(( $+functions[_apply_theme_environment] )) || _apply_theme_environment() { return 0 }
(( $+functions[_apply_shell_colors] )) || _apply_shell_colors() { return 0 }

_publish_runtime_theme_mode() {
  return 0
}

_reload_prompt_theme() {
  [[ -f ~/.p10k-theme.zsh ]] && source ~/.p10k-theme.zsh
}

_apply_current_theme_runtime() {
  _apply_shell_colors
  _reload_prompt_theme
  _publish_runtime_theme_mode
}

theme() {
  local command=$1
  if [[ $command != light && $command != dark ]]; then
    echo "Usage: theme {light|dark}"
    return 1
  fi

  _persist_default_theme_mode "$command"
  ZSH_THEME_MODE=$command

  _apply_theme_environment
  _apply_current_theme_runtime
}

alias light='theme light'
alias dark='theme dark'

_theme_completion() {
  _arguments '1:theme command:(light dark)'
}

# Export theme-dependent env vars early so later startup steps see the right mode.
_apply_theme_environment
