(( $+commands[gemini] )) || return 0

export GEMINI_SANDBOX=sandbox-exec
export SEATBELT_PROFILE=permissive-open

_gemini_theme_name() {
  case "${ZSH_THEME_MODE:-$(_read_default_theme_mode)}" in
    light) print -r -- "WezTerm Light" ;;
    *) print -r -- "WezTerm Dark" ;;
  esac
}

_write_gemini_theme_settings() {
  local theme_name=$1
  local settings_file=$2

  cat >| "$settings_file" <<JSON
{
  "ui": {
    "theme": "$theme_name",
    "autoThemeSwitching": false,
    "showCompatibilityWarnings": false,
    "customThemes": {
      "WezTerm Light": {
        "name": "WezTerm Light",
        "type": "custom",
        "Background": "$DOT_THEME_LIGHT_BG",
        "Foreground": "$DOT_THEME_LIGHT_FG",
        "LightBlue": "$DOT_THEME_LIGHT_ANSI_4",
        "AccentBlue": "$DOT_THEME_LIGHT_ANSI_4",
        "AccentPurple": "$DOT_THEME_LIGHT_ANSI_5",
        "AccentCyan": "$DOT_THEME_LIGHT_ANSI_6",
        "AccentGreen": "$DOT_THEME_LIGHT_ANSI_2",
        "AccentYellow": "$DOT_THEME_LIGHT_ANSI_3",
        "AccentRed": "$DOT_THEME_LIGHT_ANSI_1",
        "DiffAdded": "#dfe8c8",
        "DiffRemoved": "#ead0cb",
        "Comment": "#6e6b62",
        "Gray": "#6e6b62",
        "DarkGray": "#aaa593",
        "GradientColors": ["$DOT_THEME_LIGHT_ANSI_4", "$DOT_THEME_LIGHT_ANSI_5", "$DOT_THEME_LIGHT_ANSI_6"]
      },
      "WezTerm Dark": {
        "name": "WezTerm Dark",
        "type": "custom",
        "Background": "$DOT_THEME_DARK_BG",
        "Foreground": "$DOT_THEME_DARK_FG",
        "LightBlue": "$DOT_THEME_DARK_ANSI_4",
        "AccentBlue": "$DOT_THEME_DARK_ANSI_4",
        "AccentPurple": "$DOT_THEME_DARK_ANSI_5",
        "AccentCyan": "$DOT_THEME_DARK_ANSI_6",
        "AccentGreen": "$DOT_THEME_DARK_ANSI_2",
        "AccentYellow": "$DOT_THEME_DARK_ANSI_3",
        "AccentRed": "$DOT_THEME_DARK_ANSI_1",
        "DiffAdded": "#2f3a1a",
        "DiffRemoved": "#3f201f",
        "Comment": "#9e9a8f",
        "Gray": "#9e9a8f",
        "DarkGray": "#5f5d57",
        "GradientColors": ["$DOT_THEME_DARK_ANSI_4", "$DOT_THEME_DARK_ANSI_5", "$DOT_THEME_DARK_ANSI_6"]
      }
    }
  }
}
JSON
}

gemini() {
  local theme_name=$(_gemini_theme_name)
  local settings_file

  settings_file=$(mktemp "${TMPDIR:-/tmp}/gemini-theme.XXXXXX") || return 1
  _write_gemini_theme_settings "$theme_name" "$settings_file"

  GEMINI_CLI_SYSTEM_SETTINGS_PATH="$settings_file" command gemini "$@"
  local status=$?

  rm -f "$settings_file"
  return $status
}
