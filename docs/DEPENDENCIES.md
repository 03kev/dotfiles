# Dipendenze Dotfiles

Questa pagina elenca le dipendenze necessarie per usare i dotfiles fuori da Neovim.

Le dipendenze interne alla configurazione Neovim sono volutamente escluse: sono documentate nel README del submodule `home/.config/nvim`.

## Base Repo

Servono per clonare il repository, inizializzare i submodule e applicare i symlink con `scripts/dot.sh`.

| Dipendenza | Usata da | Note Linux |
| --- | --- | --- |
| `git` | clone repo, submodule, TPM, plugin WezTerm | installare dal package manager |
| `bash` | `scripts/dot.sh`, `mypandoc`, script Karabiner | installare dal package manager |
| utility base (`cat`, `date`, `dirname`, `basename`, `mkdir`, `mv`, `ln`, `readlink`, `printf`) | `scripts/dot.sh` | normalmente in `coreutils` |
| `chmod` | bootstrap iniziale di `scripts/dot.sh` | normalmente gia' presente |

## Shell Zsh

Queste dipendenze servono alla configurazione Zsh principale.

| Dipendenza | Usata da | Note |
| --- | --- | --- |
| `zsh` | `.zshrc`, `.zprofile`, `.zshenv` | shell principale |
| Oh My Zsh | `.zsh/profiles/ohmyzsh.zsh` | richiesto dal profilo shell attuale |
| Powerlevel10k | `.p10k.zsh`, `.p10k-theme.zsh` | prompt configurato |
| `zsh-autosuggestions` | `.zsh/profiles/ohmyzsh.zsh` | il file viene caricato via `brew --prefix` |
| `zsh-vi-mode` | plugin Oh My Zsh | modalita' vi della shell |
| `zoxide` | `.zsh/profiles/ohmyzsh.zsh`, funzioni shell | jump directory |
| `fzf` | funzioni `fzfnvim`, `fzfop`, tema CLI | picker interattivo |
| `curl` | funzioni `weather`, `ip` | chiamate HTTP da shell |
| `bat` | tema CLI (`BAT_THEME`) | non blocca la shell, ma e' parte del tema CLI |
| `ls -G` / GNU coreutils `gls` | tema CLI | `ls -G` e' macOS-oriented; su Linux va adattato a `ls --color=auto` oppure va fornito `gls` |
| `base64` | integrazione WezTerm in `.zsh/integrations/wezterm.zsh` | di solito gia' presente |
| utility standard (`find`, `touch`, `rev`, `cut`, `tr`, `rm`) | funzioni `fzfop`, `new`, `c`, integrazione WezTerm | normalmente gia' presenti |
| SDKMAN | `.zsh/profiles/ohmyzsh.zsh` | opzionale, viene caricato solo se esiste |
| iTerm2 shell integration | `.zsh/profiles/ohmyzsh.zsh` | opzionale, viene caricata solo se esiste |

## Funzioni E Alias Shell

Queste dipendenze non sono necessarie per aprire una shell, ma servono a funzioni o alias specifici.

| Dipendenza | Usata da | Note Linux / Portabilita' |
| --- | --- | --- |
| `tmux` | funzioni `tmuxplugins`, `reloadtmux`, alias tmux | disponibile su Linux |
| Neovim | `$EDITOR`, `nvimc`, `fzfnvim` | qui e' indicato solo l'eseguibile; le sue dipendenze stanno nel README Neovim |
| `gcc` | funzione `c` | disponibile su Linux |
| `python3`, `pip3` | alias `python`, `pip`; script Karabiner | disponibili su Linux |
| Java Zulu 8 + `Fitch.jar` | alias `fitch` | path attuale hardcoded su macOS |
| `open` | funzioni `fzfop`, `telegram`, `op` | macOS-only; su Linux va portato a `xdg-open` |
| `defaults`, `killall Dock` | funzione `resetlaunchpad` | macOS-only |
| `ipconfig` | funzione `ip` | macOS-only; su Linux usare `ip`/`hostname` |
| `mdls` | funzione `version` | macOS-only |
| `osascript` | funzione `bundleid` | macOS-only |
| `scutil`, `dscacheutil` | alias `computername` | macOS-only |

## Tema Condiviso

Il tema condiviso vive in `home/.config/theme` ed e' consumato da Zsh, WezTerm, Neovim e Gemini CLI.

| File | Consumato da | Dipendenze esterne |
| --- | --- | --- |
| `colors.env` | Zsh, Gemini CLI | nessuna, oltre alla shell |
| `colors.zsh` | Zsh | nessuna, oltre alla shell |
| `colors.lua` | WezTerm, Neovim | nessuna, oltre a Lua dentro l'app che lo carica |

## WezTerm

| Dipendenza | Usata da | Note |
| --- | --- | --- |
| WezTerm | `home/.config/wezterm` | terminale configurato |
| JetBrainsMono Nerd Font | `home/.config/wezterm/lua/ui.lua` | font usato dalla UI |
| accesso a GitHub/rete | plugin WezTerm | WezTerm scarica `bar.wezterm` e `smart-splits.nvim` |
| `base64` | `.zsh/integrations/wezterm.zsh` | sync tema da shell a WezTerm |

## tmux

| Dipendenza | Usata da | Note |
| --- | --- | --- |
| `tmux` | `.tmux.conf` | terminal multiplexer |
| TPM | `~/.tmux/plugins/tpm/tpm` | plugin manager tmux |
| `git` | TPM | scarica `tmux-sensible` e `tmux-resurrect` |

## Script Custom

| Dipendenza | Usata da | Note |
| --- | --- | --- |
| `pandoc` | `home/.config/scripts/mypandoc` | export Markdown verso PDF/LaTeX |
| TeX Live / LaTeX | `mypandoc`, `.zprofile` | path macOS attuale: `/usr/local/texlive/2025/bin/universal-darwin` |
| `tlmgr` | `mypandoc --install` | installazione pacchetti TeX |
| `sudo` | `mypandoc --install` | usato solo per installare pacchetti TeX |

## Gemini CLI

| Dipendenza | Usata da | Note |
| --- | --- | --- |
| Gemini CLI (`gemini`) | `.zsh/integrations/gemini.zsh` | opzionale: il file esce se `gemini` non esiste |
| `mktemp`, `rm` | wrapper Gemini | normalmente gia' presenti |
| `sandbox-exec` | wrapper Gemini | macOS-only |

## Karabiner-Elements

Tutta questa sezione e' macOS-only.

| Dipendenza | Usata da | Note |
| --- | --- | --- |
| Karabiner-Elements | `home/.config/karabiner` | applica le regole tastiera |
| `osascript` / AppleScript | script e `karabiner.json` | richiede permessi Automation/Accessibility dove necessario |
| `pmset` | regole lock/display sleep | macOS-only |
| `python3` + modulo Python `Quartz` | `is_screen_locked.sh` | installabile con PyObjC, ad esempio `pyobjc-framework-Quartz` |
| `cliclick` | script Yomu | path attuale hardcoded: `/opt/homebrew/bin/cliclick` |
| Firefox | script Firefox | usato da AppleScript e regole Karabiner |
| Safari | `typora.sh` | usato per menu Develop/Web Inspector |
| Typora | regole Typora | app controllata da script |
| Yomu | regole Yomu | app controllata tramite coordinate mouse |
| Friendly Streaming | regole Friendly Streaming | app controllata da AppleScript |
| Spotify | `karabiner.json` | aperta con `open -a Spotify` |

Nota importante: alcune regole Karabiner contengono path assoluti sotto `/Users/kevinmuka`. Su un'altra macchina o con un altro username vanno portate prima di aspettarsi che funzionino.

## JetBrains / IdeaVim

| Dipendenza | Usata da | Note |
| --- | --- | --- |
| JetBrains IDE | `.ideavimrc` | IntelliJ, PyCharm, WebStorm o simili |
| IdeaVim | `.ideavimrc` | plugin principale |
| plugin IdeaVim opzionali | `.ideavimrc` | surround, commentary, easymotion, which-key, multiple cursors se li vuoi usare |

## macOS App E Path In `.zprofile`

| Dipendenza / path | Usata da | Note |
| --- | --- | --- |
| Homebrew in `/opt/homebrew` | `.zprofile`, `.zsh/profiles/ohmyzsh.zsh` | Apple Silicon; su Intel/Linux va adattato |
| TeX Live 2025 macOS | `.zprofile` | path hardcoded macOS |
| PostgreSQL 18 Homebrew | `.zprofile` | path hardcoded: `/opt/homebrew/opt/postgresql@18/bin` |
| `~/.local/bin` | `.zprofile` | path generico utile anche su Linux |
| `~/.config/scripts` | `.zprofile` | espone `mypandoc` e script custom |

## Checklist Linux

Per una macchina Linux, la parte portabile minima e':

```sh
git bash zsh coreutils tmux curl fzf zoxide bat gcc python3 python3-pip pandoc texlive wezterm
```

Poi installare a parte:

- Oh My Zsh
- Powerlevel10k
- `zsh-autosuggestions`
- `zsh-vi-mode`
- TPM per tmux
- JetBrainsMono Nerd Font
- eventuale JetBrains IDE + IdeaVim

Prima di usare tutto il repo su Linux vanno portati o disabilitati:

- Karabiner-Elements e tutti gli script in `home/.config/karabiner`
- i comandi macOS `open`, `osascript`, `defaults`, `pmset`, `ipconfig`, `mdls`, `scutil`, `dscacheutil`, `sandbox-exec`
- i path Homebrew `/opt/homebrew/...`
- il path TeX Live macOS `/usr/local/texlive/2025/bin/universal-darwin`
- gli alias `ls -G` e `gls`, da adattare a GNU `ls --color=auto`
- i path assoluti `/Users/kevinmuka/...`
