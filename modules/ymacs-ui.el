;;; ymacs-ui.el --- UI tweaks -*- lexical-binding: t; -*-
;;
;; Tool-bar / menu-bar / scroll-bar are killed in early-init.el so the
;; first frame is drawn without them.

(blink-cursor-mode -1)
(setq-default cursor-type 'bar)

(setq ring-bell-function 'ignore
      use-short-answers t
      scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(line-number-mode 1)
(column-number-mode 1)
(size-indication-mode 1)

(setq frame-title-format
      '("" invocation-name " YMacs - "
        (:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; Smoother trackpad / wheel scrolling (Emacs 29+).
(when (fboundp 'pixel-scroll-precision-mode)
  (pixel-scroll-precision-mode 1))

;; Survive opening minified / very-long-line files.
(global-so-long-mode 1)

;; Repeat-mode: e.g. C-x o o o for `other-window'.
(repeat-mode 1)

(use-package hl-line
  :ensure nil
  :init (global-hl-line-mode 1))

(use-package whitespace
  :ensure nil
  :config
  (setq whitespace-line-column 100
        whitespace-style '(face tabs empty trailing lines-tail)))

(use-package beacon
  :diminish beacon-mode
  :config (beacon-mode 1))

;; `which-key' is built-in since Emacs 30.
(use-package which-key
  :ensure nil
  :diminish which-key-mode
  :config (which-key-mode 1))

;; Font: only set if installed; otherwise fall back silently.
(when (and (display-graphic-p)
           (find-font (font-spec :name "Fira Code")))
  (set-face-attribute 'default nil :font "Fira Code" :height 130))

(use-package nerd-icons)

(use-package gruvbox-theme)
(use-package leuven-theme)
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (doom-themes-visual-bell-config)
  (setq doom-themes-treemacs-theme "doom-colors")
  (doom-themes-treemacs-config))

(load-theme 'gruvbox-dark-hard t)

(provide 'ymacs-ui)
;;; ymacs-ui.el ends here
