;;;; init.el --- YMacs configuration entry point

(defvar current-user
  (getenv "USER"))

(message "YMacs is powering up... Be patient, Master %s!" current-user)

(when (version< emacs-version "25.1")
  (error "YMacs requires GNU Emacs 25.1 or newer, but you're running %s" emacs-version))

;; Always load newest byte code
(setq load-prefer-newer t)

(defvar ymacs-dir (file-name-directory load-file-name)
  "The root dir of the YMacs distribution.")
(defvar ymacs-modules-dir (expand-file-name "modules" ymacs-dir)
  "The directory houses all of the modules.")
(defvar ymacs-vendor-dir (expand-file-name "vendor" ymacs-dir)
  "The directory houses all of the vendored modules. (e.g. env related)")
(defvar ymacs-savefile-dir (expand-file-name "savefile" ymacs-dir)
  "This folder stores all the automatically generated save/history-files.")
(unless (file-exists-p ymacs-savefile-dir)
  (make-directory ymacs-savefile-dir))

;; config changes made through the customize UI will be stored here
(setq custom-file (expand-file-name "custom.el" ymacs-modules-dir))

;; add modules directories to Emacs's `load-path'
(add-to-list 'load-path ymacs-modules-dir)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;; Load the modules one by one
(message "Loading Ymacs' modules...")
(require 'ymacs-packages)
(require 'ymacs-ui)
(require 'ymacs-core)
(require 'ymacs-global-keybindings)
(require 'ymacs-ivy)
(require 'ymacs-projectile-helm)
(require 'ymacs-programming)
(require 'ymacs-lsp)
(require 'ymacs-eshell)

;; macOS specific settings
(when (eq system-type 'darwin)
  (require 'ymacs-macos))

;; Linux specific settings
(when (eq system-type 'gnu/linux)
  (require 'ymacs-linux))

;; load all vendor configs
(mapc 'load (file-expand-wildcards (expand-file-name "*.el" ymacs-vendor-dir)))
