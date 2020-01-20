;;; ymacs-programming.el --- a bunch of programming langeuage related mode

(use-package markdown-mode

  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


(use-package go-mode
  :config
  (setq tab-width 2)
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))


(provide 'ymacs-programming)
;;; ymacs-programming.el ends here
