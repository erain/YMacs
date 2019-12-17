;;; ymacs-macos.el --- macOS specific settings.

(use-package exec-path-from-shell)
(exec-path-from-shell-initialize)

;; It's all in the Meta
(setq ns-function-modifier 'hyper)

;; There's no point in hiding the menu bar on macOS, so let's not do it
(menu-bar-mode +1)

;; Enable emoji, and stop the UI from freezing when trying to display them.
(when (fboundp 'set-fontset-font)
  (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))


(provide 'ymacs-macos)
;;; prelude-macos.el ends here

