;;; ymacs-core.el --- Ymacs: Core functions.

(require 'thingatpt)
(require 'cl-lib)

(defun ymacs-recompile-init ()
  "Byte-compile all your dotfiles again."
  (interactive)
  (byte-recompile-directory ymacs-dir 0))

;; enable the copy and past from X
(setq select-enable-clipboard t)

;; Enable mouse support
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] (lambda ()
                              (interactive)
                              (scroll-down 1)))
  (global-set-key [mouse-5] (lambda ()
                              (interactive)
                              (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
  )

;; username and email
(setq user-full-name "Yi Yu")
(setq user-mail-address "YiYu@Ymail.com")


;; Death to the tabs!  However, tabs historically indent to the next
;; 8-character offset; specifying anything else will cause *mass*
;; confusion, as it will change the appearance of every existing file.
;; In some cases (python), even worse -- it will change the semantics
;; (meaning) of the program.
;;
;; Emacs modes typically provide a standard means to change the
;; indentation width -- eg. c-basic-offset: use that to adjust your
;; personal indentation width, while maintaining the style (and
;; meaning) of any files you load.
(setq-default indent-tabs-mode nil)   ;; don't use tabs to indent
(setq-default tab-width 8)            ;; but maintain correct appearance

;; Newline at end of file
(setq require-final-newline t)

;; delete the selection with a keypress
(delete-selection-mode t)

;; store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; autosave the undo-tree history
(setq undo-tree-history-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq undo-tree-auto-save-history t)

;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

;; hippie expand is dabbrev expand on steroids
(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-dabbrev-all-buffers
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name-partially
                                         try-complete-file-name
                                         try-expand-all-abbrevs
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))

;; smart tab behavior - indent or complete
(setq tab-always-indent 'complete)

;; smart pairing
(use-package smartparens
  :config
  (require 'smartparens-config)
  (setq sp-base-key-bindings 'paredit)
  (setq sp-autoskip-closing-pair 'always)
  (setq sp-hybrid-kill-entire-symbol nil)
  (sp-use-paredit-bindings)
  (show-smartparens-global-mode t))

;; disable annoying blink-matching-paren
(setq blink-matching-paren nil)

;; diminish keeps the modeline tidy
(use-package diminish)

;; meaningful names for buffers with the same name
(require  'uniquify)
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

;; saveplace remembers your location in a file when saving files
(setq save-place-file (expand-file-name "saveplace" ymacs-savefile-dir))
;; activate it for all buffers
(save-place-mode 1)

;; savehist keeps track of some history
(use-package savehist
  :config
  (setq savehist-additional-variables
	;; search entries
	'(search-ring regexp-search-ring)
	;; save every minute
	savehist-autosave-interval 60
	;; keep the home clean
	savehist-file (expand-file-name "savehist" ymacs-savefile-dir))
  (savehist-mode t)
  )

;; save recent files
(use-package recentf
  :config
  (setq recentf-save-file (expand-file-name "recentf" ymacs-savefile-dir)
	recentf-max-saved-items 500
	recentf-max-menu-items 15
	;; disable recentf-cleanup on Emacs start, because it can cause
	;; problems with remote files
	recentf-auto-cleanup 'never)
  (recentf-mode t)
  )

;; use shift + arrow keys to switch between visible buffers
(use-package windmove
  :config
  (windmove-default-keybindings)
  )

;; automatically save buffers associated with files on buffer switch
;; and on windows switch
(use-package super-save
  :requires ace-window
  :config
  ;; add integration with ace-window
  (add-to-list 'super-save-triggers 'ace-window)
  (super-save-mode t)
  )

;; enable narrowing commands
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

;; enabled change region case commands
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; enable erase-buffer command
(put 'erase-buffer 'disabled nil)

(use-package expand-region)

;; bookmarks
(require 'bookmark)
(setq bookmark-default-file (expand-file-name "bookmarks" ymacs-savefile-dir)
      bookmark-save-flag t)

;; avy allows us to effectively navigate to visible things
(use-package avy
  :config
  (setq avy-background t)
  (setq avy-style 'at-full)
  )

;; anzu-mode enhances isearch & query-replace by showing total matches and current match position
(use-package anzu
  :config
  (diminish 'anzu-mode)
  (global-anzu-mode)
  (global-set-key (kbd "M-%") 'anzu-query-replace)
  (global-set-key (kbd "C-M-%") 'anzu-query-replace-regexp)
  )

;; dired
;; reuse current buffer by pressing 'a'
(put 'dired-find-alternate-file 'disabled nil)
;; always delete and copy recursively
(setq dired-recursive-deletes 'always)
(setq dired-recursive-copies 'always)
;; if there is a dired buffer displayed in the next window, use its
;; current subdir, instead of the current subdir of this dired buffer
(setq dired-dwim-target t)
;; enable some really cool extensions like C-x C-j(dired-jump)
(require 'dired-x)

;; ediff - don't start another frame
(require 'ediff)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;; smarter kill-ring navigation
(use-package browse-kill-ring
  :config
  (browse-kill-ring-default-keybindings)
  (global-set-key (kbd "s-y") 'browse-kill-ring)
  )

;; make a shell script executable automatically on save
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)

;; .zsh file is shell script too
(add-to-list 'auto-mode-alist '("\\.zsh\\'" . shell-script-mode))

;; install and use magit
(use-package magit)

;; install and use neotree
(use-package neotree
  :config
  (global-set-key [f8] 'neotree-toggle)
  )

;; mwim moves smartly
(use-package mwim
  :bind
  ("C-a" . mwim-beginning-of-code-or-line)
  ("C-e" . mwim-end-of-code-or-line))


(provide 'ymacs-core)
