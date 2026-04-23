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
        "Background": "#edebdc",
        "Foreground": "#10100f",
        "LightBlue": "#6b6b6b",
        "AccentBlue": "#6b6b6b",
        "AccentPurple": "#8a5a7a",
        "AccentCyan": "#4f7f7f",
        "AccentGreen": "#5f7a14",
        "AccentYellow": "#b59a2c",
        "AccentRed": "#a14a44",
        "DiffAdded": "#dfe8c8",
        "DiffRemoved": "#ead0cb",
        "Comment": "#6e6b62",
        "Gray": "#6e6b62",
        "DarkGray": "#aaa593",
        "GradientColors": ["#6b6b6b", "#8a5a7a", "#4f7f7f"]
      },
      "WezTerm Dark": {
        "name": "WezTerm Dark",
        "type": "custom",
        "Background": "#1d1d1b",
        "Foreground": "#f9f9f9",
        "LightBlue": "#7c7c7c",
        "AccentBlue": "#7c7c7c",
        "AccentPurple": "#a07090",
        "AccentCyan": "#5d8f8f",
        "AccentGreen": "#6d8a0f",
        "AccentYellow": "#d2b34c",
        "AccentRed": "#c05a52",
        "DiffAdded": "#2f3a1a",
        "DiffRemoved": "#3f201f",
        "Comment": "#9e9a8f",
        "Gray": "#9e9a8f",
        "DarkGray": "#5f5d57",
        "GradientColors": ["#7c7c7c", "#a07090", "#5d8f8f"]
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
