;;; ymacs-programming.el --- Programming language modes -*- lexical-binding: t; -*-

;; Markdown: GitHub-flavoured editing, pleasant prose layout and previews.
(require 'ispell)

(use-package flyspell
  :ensure nil
  :commands flyspell-mode)

(defun ymacs-markdown-command ()
  "Return the best installed Markdown-to-HTML command."
  (cond
   ((executable-find "pandoc") "pandoc --from=gfm --to=html5 --standalone")
   ((executable-find "multimarkdown") "multimarkdown")
   ((executable-find "cmark-gfm") "cmark-gfm")
   ((executable-find "cmark") "cmark")
   ((executable-find "markdown") "markdown")
   (t "multimarkdown")))

(defun ymacs-markdown--locale-dictionary ()
  "Return the current locale's dictionary name, e.g. en_US."
  (let* ((locale (or (getenv "LC_ALL")
                     (getenv "LC_CTYPE")
                     (getenv "LANG")
                     ""))
         (dict (car (split-string locale "[.@]"))))
    (unless (string= dict "")
      dict)))

(defun ymacs-markdown--hunspell-dictionary ()
  "Return the first available Hunspell dictionary for Markdown."
  (catch 'dict
    (dolist (dict (append (list (ymacs-markdown--locale-dictionary))
                          '("en_US" "en_CA")))
      (when (and dict
                 (or (file-exists-p (expand-file-name
                                     (concat dict ".dic") "~/Library/Spelling"))
                     (file-exists-p (format "/Library/Spelling/%s.dic" dict))
                     (file-exists-p (format "/opt/homebrew/share/hunspell/%s.dic" dict))
                     (file-exists-p (format "/usr/share/hunspell/%s.dic" dict))))
        (throw 'dict dict)))))

(defun ymacs-markdown-enable-spell-check ()
  "Enable `flyspell-mode' with the best available spell checker."
  (when (fboundp 'flyspell-mode)
    (cond
     ((executable-find "hunspell")
      (let ((dict (ymacs-markdown--hunspell-dictionary)))
        (when dict
          (setq-local ispell-program-name "hunspell"
                      ispell-dictionary dict
                      ispell-local-dictionary dict
                      ispell-local-dictionary-alist
                      `((,dict "[[:alpha:]]" "[^[:alpha:]]" "[']" nil
                               ("-d" ,dict) nil utf-8)))
          (flyspell-mode 1))))
     ((or (executable-find "aspell")
          (executable-find "ispell"))
      (flyspell-mode 1)))))

(defun ymacs-markdown-mode-setup ()
  "Make Markdown buffers comfortable for writing and reading."
  (setq-local fill-column 100
              markdown-command (ymacs-markdown-command))
  (visual-line-mode 1)
  (when (fboundp 'visual-fill-column-mode)
    (setq-local visual-fill-column-width 100
                visual-fill-column-center-text t)
    (visual-fill-column-mode 1))
  (when (and (display-graphic-p)
             (fboundp 'mixed-pitch-mode))
    (mixed-pitch-mode 1))
  (ymacs-markdown-enable-spell-check))

(use-package visual-fill-column
  :commands visual-fill-column-mode)

(use-package mixed-pitch
  :commands mixed-pitch-mode)

;; `markdown-edit-code-block' uses this for C-c ' fenced-code editing.
(use-package edit-indirect
  :defer t)

(use-package markdown-mode
  :commands (markdown-mode gfm-mode markdown-view-mode gfm-view-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.mdx\\'" . gfm-mode)
         ("\\.md\\'" . gfm-mode)
         ("\\.markdown\\'" . markdown-mode))
  :hook (markdown-mode . ymacs-markdown-mode-setup)
  :init
  (setq markdown-enable-math t
        markdown-fontify-code-blocks-natively t
        markdown-gfm-uppercase-checkbox t
        markdown-make-gfm-checkboxes-buttons t)
  :config
  (define-key markdown-mode-command-map (kbd "I") #'markdown-toggle-inline-images))

(use-package markdown-toc
  :commands (markdown-toc-generate-toc markdown-toc-refresh-toc))

;; GitHub-accurate browser preview when the external `grip' command is present.
(use-package grip-mode
  :commands grip-mode
  :after markdown-mode
  :config
  (define-key markdown-mode-command-map (kbd "g") #'grip-mode))


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
