;;; ymacs-programming.el --- a bunch of programming langeuage related mode

;; Markdown mode
(use-package markdown-mode

  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))


;; Go mode
(use-package go-mode
  :bind ("C-c C-t" . save-and-test-go-program)
  :config
  (add-hook 'go-mode-hook (lambda ()
			    (setq tab-width 2)
			    (setq indent-tabs-mode nil) ))
  (setq gofmt-command (cond
		       ((executable-find "goimports")
			"goimports")
		       (t "gofmt")))
  )

(defun save-and-test-go-program()
  "Save any unsaved buffers and compile"
  (interactive)
  (save-some-buffers t)
  (compile "go test -v")
  )


;; C mode
(defun ymacs-c-mode-common-hook ()
  (setq c-basic-offset 4)
  (setq tab-width 4)
  (setq indent-tabs-mode t)
  )
(add-hook 'c-mode-common-hook 'ymacs-c-mode-common-hook)

(provide 'ymacs-programming)
;;; ymacs-programming.el ends here
