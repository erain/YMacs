# YMacs

erain@'s personal Emacs configuration. Heavily inspired by
[prelude](https://github.com/bbatsov/prelude). If you want an out-of-the-box
config, use that — this one is forked so I can understand and control every
piece.

## Requirements

- **GNU Emacs 29.1 or newer** (uses built-in `use-package`, `treesit`,
  `pixel-scroll-precision-mode`, `so-long`, etc.).
- For GUI Emacs, install a good programming font. YMacs prefers
  **JetBrains Mono** (Ghostty-style/community-favorite choice), then Fira Code /
  SF Mono / other popular coding fonts if available. Restart Emacs or run
  `M-x ymacs-setup-fonts` after installing a new font. Terminal Emacs inherits
  your terminal font (for example, Ghostty's `font-family`).
- A Nerd Font for icons (GUI only). After first launch run
  `M-x nerd-icons-install-fonts`.
- Tree-sitter grammars are installed on demand by `treesit-auto`; accept the
  prompt the first time you visit a file in a new language.

## Terminal use

GUI-only packages (`nerd-icons`, `beacon`, `pixel-scroll-precision-mode`,
`company-quickhelp`, `lsp-ui-doc` child-frames) are auto-disabled when there's
no display, so `emacs -nw` is fully supported.

If you see a `Gtk-WARNING ** cannot open display` line on a headless host, that
comes from the GTK build of Emacs trying to initialize even with `-nw`. It's
harmless. To silence it install the X-less binary:

```bash
sudo apt install emacs-nox    # Debian / Ubuntu
```

For an `emacsclient` workflow run a daemon:

```bash
emacs --daemon                # in your shell rc, or as a systemd user unit
emacsclient -t file.txt       # open in the current terminal
```

`(server-start)` in `ymacs-core.el` covers the case of starting Emacs
interactively first and then attaching with `emacsclient` later.

## Go

```bash
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
```

## Python

```bash
pip install -U python-lsp-server[all]   # `pylsp`
```

## C / C++

Install [`ccls`](https://github.com/MaskRay/ccls) on `PATH`.

## Solidity

`solcjs` and `solium` are looked up at `/usr/local/bin/`. Override the paths in
`modules/ymacs-programming.el` if installed elsewhere.

## Markdown

```bash
brew install multimarkdown   # or apt install libtext-multimarkdown-perl
```
