;;; ymacs-projectile-helm.el --- projectile and helm related settings

;; More reference:
;; - https://tuhdo.github.io/helm-intro.html
;; - https://tuhdo.github.io/helm-projectile.html

(use-package helm
  :diminish helm-mode
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("M-y" . helm-show-kill-ring)
         ("C-x b" . helm-mini)
         ("C-x C-b" . helm-buffers-list)
         ("C-x C-f" . helm-find-files)
         ("C-h f" . helm-apropos)
         ("C-h r" . helm-info-emacs)
         ("C-h C-l" . helm-locale-library)
         ("C-c h o" . helm-occur)
         )
  :init
  (use-package helm-descbinds
    :config
    (helm-descbinds-mode))
  (setq helm-M-x-fuzzy-match                  t
        helm-split-window-in-side-p           t
        helm-buffers-fuzzy-matching           t
        helm-move-to-line-cycle-in-source     t
        helm-ff-search-library-in-sexp        t
        helm-display-header-line              nil
        helm-ff-file-name-history-use-recentf t
        )
  :config
  ;; No idea why here find-file is set to nil (so it uses the native find-file
  ;; for Emacs. This makes stuff like (find-file (read-file-name ...)) work with
  ;; Helm again.
  (helm-mode 1)
  (helm-autoresize-mode 1)
  (define-key helm-map (kbd "TAB") #'helm-execute-persistent-action)
  (define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
  (define-key helm-map (kbd "C-j") #'helm-select-action)
  (add-to-list 'helm-completing-read-handlers-alist '(find-file . helm-completing-read-symbols)))

(use-package helm-ag
  :bind ("C-c a g" . helm-do-ag-project-root))

(use-package swiper-helm
  :bind ("C-s" . swiper-helm))

;; Project management.
(use-package projectile
  :commands (projectile-find-file projectile-switch-project)
  :diminish projectile-mode
  :init
  (use-package helm-projectile
    :ensure t
    :config
    (helm-projectile-on)
    )
  :config
  (setq projectile-cache-file (expand-file-name  "projectile.cache" ymacs-savefile-dir))
  (projectile-global-mode)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  )

(provide 'ymacs-projectile-helm)
