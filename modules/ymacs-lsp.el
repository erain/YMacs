;;; ymacs-lsp.el --- lsp + company-mode configs

(use-package ccls
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp))))


(use-package flycheck
  :ensure t
  :init
  (global-flycheck-mode)
  )


(use-package yasnippet                  ; Snippets
  :ensure t
  :config
  (use-package yasnippet-snippets       ; Collection of snippets
    :ensure t)
  (yas-global-mode t))


(use-package company
  :config
  (setq company-dabbrev-other-buffers t
        company-dabbrev-code-other-buffers t
        ;; Allow (lengthy) numbers to be eligible for completion.
        company-complete-number t
        ;; M-⟪num⟫ to select an option according to its number.
        company-show-numbers t
        ;; Only 2 letters required for completion to activate.
        company-minimum-prefix-length 2
        ;; Do not downcase completions by default.
        company-dabbrev-downcase nil
        ;; Even if I write something with the ‘wrong’ case,
        ;; provide the ‘correct’ casing.
        company-dabbrev-ignore-case t
        ;; Immediately activate completion.
        company-idle-delay 0
        )

  (global-company-mode 1)
  )


(use-package company-quickhelp
  :config
  (setq company-quickhelp-delay 0.1)
  (company-quickhelp-mode)
  )


(use-package company-lsp
  :requires company
  :commands company-lsp
  :config
  (push 'company-lsp company-backends)

  ;; Disable client-side cache because the LSP server does a better job.
  (setq company-transformers nil
        company-lsp-async t
        company-lsp-cache-candidates nil))


(use-package hydra
  :defer 2
  :bind ("C-c C-l" . hydra-lsp/body))


(defhydra hydra-lsp (:exit t :hint nil)
  "
 Buffer^^               Server^^                   Symbol
-------------------------------------------------------------------------------------
 [_f_] format           [_M-r_] restart            [_D_] declaration  [_i_] implementation  [_o_] documentation
 [_m_] imenu            [_S_]   shutdown           [_d_] definition   [_t_] type            [_R_] rename
 [_x_] execute action   [_M-s_] describe session   [_r_] references   [_s_] signature"
  ("D" lsp-find-declaration)
  ("d" lsp-ui-peek-find-definitions)
  ("r" lsp-ui-peek-find-references)
  ("i" lsp-ui-peek-find-implementation)
  ("t" lsp-find-type-definition)
  ("s" lsp-signature-help)
  ("o" lsp-describe-thing-at-point)
  ("R" lsp-rename)

  ("f" lsp-format-buffer)
  ("m" lsp-ui-imenu)
  ("x" lsp-execute-code-action)

  ("M-s" lsp-describe-session)
  ("M-r" lsp-restart-workspace)
  ("S" lsp-shutdown-workspace))


(use-package lsp-mode
  :ensure t
  :commands lsp
  :init
  (setq   lsp-gopls-server-path "gopls"
	  lsp-gopls-server-args '("--debug=localhost:6060"))
  :hook
  (go-mode . #'lsp)
  (python-mode . #'lsp)
  :config
  (setq lsp-prefer-flymake nil          ; Prefer using lsp-ui (flycheck) over flymake
        lsp-enable-xref t
        lsp-enable-snippet t)
  (setq-default flycheck-disabled-checkers
                '(c/c++-clang c/c++-cppcheck c/c++-gcc))
  )


(use-package lsp-ui
  :commands lsp-ui-mode
  :hook
  (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-doc-use-childframe t
        lsp-ui-doc-position 'top
        lsp-ui-doc-include-signature t
        lsp-ui-sideline-enable nil
        lsp-ui-flycheck-enable t
        lsp-ui-flycheck-list-position 'right
        lsp-ui-flycheck-live-reporting t
        lsp-ui-peek-enable t
        lsp-ui-peek-list-width 60
        lsp-ui-peek-peek-height 25)
  )


(provide 'ymacs-lsp)
