# AGENTS.md

Guidance for AI coding agents working in this repository. Follows the [agents.md](https://agents.md/) convention.

## Repository purpose

YMacs — a personal Emacs configuration (Yi Yu's), inspired by [prelude](https://github.com/bbatsov/prelude). It's a runnable Emacs config, not a library: changes are validated by launching Emacs and observing behavior.

Requires **Emacs 29.1 or newer** (enforced in `init.el`). Targets Emacs 30 features where useful (built-in `which-key`, `use-short-answers`, etc.).

## Architecture

`early-init.el` runs first (Emacs 27+). It defers the GC, kills the menu/tool/scroll bars before the first frame is drawn, sets `LSP_USE_PLISTS=true`, configures native-comp, and disables the automatic `(package-initialize)` so `init.el` can do it itself after configuring archives.

`init.el` is the main entry point. It defines path vars (`ymacs-dir`, `ymacs-modules-dir`, `ymacs-vendor-dir`, `ymacs-savefile-dir`), adds `modules/` to `load-path`, then loads modules via `require` in a fixed order:

1. `ymacs-packages` — `package.el` archives (gnu, nongnu, melpa, melpa-stable) and `(require 'use-package)` (built-in since 29.1). Sets `use-package-always-ensure t`. **Every other module relies on `use-package`, so this must load first.**
2. `ymacs-ui` — themes (gruvbox-dark-hard by default), Fira Code (when installed), modeline, `nerd-icons`, `pixel-scroll-precision-mode`, `so-long`, `repeat-mode`, built-in `which-key`.
3. `ymacs-core` — editing fundamentals: smartparens, multiple-cursors, super-save, recentf/savehist/saveplace, magit, treemacs (+ `treemacs-nerd-icons`), dired-x (+ `nerd-icons-dired`), ediff, `ws-butler` (per-line whitespace trim), `treesit-auto` (on-demand grammar install), and `(server-start)`. Backup/autosave/undo-tree files redirect to `temporary-file-directory`; persistent state goes under `savefile/`.
4. `ymacs-global-keybindings` — global key remaps (e.g. `C-a`/`C-e` → mwim, `M-o` → ace-window, `C-x g` → magit-status, `kill-line` → crux-smart-kill-line).
5. `ymacs-projectile-helm` — helm + projectile + helm-projectile (`C-c a g` → helm-projectile-ag, `C-c p` → projectile commands). `swiper-helm` rebinds `C-s`.
6. `ymacs-programming` — language modes (go-mode, markdown, jsonnet, solidity). Includes `save-and-test-go-program` bound to `C-c C-t` in go-mode.
7. `ymacs-lsp` — `lsp-mode` + `lsp-ui` + `company` + `flycheck` + `yasnippet`. Bumps `read-process-output-max` to 4 MB. Sets `lsp-diagnostics-provider :flycheck`. Auto-attaches to `go-mode`, `python-mode`, `c-mode`, `c++-mode`. `C-c l` opens the `hydra-lsp` menu; the lsp-mode default keymap prefix is moved to `C-c L` to avoid clashing. Go buffers run `lsp-format-buffer` and `lsp-organize-imports` on save.
8. `ymacs-eshell` — eshell tweaks.
9. Platform conditional: `ymacs-macos` on Darwin, `ymacs-linux` on GNU/Linux.
10. Finally, every `*.el` under `vendor/` is loaded with `mapc 'load`. `vendor/` is gitignored — it's the per-machine escape hatch for env-specific config (paths, secrets, work-only settings). Don't commit anything there.

`custom-file` is set to `modules/custom.el` so the Customize UI doesn't dirty `init.el`.

### Persistent state layout

- `savefile/` — recentf, savehist, saveplace, projectile cache, bookmarks. Gitignored. Created automatically on startup if missing.
- `elpa/` — installed packages (gitignored, repopulated on first launch).
- `eln-cache/`, `auto-save-list/`, `tramp`, `projectile-bookmarks.eld` — generated, gitignored.

## Working in this codebase

There is no build system, no test suite, no linter. To validate a change:

```bash
# Smoke-test the config without touching the running Emacs
emacs -Q -l init.el

# Byte-recompile all modules (also available as M-x ymacs-recompile-init from inside Emacs)
emacs --batch --eval "(byte-recompile-directory \"modules\" 0)"
```

A first launch on a fresh machine will fetch every package from MELPA/GNU ELPA — expect a long startup and don't interrupt it.

When adding a new module: create `modules/ymacs-<name>.el`, end it with `(provide 'ymacs-<name>)`, and add a `(require 'ymacs-<name>)` to `init.el` in the right position relative to the loading order above.

## External tooling assumed by the config

These aren't installed by Emacs and the config will misbehave without them where relevant (see `README.md`):

- **Go**: `gopls` on `PATH` (lsp-mode hardcodes `lsp-gopls-server-path` to `"gopls"`); `goimports` is preferred over `gofmt` if present.
- **Python**: `python-lsp-server[all]` (`pylsp`). The old `python-language-server` (pyls) is unmaintained.
- **C/C++**: `ccls` (lsp-mode hooks `c-mode`/`c++-mode` to it; clang/cppcheck/gcc flycheck checkers are explicitly disabled in favor of lsp).
- **Solidity**: `solcjs` and `solium` are hardcoded to `/usr/local/bin/` paths in `ymacs-programming.el` — adjust there if installed elsewhere.
- **Markdown**: `multimarkdown` for `markdown-command`.
- **Tree-sitter grammars**: installed on demand by `treesit-auto` the first time you visit a language file. A C compiler must be available.
- **Nerd Font**: run `M-x nerd-icons-install-fonts` once for icon glyphs to render.
