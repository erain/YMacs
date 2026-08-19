;;; ymacs-packages.el --- Package archives + use-package bootstrap -*- lexical-binding: t; -*-
(defvar ymacs-dir user-emacs-directory
  "The root dir of the YMacs distribution.")
(defvar ymacs-modules-dir (expand-file-name "modules" ymacs-dir)
  "The directory housing all of the modules.")
(defvar ymacs-savefile-dir (expand-file-name "savefile" ymacs-dir)
  "The folder for automatically generated save/history files.")

(require 'package)

(setq package-archives
      '(("gnu"          . "https://elpa.gnu.org/packages/")
        ("nongnu"       . "https://elpa.nongnu.org/nongnu/")
        ("melpa"        . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")))

(setq package-user-dir (expand-file-name "elpa" ymacs-dir))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; `use-package' is built-in since Emacs 29.1.
(require 'use-package)
(setq use-package-always-ensure t
      use-package-expand-minimally t)

;; Auto-refresh archive contents if package installation fails (e.g. stale rolling-release versions).
(advice-add 'use-package-ensure-elpa :around
            (lambda (orig-fn package args state &optional no-refresh)
              (let ((package-name (or (car-safe package) package)))
                (if (package-installed-p package-name)
                    (apply orig-fn package args state no-refresh)
                  (unless (assoc package-name package-archive-contents)
                    (package-refresh-contents))
                  (condition-case nil
                      (apply orig-fn package args state no-refresh)
                    (error
                     (package-refresh-contents)
                     (apply orig-fn package args state t)))))))

(provide 'ymacs-packages)
;;; ymacs-packages.el ends here
