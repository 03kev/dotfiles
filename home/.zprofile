if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

export PATH="/usr/local/texlive/2025/bin/universal-darwin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"

export PATH="$PATH:/$HOME/.config/scripts"
