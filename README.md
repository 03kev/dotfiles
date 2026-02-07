# Dotfiles

Questa repo contiene i miei dotfiles e uno script (`dot`) per:
- fare backup dei file di configurazione dentro `~/.dotfiles/home/`
- creare symlink verso `$HOME` in modo ripetibile
- installare tutto facilmente su una nuova macchina
- gestire `~/.config` in modo sicuro: **non** symlinka `~/.config` come directory intera, ma solo i suoi figli (`~/.config/<app>`)

## Struttura

```
~/.dotfiles/
  home/
    .zshrc
    .zshenv
    .zsh/
    .config/
      karabiner/
      ...
  scripts/
    dot.sh
  README.md
```

Regola: **tutto ciò che sta in `home/` replica il path relativo a `$HOME`.**

Esempi:
- `~/.dotfiles/home/.zshrc` → symlink in `~/.zshrc`
- `~/.dotfiles/home/.zsh/` → symlink in `~/.zsh/`
- `~/.dotfiles/home/.config/karabiner` → symlink in `~/.config/karabiner`


## Installazione su una nuova macchina

1) Clona la repo:

```bash
git clone <URL_DELLA_TUA_REPO_DOTFILES> ~/.dotfiles
```

2) Rendi eseguibile lo script:

```bash
chmod +x ~/.dotfiles/scripts/dot.sh
```

3) Applica i symlink:

```bash
~/.dotfiles/scripts/dot.sh apply
```

## Uso quotidiano

### Adottare un file/cartella esistente dentro la repo

Esempi:

```bash
~/.dotfiles/scripts/dot.sh add ~/.zshrc
~/.dotfiles/scripts/dot.sh add ~/.zsh
~/.dotfiles/scripts/dot.sh add ~/.config/karabiner
```

Nota: lo script rifiuta intenzionalmente:

```bash
~/.dotfiles/scripts/dot.sh add ~/.config
```

### Applicare tutto

```bash
~/.dotfiles/scripts/dot.sh apply
```

Comportamento “safe by default”:
- se un path in `$HOME` esiste e **non** è un symlink, lo script **non lo tocca** e ti stampa il comando esatto per sistemarlo a mano
- se un path è symlink ma punta altrove, lo script **non lo tocca** e ti stampa il comando esatto
- se è già il symlink corretto, stampa `ok` e non fa nulla

## Neovim come submodule (opzionale)

Se vuoi tenere `nvim` come repo separata:

```bash
cd ~/.dotfiles
git submodule add https://github.com/03kev/nvim.git home/.config/nvim
git commit -m "Add nvim as submodule"
```

Su una macchina nuova:

```bash
cd ~/.dotfiles
git submodule update --init --recursive
~/.dotfiles/scripts/dot.sh apply
```

## Troubleshooting

- `~/.config is a symlink`: lo script si rifiuta di procedere.
  Soluzione:
  ```bash
  rm ~/.config
  mkdir -p ~/.config
  ~/.dotfiles/scripts/dot.sh apply
  ```

- `skip (exists and is not a symlink)`: hai già un file/dir reale in `$HOME`.
  Lo script ti stampa il comando (rm -rf + ln -s). Eseguilo solo se sei sicuro.
