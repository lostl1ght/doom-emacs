;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!
(setq doom-font (font-spec :family "JetBrainsMono Nerd Font Mono" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)
(setq! fancy-splash-image
       (expand-file-name "misc/emacs-e.svg" doom-private-dir))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq! confirm-kill-emacs nil)
;; Keyboard layout switch (C-\)
(setq! default-input-method "russian-computer")

;; Insert mode escape
(after! evil-escape
  (setq! evil-escape-key-sequence "ii")
  (setq! evil-escape-unordered-key-sequence t)
  (setq! evil-escape-delay 0.2))

(setq! c-basic-offset 4) ;; C tab size
(setq! python-indent-offset 4) ;; Python tab size
(setq! rust-indent-offset 4) ;; Rust tab size

;; LaTeX configuration
(setq! +latex-viewers '(pdf-tools okular))
(add-hook! 'LaTeX-mode-hook
  (setq! tex-indent-arg 2) ;; Latex tab size
  (setq! tex-indent-basic 2)
  (setq! +latex-indent-item-continuation-offset #'auto)
  (map!
   :map LaTeX-mode-map
   :localleader
   :desc "Open output log" "l" #'tex-recenter-output-buffer)
  )
(add-hook! 'LaTeX-mode-hook #'turn-on-cdlatex)

(after! cdlatex
  (map!
   :map cdlatex-mode-map
   :i "TAB" #'cdlatex-tab)
  (setq! cdlatex-math-symbol-alist
         '((?1 ("\\{"))
           (?2 ("\\}"))
           (?/ ("\\not" "\\sqrt{?}"))
           (?n ("\\nu" "\\infty" "\\ln"))
           (?\( ("\\langle" "\\leq"))
           (?\) ("\\rangle" "\\geq")))))


;; Lisp configuration
(add-hook! 'lisp-mode-hook
  (require 'eval-in-repl)
  (require 'eval-in-repl-sly)
  (map! :map lisp-mode-map
        :localleader
        :prefix "e"
        :desc "Evaluate in REPL" "s" #'eir-eval-in-sly)
  (setq! eir-always-split-script-window t))

;; Dap-mode configuration
(add-hook! (c-mode c++-mode rustic-mode)
  (after! dap-mode
    (require 'dap-gdb-lldb)))
(add-hook! 'python-mode-hook
  (after! dap-mode
    (setq! dap-python-debugger 'debugpy)))
(add-hook! 'c-mode-hook
  (map! :map c-mode-map
        :localleader
        (:prefix ("d" . "debug")
         :desc "Debug" "d" #'dap-debug
         :desc "Toggle breakpoint" "b" #'dap-breakpoint-toggle
         :desc "Kill all sessions" "k" #'dap-delete-all-sessions)))
(add-hook! 'c++-mode-hook
  (map! :map c++-mode-map
        :localleader
        (:prefix ("d" . "debug")
         :desc "Debug" "d" #'dap-debug
         :desc "Toggle breakpoint" "b" #'dap-breakpoint-toggle
         :desc "Kill all sessions" "k" #'dap-delete-all-sessions)))
(add-hook! 'rustic-mode-hook
  (map! :map rustic-mode-map
        :localleader
        (:prefix ("d" . "debug")
         :desc "Debug" "d" #'dap-debug
         :desc "Toggle breakpoint" "b" #'dap-breakpoint-toggle
         :desc "Kill all sessions" "k" #'dap-delete-all-sessions)))
(add-hook! 'python-mode-hook
  (map! :map python-mode-map
        :localleader
        (:prefix ("d" . "debug")
         :desc "Debug" "d" #'dap-debug
         :desc "Toggle breakpoint" "b" #'dap-breakpoint-toggle
         :desc "Kill all sessions" "k" #'dap-delete-all-sessions)))

;; Evil-goggles
(after! evil-goggles
  (evil-goggles-use-diff-faces)
  (setq-default evil-goggles-blocking-duration 0.100)
  (setq-default evil-goggles-async-duration 0.900))

;; Focus new window after splitting
(setq evil-split-window-below t
      evil-vsplit-window-right t)

;; Fomatters
(set-formatter! 'stylua
  (concat "stylua --config-path "
          (getenv "HOME")
          "/.config/stylua/stylua.toml -")
  :modes '(lua-mode))
(set-formatter! 'yapf
  "yapf --style google"
  :modes '(python-mode))
(set-formatter! 'shfmt-custom
  "shfmt -i 4 -ln bash"
  :modes '(sh-mode))
