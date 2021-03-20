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
(global-hl-line-mode nil)

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

;; install and set theme for terminal / X
(use-package gruvbox-theme)
(use-package doom-themes)
(if (display-graphic-p)
    ;; (load-theme 'leuven t)
    (load-theme 'doom-gruvbox t)
  (load-theme 'gruvbox-dark-hard t))

(provide 'ymacs-ui)
