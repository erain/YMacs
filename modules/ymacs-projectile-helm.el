;;; ymacs-projectile-helm.el --- helm + projectile -*- lexical-binding: t; -*-
;;
;; References:
;; - https://tuhdo.github.io/helm-intro.html
;; - https://tuhdo.github.io/helm-projectile.html

(require 'ymacs-packages)

(use-package helm
  :diminish helm-mode
  :bind (("M-x"     . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("M-y"     . helm-show-kill-ring)
         ("C-x b"   . helm-mini)
         ("C-x C-b" . helm-buffers-list)
         ("C-h f"   . helm-apropos)
         ("C-h r"   . helm-info-emacs)
         ("C-h C-l" . helm-locate-library)
         ("C-c h o" . helm-occur))
  :init
  (setq helm-M-x-fuzzy-match                  t
        helm-split-window-inside-p            t
        helm-buffers-fuzzy-matching           t
        helm-move-to-line-cycle-in-source     t
        helm-ff-search-library-in-sexp        t
        helm-display-header-line              nil
        helm-ff-file-name-history-use-recentf t)
  :config
  (helm-mode 1)
  (helm-autoresize-mode 1)
  (define-key helm-map (kbd "TAB")   #'helm-execute-persistent-action)
  (define-key helm-map (kbd "<tab>") #'helm-execute-persistent-action)
  (define-key helm-map (kbd "C-j")   #'helm-select-action))

(use-package helm-descbinds
  :after helm
  :config (helm-descbinds-mode))

(use-package swiper-helm
  :bind ("C-s" . swiper-helm))

(use-package projectile
  :diminish projectile-mode
  :init
  (setq projectile-cache-file
        (expand-file-name "projectile.cache" ymacs-savefile-dir))
  :config
  (projectile-mode 1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package helm-projectile
  :after (helm projectile)
  :bind ("C-c a g" . helm-projectile-ag)
  :config (helm-projectile-on))

(provide 'ymacs-projectile-helm)
;;; ymacs-projectile-helm.el ends here
