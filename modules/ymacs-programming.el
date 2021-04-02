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


;; Jsonnet mode
(use-package jsonnet-mode
  :ensure t
  :defer t
  :mode ("\\.jsonnet\\'" "\\.libsonnet\\'")
  )


;; solidity mode
(use-package solidity-mode
  :ensure t
  :config
  (use-package solidity-flycheck
    :ensure t)
  (use-package company-solidity
    :ensure t)

  (add-hook 'solidity-mode-hook
	(lambda ()
	(set (make-local-variable 'company-backends)
		(append '((company-solidity company-capf company-dabbrev-code))
			company-backends))))

  (setq solidity-solc-path "/usr/local/bin/solcjs")
  (setq solidity-solium-path "/usr/local/bin/solium")
  (setq solidity-flycheck-solc-checker-active t)
  (setq solidity-flycheck-solium-checker-active t)
  (setq solidity-comment-style 'slash)
  )


;; javascript mode
(setq js-indent-level 2)


(provide 'ymacs-programming)
;;; ymacs-programming.el ends here
