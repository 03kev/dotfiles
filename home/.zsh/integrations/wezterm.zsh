[[ -n ${WEZTERM_PANE-} ]] || return 0
(( $+commands[base64] )) || return 0

_wezterm_set_user_var() {
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
