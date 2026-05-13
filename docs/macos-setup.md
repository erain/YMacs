# macOS bootstrap

Use this checklist to reproduce this Emacs setup on a new Mac.

## 1. Install prerequisites

Install Apple's command-line tools and Homebrew if they are not already present:

```bash
xcode-select --install
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Clone this repository as your Emacs config:

```bash
git clone <this-repo-url> ~/.emacs.d
cd ~/.emacs.d
```

## 2. Run the bootstrap script

```bash
./scripts/setup-macos.sh
```

The script runs `brew bundle` from `Brewfile`, installs `grip` with `pipx`,
installs `en_CA`/`en_US` Hunspell dictionaries into `~/Library/Spelling/`, and
symlinks `bin/emacs-service` to `~/bin/emacs-service`.

If you prefer to do it manually, run:

```bash
brew bundle --file ~/.emacs.d/Brewfile
pipx install --backend pip --index-url https://pypi.org/simple grip
mkdir -p ~/bin ~/Library/Spelling
ln -sf ~/.emacs.d/bin/emacs-service ~/bin/emacs-service
```

Then install Hunspell dictionaries (`*.aff` and `*.dic`) under
`~/Library/Spelling/` or `/Library/Spelling/`.

## 3. Start the Emacs daemon

The helper manages a per-user LaunchAgent at
`~/Library/LaunchAgents/com.yiyu.emacs-daemon.plist`:

```bash
emacs-service install   # only needed once if the plist does not exist
emacs-service start
emacs-service status
```

Useful commands:

```bash
emacs-service stop
emacs-service restart
emacs-service disable   # stop and disable autostart
emacs-service enable    # enable autostart and start
```

The LaunchAgent expects the Homebrew cask app at:

```text
/Applications/Emacs.app/Contents/MacOS/Emacs
```

Override with `EMACS_SERVICE_EMACS_BIN=/path/to/Emacs` if needed.

## 4. First Emacs launch tasks

Open a GUI frame and run:

```text
M-x nerd-icons-install-fonts
```

Tree-sitter grammars are installed on demand by `treesit-auto`; accept prompts
when visiting a language for the first time.

## 5. Language tooling

Go:

```bash
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
```

Python:

```bash
pip install -U 'python-lsp-server[all]'
```

Markdown tooling comes from the bootstrap script:

- `pandoc` for preview/export
- `marksman` for Markdown LSP
- `hunspell` + dictionaries for spell checking
- `grip` for GitHub-style browser preview (`C-c C-c g`)

## 6. Terminal / Ghostty notes

GUI Emacs uses the configured font stack in `modules/ymacs-ui.el`. Terminal
Emacs inherits the terminal font; for Ghostty, set `font-family` in Ghostty's
config.

## 7. Machine-local overrides

Put machine-specific settings in `~/.emacs.d/vendor/*.el`. The `vendor/`
directory is intentionally gitignored for local paths, secrets, and work-only
settings.
