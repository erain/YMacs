;;; ymacs-company.el --- company-mode configs

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

(provide 'ymacs-company)
