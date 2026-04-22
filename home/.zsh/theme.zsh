DEFAULT_THEME_FILE="$HOME/.zsh/selected_theme"

# Theme contract:
# - ~/.zsh/selected_theme is the persisted global default for new tabs and shells.
# - the current shell can publish a live `theme_mode` user var to WezTerm.
# - WezTerm persists the resolved per-tab theme separately via tab overrides.

_read_default_theme_mode() {
  if [[ -r $DEFAULT_THEME_FILE ]]; then
    local mode
    mode=$(<"$DEFAULT_THEME_FILE")
    [[ $mode == light ]] && print -r -- light && return
  fi

  print -r -- dark
}

_persist_default_theme_mode() {
  print -r -- "$1" >| "$DEFAULT_THEME_FILE"
}

ZSH_THEME_MODE=$(_read_default_theme_mode)

_apply_theme_environment() {
  case "$ZSH_THEME_MODE" in
    light)
      export NVIM_THEME=light
      export BAT_THEME="gruvbox-light"
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#abaaaa'
      export FZF_DEFAULT_OPTS='
        --color preview-fg:#11110a,gutter:#cbcac3,bg+:#cbcac3,fg+:#11110a,prompt:#a0a0a0,pointer:#868686,hl:#d7005f,hl+:#d7005f
        --pointer=▌
      '
      ;;
    *)
      export NVIM_THEME=dark
      unset BAT_THEME
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#686868'
      export FZF_DEFAULT_OPTS='
        --color pointer:#565656,hl:#e5438e,hl+:#e5438e,prompt:#929081,fg:#eeead8
      '
      ;;
  esac
}

_wezterm_set_user_var() {
  [[ -n ${WEZTERM_PANE-} ]] || return 0
  (( $+commands[base64] )) || return 0

  local name=$1
  local value=$2
  local encoded
  encoded=$(printf '%s' "$value" | base64 | tr -d '\r\n')

  if [[ -n ${TMUX-} ]]; then
    printf '\033Ptmux;\033\033]1337;SetUserVar=%s=%s\007\033\\' "$name" "$encoded"
  else
    printf '\033]1337;SetUserVar=%s=%s\007' "$name" "$encoded"
  fi
}

_publish_runtime_theme_mode() {
  _wezterm_set_user_var theme_mode "${ZSH_THEME_MODE:-dark}"
}

_clear_runtime_theme_mode() {
  _wezterm_set_user_var theme_mode "__inherit__"
}

_apply_shell_colors() {
  export CLICOLOR=1
  case "$ZSH_THEME_MODE" in
    light)
      export LS_COLORS='di=38;5;247:ln=38;2;90;144;0'
      alias ls='gls --color=auto'
      ;;
    *)
      export LSCOLORS='Axcxcxdxbxegedabagacad'
      export LS_COLORS='di=90:ln=32'
      alias ls='ls -G'
      ;;
  esac
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
}

_reload_prompt_theme() {
  [[ -f ~/.p10k-theme.zsh ]] && source ~/.p10k-theme.zsh
}

_apply_current_theme_runtime() {
  _apply_shell_colors
  _reload_prompt_theme
  _publish_runtime_theme_mode
}

_apply_current_theme_runtime_without_publish() {
  _apply_shell_colors
  _reload_prompt_theme
}

set_theme() {
  local mode=$1
  if [[ $mode != light && $mode != dark ]]; then
    echo "Usage: set_theme {light|dark}"
    return 1
  fi

  _persist_default_theme_mode "$mode"
  ZSH_THEME_MODE=$mode

  _apply_theme_environment
  _apply_current_theme_runtime
}

alias light='set_theme light'
alias dark='set_theme dark'

reset_tab_theme() {
  ZSH_THEME_MODE=$(_read_default_theme_mode)
  _apply_theme_environment
  _apply_current_theme_runtime_without_publish
  _clear_runtime_theme_mode
}

alias tabdefault='reset_tab_theme'

# Export theme-dependent env vars early so later startup steps see the right mode.
_apply_theme_environment
