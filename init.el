;;;; init.el --- YMacs configuration entry point -*- lexical-binding: t; -*-

(defvar current-user (getenv "USER"))

(message "YMacs is powering up... Be patient, Master %s!" current-user)

(when (version< emacs-version "29.1")
  (error "YMacs requires GNU Emacs 29.1 or newer, but you're running %s"
         emacs-version))

;; Always load newest byte code.
(setq load-prefer-newer t)

(defvar ymacs-dir (file-name-directory load-file-name)
  "The root dir of the YMacs distribution.")
(defvar ymacs-modules-dir (expand-file-name "modules" ymacs-dir)
  "The directory housing all of the modules.")
(defvar ymacs-vendor-dir (expand-file-name "vendor" ymacs-dir)
  "The directory housing all vendored / per-machine modules.")
(defvar ymacs-savefile-dir (expand-file-name "savefile" ymacs-dir)
  "The folder for automatically generated save/history files.")
(unless (file-exists-p ymacs-savefile-dir)
  (make-directory ymacs-savefile-dir))

;; Customize UI writes here so init.el stays clean.
(setq custom-file (expand-file-name "custom.el" ymacs-modules-dir))

(add-to-list 'load-path ymacs-modules-dir)

;; Warn on opening files larger than 100MB.
(setq large-file-warning-threshold 100000000)

(message "Loading YMacs' modules...")
(require 'ymacs-packages)
(require 'ymacs-ui)
(require 'ymacs-core)
(require 'ymacs-global-keybindings)
(require 'ymacs-projectile-helm)
(require 'ymacs-programming)
(require 'ymacs-lsp)
(require 'ymacs-eshell)

(when (eq system-type 'darwin)
  (require 'ymacs-macos))

(when (eq system-type 'gnu/linux)
  (require 'ymacs-linux))

;; Load every per-machine override under vendor/ (gitignored).
(mapc 'load (file-expand-wildcards (expand-file-name "*.el" ymacs-vendor-dir)))
