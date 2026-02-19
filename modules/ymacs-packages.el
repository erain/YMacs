;;; ymacs-packages.el

;; Take care of the automatic installation of all the package required by
;; Ymacs

(require 'cl-lib)
(require 'package)

(setq package-archives
      '(;; It seems marmalade repo has something wrong when connecting
        ;; ("marmalade"   . "http://marmalade-repo.org/packages/")
        ;; Not that useful since not using org mode extensively
        ;; ("org"         . "http://orgmode.org/elpa/")
        ("gnu"         . "https://elpa.gnu.org/packages/")
        ("melpa"       . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")))

;; set package-user-dir to be relative to Prelude install path
(setq package-user-dir (expand-file-name "elpa" ymacs-dir))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(provide 'ymacs-packages)
