# YMacs

erain@'s personal Emacs configuration. Heavily inspired by
[prelude](https://github.com/bbatsov/prelude). If you want an out-of-the-box
config, use that — this one is forked so I can understand and control every
piece.

## Requirements

- **GNU Emacs 29.1 or newer** (uses built-in `use-package`, `treesit`,
  `pixel-scroll-precision-mode`, `so-long`, etc.).
- A Nerd Font for icons. After first launch run `M-x nerd-icons-install-fonts`.
- Tree-sitter grammars are installed on demand by `treesit-auto`; accept the
  prompt the first time you visit a file in a new language.

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
