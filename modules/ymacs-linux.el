;;; ymacs-linux.el --- linux specific settings.

(use-package exec-path-from-shell
  :ensure t
  :init
  ;; (setq exec-path-from-shell-debug t)
  (message "Should be running exec-path-from-shell-initialize")
  (exec-path-from-shell-initialize)
  )

(provide 'ymacs-linux)
