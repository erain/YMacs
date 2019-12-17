;;; ymacs-packages.el

;; Take care of the automatic installation of all the package required by
;; Ymacs

(require 'cl)
(require 'package)

(setq package-archives
      '(("marmalade"   . "http://marmalade-repo.org/packages/")
        ("gnu"         . "http://elpa.gnu.org/packages/")
        ("org"         . "http://orgmode.org/elpa/")
        ("melpa"       . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")))

;; set package-user-dir to be relative to Prelude install path
(setq package-user-dir (expand-file-name "elpa" ymacs-dir))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(provide 'ymacs-packages)

