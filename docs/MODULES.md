# Moduli Secondari

Questa pagina raccoglie i moduli presenti nei dotfiles che non sono centrali nel bootstrap quotidiano.

Per le dipendenze complete, vedi [`DEPENDENCIES.md`](./DEPENDENCIES.md).

## Karabiner

La config Karabiner e' in [`home/.config/karabiner`](../home/.config/karabiner).

Contiene:

- `karabiner.json`: configurazione principale caricata da Karabiner-Elements
- `assets/complex_modifications/*.json`: regole custom
- `assets/complex_modifications/scripts`: script shell e AppleScript usati dalle regole
- `automatic_backups/*.json`: snapshot generati automaticamente da Karabiner

Questa parte e' macOS-only. Alcune regole usano AppleScript, `cliclick`, `pmset`, app macOS e path assoluti sotto `/Users/kevinmuka`, quindi su un'altra macchina va controllata prima di abilitarla.

## tmux

[`home/.tmux.conf`](../home/.tmux.conf) configura:

- prefix `C-a`
- navigazione pane con `h/j/k/l`
- plugin TPM: `tmux-sensible`, `tmux-resurrect`
- supporto passthrough terminale per preview immagini
- colori e statusline custom

Comandi shell collegati:

```sh
tmuxplugins
reloadtmux
tnw
tn <session>
```

## IdeaVim

[`home/.ideavimrc`](../home/.ideavimrc) replica parte del workflow Vim/Neovim dentro JetBrains.

Include:

- leader su spazio
- search, numbering e scrolloff
- plugin IdeaVim come surround, commentary, multiple cursors, EasyMotion e WhichKey
- clipboard separata di default, con clipboard di sistema solo tramite `+`
- mapping per tab, refactor e azioni JetBrains

## Script Custom

Gli script custom sono linkati in:

```text
~/.config/scripts
```

Il principale e' [`home/.config/scripts/mypandoc`](../home/.config/scripts/mypandoc), wrapper attorno a `pandoc` per:

- export PDF
- export LaTeX con `-tex`
- passaggio di variabili `-V`
- installazione pacchetti TeX con `tlmgr`
- template in `~/.config/scripts/pandoc`

`.zprofile` aggiunge `~/.config/scripts` al `PATH`.

