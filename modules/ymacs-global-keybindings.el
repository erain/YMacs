;;; ymacs-global-keybindings.el --- Some useful keybindings -*- lexical-binding: t; -*-

(require 'ymacs-packages)

;; crux related
(use-package crux)


;; Align your code in a pretty way.
(global-set-key (kbd "C-x \\") 'align-regexp)

;; Font size
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)

;; Window switching. (C-x o goes to the next window)
(global-set-key (kbd "C-x O") (lambda ()
                                (interactive)
                                (other-window -1))) ;; back one


;; kill lines backward
(global-set-key (kbd "C-<backspace>") (lambda ()
                                        (interactive)
                                        (kill-line 0)
                                        (indent-according-to-mode)))

(global-set-key [remap kill-line] 'crux-smart-kill-line)

;; use hippie-expand instead of dabbrev
(global-set-key (kbd "M-/") 'hippie-expand)

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x M-g") 'magit-dispatch)

(global-set-key (kbd "M-z") 'er/expand-region)

(global-set-key (kbd "C-c m") 'imenu)

;; avy `C-c j' / `s-.' bindings live in ymacs-core.el alongside the use-package decl.

(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s(") (forward-list 1) (backward-char 1))
        ((looking-at "\\s)") (forward-char 1) (backward-list 1))
        (t (self-insert-command (or arg 1)))))
(global-set-key (kbd "%") 'match-paren)

;; improved window navigation with ace-window
(use-package ace-window)
(global-set-key (kbd "M-o") 'ace-window)
(global-set-key [remap other-window] 'ace-window)

;; enable shift + mouse selection
(define-key global-map (kbd "<S-down-mouse-1>") 'mouse-save-then-kill)

(provide 'ymacs-global-keybindings)
