(load-theme 'doom-dracula t)

(setq
 css-indent-offset 2
 doom-big-font (font-spec :family "Dank Mono" :size 36)
 doom-font (font-spec :family "Dank Mono" :size 30)
 doom-variable-pitch-font (font-spec :family "Dank Mono" :size 30)
 dired-dwim-target t
 js-indent-level 2
 json-reformat:indent-width 2
 prettier-js-args '(
   "--arrow-parens" "avoid"
   "--bracket-spacing" "true"
   "--end-of-line" "auto"
   "--jsx-bracket-same-line" "false"
   "--print-width" "80"
   "--prose-wrap" "preserve"
   "--require-pragma" "false"
   "--semi" "true"
   "--single-quote" "true"
   "--tab-width" "2"
   "--trailing-comma" "es5"
   "--use-tabs" "false"
   )
 org-bullets-bullet-list '("·")
 org-ellipsis " ▾ "
 org-log-done 'time
 org-refile-targets (quote ((nil :maxlevel . 1)))
 org-tags-column -80
 typescript-indent-level 2
 web-mode-code-indent-offset 2
 web-mode-content-types-alist '(("jsx" . "\\.js[x]?\\'"))
 web-mode-css-indent-offset 2
 web-mode-markup-indent-offset 2)

(add-to-list 'company-backends 'company-tern)

(add-hook!
  js2-mode 'prettier-js-mode)

(add-hook 'js2-mode-hook (lambda ()
                            (tern-mode)
                            (company-mode)))

(after! web-mode
  (add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode)))

(move-text-default-bindings)

(load! "+bindings")
(load! "+functions")
