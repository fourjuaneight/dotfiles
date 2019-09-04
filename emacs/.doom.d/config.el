(load-theme 'doom-dracula t)

(setq
 doom-font (font-spec :family "FiraCode" :size 24)
 doom-big-font (font-spec :family "FiraCode" :size 36)
 doom-variable-pitch-font (font-spec :family "FiraCode" :size 22)
 web-mode-markup-indent-offset 2
 web-mode-code-indent-offset 2
 web-mode-css-indent-offset 2
 js-indent-level 2
 typescript-indent-level 2
 json-reformat:indent-width 2
 prettier-js-args '("--single-quote")
 dired-dwim-target t
 org-ellipsis " ▾ "
 org-bullets-bullet-list '("·")
 org-tags-column -80
 org-log-done 'time
 css-indent-offset 2
 org-refile-targets (quote ((nil :maxlevel . 1)))
 +doom-dashboard-banner-file (expand-file-name "logo.png" doom-private-dir))

(add-hook!
  js2-mode 'prettier-js-mode
  (add-hook 'before-save-hook #'refmt-before-save nil t))

(after! web-mode
  (add-to-list 'auto-mode-alist '("\\.njk\\'" . web-mode)))

(setq +magit-hub-features t)
