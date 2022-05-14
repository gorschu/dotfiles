;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Gordon Schulz"
      user-mail-address "gordon@gordonschulz.de")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
(setq doom-font (font-spec :family "JetBrains Mono" :size 14 :weight 'regular)
      doom-variable-pitch-font (font-spec :family "Sans" :size 13 :weight: 'regular)
      )

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Don't open a new workspace on emacsclient invocation
(after! persp-mode
  (setq persp-emacsclient-init-frame-behaviour-override "main"))

;; don't output stuff to stdout after emacsclient invocation
;; we filter the print-stuff here
(define-advice server-eval-and-print (:filter-args (args) no-print)
  (list (car args) nil))

(doom-load-envvars-file (concat doom-private-dir "env"))

(setq deft-extensions '("txt" "md" "org"))
(setq deft-directory "~/org")
(setq deft-recursive t)
(setq deft-use-filename-as-title t)

(setq org-directory "~/org")
(setq org-roam-directory "~/org/roam")
;; use all files in ~/org to be used in agenda
(setq org-agenda-files
      (mapcar 'abbreviate-file-name
              (split-string
               (shell-command-to-string "find ~/org -name \"*.org\"") "\n")))

(setq org-refile-targets
      '((nil :maxlevel . 3)
        (org-agenda-files :maxlevel . 1)))
(setq org-attach-id-dir (concat (file-name-as-directory org-directory) "attachments"))

(after! org-capture
(load! "lisp/org-protocol-capture-html")
(add-to-list 'org-capture-templates
               '("w"
                 "Web site"
                 entry
                 (file+headline +org-capture-notes-file "Website")  ; target
                 "* %a :website:\n\n%U %?\n\n%:initial")
               )
  )


;; (after! org
;;   (add-to-list 'org-capture-templates
;;                '(("w" "Web site" entry
;;                   (file "")
;;                   "* %a :website:\n\n%U %?\n\n%:initial")
;;                  )
;;                )
;;   )

;; add .asc to gpg filenames to be automatically decrypted
(setq epa-file-name-regexp "\\.gpg\\(~\\|\\.~[0-9]+~\\)?\\'\\|\\.asc")
(epa-file-name-regexp-update)

(setq treemacs-git-mode 'deferred)
