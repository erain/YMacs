(use-package counsel
  :after ivy
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file))
  :config (counsel-mode))

(use-package ivy
  :defer 0.1
  :diminish
  :bind (("C-c C-r" . ivy-resume)
	 ("C-x C-q" . ivy-wgrep-change-to-wgrep-mode)
	 ("C-c C-s" . wgrep-auto-save-buffer)
	 ("C-c C-o" . ivy-occur)
	 )
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config (ivy-mode 1))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper)
	 ))

(use-package avy
  :ensure t
  :bind ("M-s" . avy-goto-char))

(provide 'ymacs-ivy)
