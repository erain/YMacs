;;; ymacs-macos.el --- macOS specific settings.

(use-package exec-path-from-shell
  :ensure t
  :init
  ;; (setq exec-path-from-shell-debug t)
  (message "Should be running exec-path-from-shell-initialize")
  (setq exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-initialize)
  )

;; It's all in the Meta
(setq ns-function-modifier 'hyper)

;; There's no point in hiding the menu bar on macOS, so let's not do it
(menu-bar-mode +1)

;; Enable emoji, and stop the UI from freezing when trying to display them.
(when (fboundp 'set-fontset-font)
  (set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend))

;; Enable quick ui focus
(x-focus-frame nil)

;; Open files in the same window
;; https://www.reddit.com/r/emacs/comments/f81ei5/emacs_on_macos_having_files_open_in_same_window/
(setq ns-pop-up-frames nil)

;; start the emacsserver that listens to emacsclient
(server-start)

(provide 'ymacs-macos)
;;; prelude-macos.el ends here
