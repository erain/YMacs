;;; ymacs-macos.el --- macOS-specific settings -*- lexical-binding: t; -*-

(require 'ymacs-packages)

(use-package exec-path-from-shell
  :if (not noninteractive)
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-initialize))

;; All in the Meta — fn becomes Hyper.
(setq ns-function-modifier 'hyper)

;; Re-enable the menu bar — there's no display cost on macOS.
(menu-bar-mode 1)

;; GUI font families, emoji and Unicode fallbacks are configured in
;; `ymacs-ui' so daemon/client frames share the same setup.

;; Open files in the same frame.
(setq ns-pop-up-frames nil)

(provide 'ymacs-macos)
;;; ymacs-macos.el ends here
