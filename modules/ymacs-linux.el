;;; ymacs-linux.el --- Linux-specific settings -*- lexical-binding: t; -*-

(use-package exec-path-from-shell
  :init
  (setq exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-initialize))

(provide 'ymacs-linux)
;;; ymacs-linux.el ends here
