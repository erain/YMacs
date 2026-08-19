;;; ymacs-lsp.el --- lsp-mode + company + flycheck -*- lexical-binding: t; -*-

;; Bigger pipe to language servers; default 4 KB chokes pyright/gopls.
(require 'ymacs-packages)
(setq read-process-output-max (* 4 1024 1024))

(defun ymacs-lsp-markdown-maybe-start ()
  "Start Marksman for Markdown buffers when the server is installed."
  (when (and (executable-find "marksman")
             (require 'lsp-marksman nil t))
    (lsp-deferred)))

(use-package flycheck
  :init (global-flycheck-mode))

(use-package yasnippet
  :commands yas-minor-mode
  :hook ((go-mode . yas-minor-mode)
         (c-mode  . yas-minor-mode))
  :config (use-package yasnippet-snippets))

(use-package company
  :diminish company-mode
  :config
  (setq company-dabbrev-other-buffers      t
        company-dabbrev-code-other-buffers t
        company-show-quick-access          t
        company-minimum-prefix-length      2
        company-dabbrev-downcase           nil
        company-dabbrev-ignore-case        t
        company-idle-delay                 0)
  (global-company-mode 1))

;; company-quickhelp uses pos-tip frames — graphical only.
(use-package company-quickhelp
  :if (display-graphic-p)
  :after company
  :config
  (setq company-quickhelp-delay 0.1)
  (company-quickhelp-mode))

(eval-when-compile
  (require 'hydra))

(use-package hydra
  :bind ("C-c l" . hydra-lsp/body)
  :config
  (defhydra hydra-lsp (:exit t :hint nil)
    "
 Buffer^^               Server^^                   Symbol
-------------------------------------------------------------------------------------
 [_f_] format           [_M-r_] restart            [_D_] declaration  [_i_] implementation  [_o_] documentation
 [_m_] imenu            [_S_]   shutdown           [_d_] definition   [_t_] type            [_R_] rename
 [_x_] execute action   [_M-s_] describe session   [_r_] references   [_s_] signature"
    ("D"   lsp-find-declaration)
    ("d"   lsp-ui-peek-find-definitions)
    ("r"   lsp-ui-peek-find-references)
    ("i"   lsp-ui-peek-find-implementation)
    ("t"   lsp-find-type-definition)
    ("s"   lsp-signature-help)
    ("o"   lsp-describe-thing-at-point)
    ("R"   lsp-rename)
    ("f"   lsp-format-buffer)
    ("m"   lsp-ui-imenu)
    ("x"   lsp-execute-code-action)
    ("M-s" lsp-describe-session)
    ("M-r" lsp-workspace-restart)
    ("S"   lsp-workspace-shutdown)))

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-gopls-server-path  "gopls"
        lsp-enable-file-watchers t
        lsp-diagnostics-provider :flycheck
        lsp-enable-xref          t
        lsp-enable-snippet       t
        lsp-keymap-prefix        "C-c L")
  :hook ((go-mode       . lsp-deferred)
         (python-mode   . lsp-deferred)
         (c-mode        . lsp-deferred)
         (c++-mode      . lsp-deferred)
         (markdown-mode . ymacs-lsp-markdown-maybe-start))
  :config
  (setq-default flycheck-disabled-checkers
                '(c/c++-clang c/c++-cppcheck c/c++-gcc)))

(use-package lsp-ui
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :config
  ;; child-frames + doc-popup require a GUI; disable in tty.
  (let ((gui (display-graphic-p)))
    (setq lsp-ui-doc-enable            gui
          lsp-ui-doc-use-childframe    gui
          lsp-ui-doc-position          'top
          lsp-ui-doc-include-signature t
          lsp-ui-sideline-enable       nil
          lsp-ui-peek-enable           t
          lsp-ui-peek-list-width       60
          lsp-ui-peek-peek-height      25)))

(use-package ccls
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
         (lambda () (require 'ccls) (lsp-deferred))))

;; Format + organize imports on save for Go.
(defun ymacs-lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer    nil t)
  (add-hook 'before-save-hook #'lsp-organize-imports nil t))
(add-hook 'go-mode-hook #'ymacs-lsp-go-install-save-hooks)

(provide 'ymacs-lsp)
;;; ymacs-lsp.el ends here
