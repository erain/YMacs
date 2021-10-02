;;; ymacs-ui.el -- UI optimization and tweaks.

;; the toolbar is just a waste of valuable screen estate
;; in a tty tool-bar-mode does not properly auto-load, and is
;; already disabled anyway
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(menu-bar-mode -1)

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

;; Makr cursor as bar instead of block
(setq-default cursor-type 'bar)

;; disable the annoying bell ring
(setq ring-bell-function 'ignore)

;; disable startup screen
(setq inhibit-startup-screen t)

;; nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; mode line settings
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; more useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
(setq frame-title-format
      '("" invocation-name " Prelude - " (:eval (if (buffer-file-name)
                                            (abbreviate-file-name (buffer-file-name))
                                            "%b"))))

;; highlight current line:
(use-package hl-line
  :init (global-hl-line-mode 1))

;; whitespace-mode config
(use-package whitespace
  :config
  (setq whitespace-line-column 100) ;; limit line length
  (setq whitespace-style '(face tabs empty trailing lines-tail))
  )

(use-package beacon
  :config
  (beacon-mode t))

(use-package which-key
  :config
  (which-key-mode t))

;; font settings
(set-frame-font "-*-Fira Code-normal-normal-normal-*-13-*-*-*-m-0-iso10646-1")

;; icons
(use-package all-the-icons
    :ensure t)

;; install and set theme for terminal / X
(use-package gruvbox-theme)
(use-package leuven-theme)
(use-package doom-themes
  :config

  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
  (doom-themes-treemacs-config)
  )
(if (display-graphic-p)
  ;; (load-theme 'leuven t)
  (load-theme 'doom-tomorrow-day t)
  ;; (load-theme 'gruvbox-light-hard t)
(load-theme 'gruvbox-dark-hard t)
;; (load-theme 'doom-vibrant t)
)

(provide 'ymacs-ui)
