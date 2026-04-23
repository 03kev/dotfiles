DEFAULT_THEME_FILE="$HOME/.zsh/selected_theme"

# Theme contract:
# - ~/.zsh/selected_theme is the persisted global default for new tabs and shells.
# - integrations may publish the live `theme_mode` to terminal-specific runtimes.

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

_publish_runtime_theme_mode() {
  return 0
}

_clear_runtime_theme_mode() {
  return 0
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
