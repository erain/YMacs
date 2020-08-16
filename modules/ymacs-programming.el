;;; ymacs-programming.el --- a bunch of programming langeuage related mode

(use-package markdown-mode

  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


(use-package go-mode
  :config
  (add-hook 'go-mode-hook (lambda ()
			    (setq tab-width 2)
			    (setq indent-tabs-mode nil) ))
  (setq gofmt-command (cond
		       ((executable-find "goimports")
			"goimports")
		       (t "gofmt")))
  )


(defun ymacs-c-mode-common-hook ()
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (setq indent-tabs-mode t)
  )
(add-hook 'c-mode-common-hook 'ymacs-c-mode-common-hook)

(provide 'ymacs-programming)
;;; ymacs-programming.el ends here
