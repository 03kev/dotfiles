# Small CLI theme consumers. Larger tools keep their own integration files.

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
