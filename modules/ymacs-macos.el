;;; ymacs-macos.el --- macOS-specific settings -*- lexical-binding: t; -*-

(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-initialize))

;; All in the Meta — fn becomes Hyper.
(setq ns-function-modifier 'hyper)

;; Re-enable the menu bar — there's no display cost on macOS.
(menu-bar-mode 1)

;; Native emoji rendering without UI freezes.
(when (fboundp 'set-fontset-font)
  (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))

;; Open files in the same frame.
(setq ns-pop-up-frames nil)

(provide 'ymacs-macos)
;;; ymacs-macos.el ends here
