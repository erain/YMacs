;;; early-init.el --- Pre-init configuration -*- lexical-binding: t; -*-
;;
;; Runs before package.el and the first frame is created (Emacs 27+).

;; Defer GC and disable the file-name-handler during startup.
(defvar ymacs--file-name-handler-alist file-name-handler-alist)
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      file-name-handler-alist nil)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 50 1024 1024)
                  gc-cons-percentage 0.1
                  file-name-handler-alist ymacs--file-name-handler-alist)))

;; Kill UI chrome before the first frame is drawn (no flash).
(push '(menu-bar-lines . 0)   default-frame-alist)
(push '(tool-bar-lines . 0)   default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq inhibit-startup-screen t
      inhibit-startup-message t
      initial-scratch-message nil)

;; Native compilation hygiene.
(when (and (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (setq native-comp-async-report-warnings-errors 'silent
        package-native-compile t))

;; lsp-mode reads this before its byte-compiled modules load.
(setenv "LSP_USE_PLISTS" "true")

;; init.el calls `package-initialize' itself after configuring archives.
(setq package-enable-at-startup nil)

;;; early-init.el ends here
