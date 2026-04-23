alias reload='exec zsh -l'
alias reloadenv="source ~/.zshenv"

source "$HOME/.zsh/theme.zsh"

for integration in "$HOME"/.zsh/integrations/*.zsh(N); do
  source "$integration"
done
unset integration

source "$HOME/.zsh/functions.zsh"
source "$HOME/.zsh/profiles/ohmyzsh.zsh"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

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
  shift

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

_apply_current_theme_runtime
