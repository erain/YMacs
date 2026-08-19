;;; ymacs-ui.el --- UI tweaks -*- lexical-binding: t; -*-
;;
;; Tool-bar / menu-bar / scroll-bar are killed in early-init.el so the
;; first frame is drawn without them.

(require 'ymacs-packages)

(blink-cursor-mode -1)
(setq-default cursor-type 'bar)

(setq ring-bell-function 'ignore
      use-short-answers t
      scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(line-number-mode 1)
(column-number-mode 1)
(size-indication-mode 1)

(setq frame-title-format
      '("" invocation-name " YMacs - "
        (:eval (if (buffer-file-name)
                   (abbreviate-file-name (buffer-file-name))
                 "%b"))))

;; Smoother trackpad / wheel scrolling (Emacs 29+, GUI only).
(when (and (display-graphic-p)
           (fboundp 'pixel-scroll-precision-mode))
  (pixel-scroll-precision-mode 1))

;; Survive opening minified / very-long-line files.
(global-so-long-mode 1)

;; Repeat-mode: e.g. C-x o o o for `other-window'.
(repeat-mode 1)

(use-package hl-line
  :ensure nil
  :init (global-hl-line-mode 1))

(use-package whitespace
  :ensure nil
  :config
  (setq whitespace-line-column 100
        whitespace-style '(face tabs empty trailing lines-tail)))

;; beacon flashes the cursor on big jumps — only useful in a GUI.
(use-package beacon
  :if (display-graphic-p)
  :diminish beacon-mode
  :config (beacon-mode 1))

;; `which-key' is built-in since Emacs 30.
(use-package which-key
  :ensure nil
  :diminish which-key-mode
  :config (which-key-mode 1))

;; Fonts are GUI-only.  In `emacs -nw' (including Ghostty) Emacs inherits
;; the terminal's font, shaping and ligature settings.
(defgroup ymacs-ui nil
  "Visual settings for YMacs."
  :group 'convenience)

(defcustom ymacs-font-height (if (eq system-type 'darwin) 140 130)
  "Default GUI font height, in 1/10 pt."
  :type 'integer
  :group 'ymacs-ui)

(defcustom ymacs-font-line-spacing 0.08
  "Extra GUI line spacing.  Set to nil to use Emacs' default."
  :type '(choice (const :tag "Default" nil) number)
  :group 'ymacs-ui)

(defcustom ymacs-font-family-candidates
  '("JetBrains Mono"
    "JetBrainsMono Nerd Font Mono"
    "JetBrainsMono Nerd Font"
    "Monaspace Neon"
    "Fira Code"
    "FiraCode Nerd Font Mono"
    "SF Mono"
    "Cascadia Code"
    "Iosevka"
    "Hack"
    "Source Code Pro"
    "Menlo"
    "Monaco"
    "DejaVu Sans Mono")
  "Preferred monospace font families, first installed font wins."
  :type '(repeat string)
  :group 'ymacs-ui)

(defcustom ymacs-variable-pitch-font-family-candidates
  '("SF Pro Text" "Inter" "Avenir Next" "Helvetica Neue" "Arial")
  "Preferred variable-pitch font families, first installed font wins."
  :type '(repeat string)
  :group 'ymacs-ui)

(defcustom ymacs-emoji-font-family-candidates
  '("Apple Color Emoji" "Noto Color Emoji" "Twemoji Mozilla" "Segoe UI Emoji")
  "Preferred emoji fallback font families."
  :type '(repeat string)
  :group 'ymacs-ui)

(defcustom ymacs-symbol-font-family-candidates
  '("Apple Symbols" "Noto Sans Symbols2" "Noto Sans Symbols" "Symbols Nerd Font Mono")
  "Preferred Unicode symbol fallback font families."
  :type '(repeat string)
  :group 'ymacs-ui)

(defcustom ymacs-nerd-font-family-candidates
  '("Symbols Nerd Font Mono" "Symbols Nerd Font")
  "Preferred Nerd Font fallback families for private-use icon glyphs."
  :type '(repeat string)
  :group 'ymacs-ui)

(defcustom ymacs-cjk-font-family-candidates
  '("Sarasa Mono SC"
    "LXGW WenKai Mono"
    "Noto Sans Mono CJK SC"
    "PingFang SC"
    "Hiragino Sans GB"
    "Microsoft YaHei UI")
  "Preferred CJK fallback font families."
  :type '(repeat string)
  :group 'ymacs-ui)

(defcustom ymacs-font-rescale-alist
  '(("Apple Color Emoji" . 0.90)
    ("Noto Color Emoji" . 0.90)
    ("Twemoji Mozilla" . 0.90)
    ("Symbols Nerd Font Mono" . 0.88))
  "Per-font scaling tweaks for fallback glyph alignment."
  :type '(alist :key-type string :value-type number)
  :group 'ymacs-ui)

(defcustom ymacs-font-ligatures
  '("|||>" "<|||" "<==>" "<!--" "####" "~~>" "***" "||=" "||>"
    ":::" "::=" "=:=" "===" "==>" "=!=" "=>>" "=<<" "=/=" "!=="
    "!!." ">=>" ">>=" ">>>" ">>-" ">->" "->>" "-->" "---" "-<<"
    "<~~" "<~>" "<*>" "<||" "<|>" "<$>" "<==" "<=>" "<=<" "<->"
    "<--" "<-<" "<<=" "<<-" "<<<" "<+>" "</>" "###" "#_(" "..<"
    "..." "+++" "/==" "///" "_|_" "&&" "^=" "~~" "~@" "~="
    "~>" "~-" "**" "*>" "*/" "||" "|}" "|]" "|=" "|>" "|-" "{|"
    "[|" "]#" "::" ":=" ":>" ":<" "$>" "==" "=>" "!=" "!!" ">:"
    ">=" ">>" ">-" "-~" "-|" "->" "--" "-<" "<~" "<*" "<|" "<:"
    "<$" "<=" "<>" "<-" "<<" "<+" "</" "#{" "#[" "#:" "#=" "#!"
    "##" "#(" "#?" "#_" "%%" ".=" ".-" ".." ".?" "+>" "++" "?:"
    "?=" "?." "??" ";;" "/*" "/=" "/>" "//" "__" "(*" "*)" "\\\\"
    "://")
  "Programming ligatures enabled in GUI frames via `ligature'."
  :type '(repeat string)
  :group 'ymacs-ui)

(defun ymacs--first-available-font (fonts &optional frame)
  "Return the first installed font family in FONTS for FRAME."
  (catch 'font
    (dolist (font fonts)
      (when (find-font (font-spec :family font) frame)
        (throw 'font font)))))

(defun ymacs--font-size-spec (family)
  "Return a FAMILY-size font string for frame defaults."
  (format "%s-%g" family (/ ymacs-font-height 10.0)))

(defun ymacs--set-fontset-font (targets fonts &optional frame add)
  "Set fontset TARGETS to the first available family in FONTS.
ADD is passed through to `set-fontset-font'."
  (let ((font (ymacs--first-available-font fonts frame)))
    (when font
      (dolist (target targets)
        (set-fontset-font t target (font-spec :family font) frame add)))))

(defun ymacs--setup-fontsets (&optional frame)
  "Install fallback fonts for emoji, symbols, icons and CJK in FRAME."
  (when (fboundp 'set-fontset-font)
    (ymacs--set-fontset-font '(emoji) ymacs-emoji-font-family-candidates frame 'prepend)
    (ymacs--set-fontset-font '(symbol) ymacs-symbol-font-family-candidates frame 'append)
    (ymacs--set-fontset-font '(han kana hangul cjk-misc bopomofo)
                              ymacs-cjk-font-family-candidates frame 'prepend)
    (ymacs--set-fontset-font '((#xe000 . #xf8ff)
                                (#xf0000 . #xffffd)
                                (#x100000 . #x10fffd))
                              ymacs-nerd-font-family-candidates frame 'append)))

(defun ymacs-setup-fonts (&optional frame)
  "Apply YMacs' GUI font stack to FRAME.
Run this interactively after installing new fonts."
  (interactive)
  (let ((frame (or frame (selected-frame))))
    (when (display-graphic-p frame)
      (let ((mono-font (ymacs--first-available-font ymacs-font-family-candidates frame))
            (variable-font (ymacs--first-available-font
                            ymacs-variable-pitch-font-family-candidates frame)))
        (setq face-font-rescale-alist ymacs-font-rescale-alist)
        (when ymacs-font-line-spacing
          (setq-default line-spacing ymacs-font-line-spacing))
        (when mono-font
          (let ((font-spec (ymacs--font-size-spec mono-font)))
            (set-face-attribute 'default nil
                                :family mono-font
                                :height ymacs-font-height
                                :weight 'regular)
            (set-face-attribute 'fixed-pitch nil
                                :family mono-font
                                :height ymacs-font-height
                                :weight 'regular)
            (setf (alist-get 'font default-frame-alist) font-spec
                  (alist-get 'font initial-frame-alist) font-spec)))
        (when variable-font
          (set-face-attribute 'variable-pitch nil
                              :family variable-font
                              :height ymacs-font-height
                              :weight 'regular))
        (ymacs--setup-fontsets frame)))))

(use-package ligature
  :defer t
  :config
  (ligature-set-ligatures 't '("www"))
  (ligature-set-ligatures 'prog-mode ymacs-font-ligatures))

(defun ymacs-enable-font-ligatures (&optional frame)
  "Enable programming ligatures in GUI FRAME."
  (when (display-graphic-p frame)
    (require 'ligature)
    (global-ligature-mode 1)))

(add-hook 'after-make-frame-functions #'ymacs-enable-font-ligatures)
(ymacs-enable-font-ligatures)

;; Nerd-Font glyphs only render in a GUI; in a tty they show as boxes.
(use-package nerd-icons
  :if (display-graphic-p))

(use-package gruvbox-theme)
(use-package leuven-theme)
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (doom-themes-visual-bell-config)
  (setq doom-themes-treemacs-theme "doom-colors")
  (doom-themes-treemacs-config))

(load-theme 'gruvbox-dark-hard t)

(add-hook 'after-make-frame-functions #'ymacs-setup-fonts)
(ymacs-setup-fonts)

(provide 'ymacs-ui)
;;; ymacs-ui.el ends here
