# AGENTS.md

Guidance for AI coding agents working in this repository. Follows the [agents.md](https://agents.md/) convention.

## Repository purpose

YMacs — a personal Emacs configuration (Yi Yu's), inspired by [prelude](https://github.com/bbatsov/prelude). It's a runnable Emacs config, not a library: changes are validated by launching Emacs and observing behavior.

Requires Emacs 25.1 or newer (enforced in `init.el`).

## Architecture

`init.el` is the entry point. It defines path vars (`ymacs-dir`, `ymacs-modules-dir`, `ymacs-vendor-dir`, `ymacs-savefile-dir`), adds `modules/` to `load-path`, then loads modules via `require` in a fixed order:

1. `ymacs-packages` — bootstraps `package.el` archives (gnu, melpa, melpa-stable), installs `use-package`, and sets `use-package-always-ensure t`. **Every other module relies on `use-package` being available, so this must load first.**
2. `ymacs-ui` — themes (gruvbox-dark-hard by default), fonts (Fira Code 13), modeline, `all-the-icons`.
3. `ymacs-core` — editing fundamentals: smartparens, multiple-cursors, super-save, recentf/savehist/saveplace, magit, treemacs, dired-x, ediff. Backup/autosave files are redirected to `temporary-file-directory`; persistent state goes under `savefile/`.
4. `ymacs-global-keybindings` — global key remaps (e.g. `C-a`/`C-e` → mwim, `M-o` → ace-window, `C-x g` → magit-status, `kill-line` → crux-smart-kill-line).
5. `ymacs-ivy` — ivy/counsel pieces (loaded even though helm is the primary completion UI).
6. `ymacs-projectile-helm` — helm + projectile + helm-projectile (`C-c a g` → helm-projectile-ag, `C-c p` → projectile commands). `swiper-helm` rebinds `C-s`.
7. `ymacs-programming` — language modes (go-mode, markdown, jsonnet, solidity). Includes `save-and-test-go-program` bound to `C-c C-t` in go-mode.
8. `ymacs-lsp` — `lsp-mode` + `lsp-ui` + `company` + `flycheck` + `yasnippet`. Auto-attaches to `go-mode`, `python-mode`, `c-mode`, `c++-mode`. `C-c l` opens an `hydra-lsp` menu for navigation/refactor commands. Go buffers run `lsp-format-buffer` and `lsp-organize-imports` on save.
9. `ymacs-eshell` — eshell tweaks.
10. Platform conditional: `ymacs-macos` on Darwin, `ymacs-linux` on GNU/Linux.
11. Finally, every `*.el` under `vendor/` is loaded with `mapc 'load`. `vendor/` is gitignored — it's the per-machine escape hatch for env-specific config (paths, secrets, work-only settings). Don't commit anything there.

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

- **Go**: `gopls` on `PATH` (lsp-mode hardcodes `lsp-gopls-server-path` to `"gopls"` and passes `--debug=localhost:6060`); `goimports` is preferred over `gofmt` if present.
- **Python**: `python-language-server[all]` (pyls).
- **C/C++**: `ccls` (lsp-mode hooks `c-mode`/`c++-mode` to it; clang/cppcheck/gcc flycheck checkers are explicitly disabled in favor of lsp).
- **Solidity**: `solcjs` and `solium` are hardcoded to `/usr/local/bin/` paths in `ymacs-programming.el` — adjust there if installed elsewhere.
- **Markdown**: `multimarkdown` for `markdown-command`.
