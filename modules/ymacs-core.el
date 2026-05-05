;;; ymacs-core.el --- Editing fundamentals -*- lexical-binding: t; -*-

(require 'thingatpt)
(require 'cl-lib)

(defun ymacs-recompile-init ()
  "Byte-compile all of YMacs again."
  (interactive)
  (byte-recompile-directory ymacs-dir 0))

(setq select-enable-clipboard t)

;; tty mouse support.
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode 1)
  (global-set-key [mouse-4] (lambda () (interactive) (scroll-down 1)))
  (global-set-key [mouse-5] (lambda () (interactive) (scroll-up 1))))

(setq user-full-name "Yi Yu"
      user-mail-address "YiYu@Ymail.com")

(setq require-final-newline t)
(delete-selection-mode 1)

;; Backups, autosaves, undo-tree history → tmp.
(setq backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
      undo-tree-history-directory-alist `((".*" . ,temporary-file-directory))
      undo-tree-auto-save-history t)

;; Auto-revert files and Dired/buffer-list when they change on disk.
(setq global-auto-revert-non-file-buffers t)
(global-auto-revert-mode 1)

(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-list
        try-expand-line
        try-complete-lisp-symbol-partially
        try-complete-lisp-symbol))

(setq tab-always-indent 'complete)

(use-package multiple-cursors
  :bind (("C-M->" . mc/mark-next-symbol-like-this)
         ("C-M-<" . mc/mark-previous-symbol-like-this)
         ("C-M-*" . mc/mark-all-symbols-like-this)))

(use-package smartparens
  :config
  (require 'smartparens-config)
  (setq sp-base-key-bindings 'paredit
        sp-autoskip-closing-pair 'always
        sp-hybrid-kill-entire-symbol nil)
  (sp-use-paredit-bindings)
  (smartparens-global-mode 1))

(setq blink-matching-paren nil)

(use-package diminish)

(require 'uniquify)
(setq uniquify-buffer-name-style 'forward
      uniquify-separator "/"
      uniquify-after-kill-buffer-p t
      uniquify-ignore-buffers-re "^\\*")

(setq save-place-file (expand-file-name "saveplace" ymacs-savefile-dir))
(save-place-mode 1)

(use-package savehist
  :ensure nil
  :init
  (setq savehist-additional-variables '(search-ring regexp-search-ring)
        savehist-autosave-interval 60
        savehist-file (expand-file-name "savehist" ymacs-savefile-dir))
  :config (savehist-mode 1))

(use-package recentf
  :ensure nil
  :init
  (setq recentf-save-file (expand-file-name "recentf" ymacs-savefile-dir)
        recentf-max-saved-items 500
        recentf-max-menu-items 15
        recentf-auto-cleanup 'never)
  :config (recentf-mode 1))

(use-package windmove
  :ensure nil
  :config (windmove-default-keybindings))

(use-package super-save
  :after ace-window
  :diminish super-save-mode
  :config
  (add-to-list 'super-save-triggers 'ace-window)
  (super-save-mode 1))

;; Re-enable advanced commands.
(dolist (cmd '(narrow-to-region narrow-to-page narrow-to-defun
               upcase-region downcase-region erase-buffer
               dired-find-alternate-file))
  (put cmd 'disabled nil))

(use-package expand-region)

(require 'bookmark)
(setq bookmark-default-file (expand-file-name "bookmarks" ymacs-savefile-dir)
      bookmark-save-flag 1)

(use-package avy
  :config
  (setq avy-background t
        avy-style 'at-full)
  :bind (("M-s"  . avy-goto-char)
         ("C-c j" . avy-goto-word-or-subword-1)
         ("s-."   . avy-goto-word-or-subword-1)))

(use-package anzu
  :diminish anzu-mode
  :bind (([remap query-replace]        . anzu-query-replace)
         ([remap query-replace-regexp] . anzu-query-replace-regexp))
  :config (global-anzu-mode 1))

;; Dired.
(setq dired-recursive-deletes 'always
      dired-recursive-copies 'always
      dired-dwim-target t)
(require 'dired-x)

(use-package nerd-icons-dired
  :if (display-graphic-p)
  :hook (dired-mode . nerd-icons-dired-mode))

;; ediff in one frame, side-by-side.
(require 'ediff)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

(use-package browse-kill-ring
  :bind ("s-y" . browse-kill-ring)
  :config (browse-kill-ring-default-keybindings))

;; chmod +x scripts on save.
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

(add-to-list 'auto-mode-alist '("\\.zsh\\'" . shell-script-mode))

(use-package magit)

(use-package mwim
  :bind (("C-a" . mwim-beginning-of-code-or-line)
         ("C-e" . mwim-end-of-code-or-line)))

;; Trim trailing whitespace only on lines you actually touched
;; (markdown's two-trailing-space line break stays intact elsewhere).
(use-package ws-butler
  :diminish ws-butler-mode
  :config (ws-butler-global-mode 1))

(setq vc-follow-symlinks t)

;; Tree-sitter: install grammars on demand and remap *-mode → *-ts-mode.
(use-package treesit-auto
  :custom (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

;; Start the server so emacsclient works on every platform.
(require 'server)
(unless (server-running-p)
  (server-start))

(use-package treemacs
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
        treemacs-deferred-git-apply-delay      0.5
        treemacs-display-in-side-window        t
        treemacs-eldoc-display                 t
        treemacs-file-event-delay              5000
        treemacs-file-follow-delay             0.2
        treemacs-follow-after-init             t
        treemacs-goto-tag-strategy             'refetch-index
        treemacs-indentation                   2
        treemacs-indentation-string            " "
        treemacs-max-git-entries               5000
        treemacs-missing-project-action        'ask
        treemacs-no-png-images                 nil
        treemacs-no-delete-other-windows       t
        treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
        treemacs-position                      'left
        treemacs-recenter-distance             0.1
        treemacs-recenter-after-project-jump   'always
        treemacs-recenter-after-project-expand 'on-distance
        treemacs-show-cursor                   nil
        treemacs-show-hidden-files             t
        treemacs-sorting                       'alphabetic-asc
        treemacs-space-between-root-nodes      t
        treemacs-tag-follow-cleanup            t
        treemacs-tag-follow-delay              1.5
        treemacs-width                         35)
  (treemacs-follow-mode 1)
  (treemacs-filewatch-mode 1)
  (treemacs-fringe-indicator-mode 1)
  (pcase (cons (and (executable-find "git") t)
               (and treemacs-python-executable t))
    (`(t . t) (treemacs-git-mode 'deferred))
    (`(t . _) (treemacs-git-mode 'simple)))
  :bind (:map global-map
              ("M-0"     . treemacs-select-window)
              ("C-x t 1" . treemacs-delete-other-windows)
              ("C-x t t" . treemacs)
              ("C-x t b" . treemacs-bookmark)
              ("C-x t f" . treemacs-find-file)))

(use-package treemacs-projectile :after (treemacs projectile))
(use-package treemacs-magit      :after (treemacs magit))
(use-package treemacs-nerd-icons
  :if (display-graphic-p)
  :after treemacs
  :config (treemacs-load-theme "nerd-icons"))

(provide 'ymacs-core)
;;; ymacs-core.el ends here
