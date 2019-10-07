(load-theme 'doom-dracula t)

(defun doom-dashboard-widget-banner ()
  (let ((point (point)))
    (mapc (lambda (line)
            (insert (propertize (+doom-dashboard--center +doom-dashboard--width line)
                                'face 'font-lock-comment-face) " ")
            (insert "\n"))
          '("      @@@  @@@  @@@   @@@@@@   @@@  @@@ "
            "      @@@  @@@  @@@  @@@@@@@@  @@@@ @@@ "
            "      @@!  @@!  @@@  @@!  @@@  @@!@!@@@ "
            "      !@!  !@!  @!@  !@!  @!@  !@!!@!@! "
            "      !!@  @!@  !@!  @!@!@!@!  @!@ !!@! "
            "      !!!  !@!  !!!  !!!@!!!!  !@!  !!! "
            "      !!:  !!:  !!!  !!:  !!!  !!:  !!! "
            " !!:  :!:  :!:  !:!  :!:  !:!  :!:  !:! "
            " ::: : ::  ::::: ::  ::   :::   ::   :: "
            "  : :::     : :  :    :   : :  ::    :  "))
    (when (and (display-graphic-p)
               (stringp fancy-splash-image)
               (file-readable-p fancy-splash-image))
      (let ((image (create-image (fancy-splash-image-file))))
        (add-text-properties
         point (point) `(display ,image rear-nonsticky (display)))
        (save-excursion
          (goto-char point)
          (insert (make-string
                   (truncate
                    (max 0 (+ 1 (/ (- +doom-dashboard--width
                                      (car (image-size image nil)))
                                   2))))
                   ? ))))
      (insert (make-string (or (cdr +doom-dashboard-banner-padding) 0)
                           ?\n)))))

(setq
 css-indent-offset 2
 doom-big-font (font-spec :family "Dank Mono" :size 36)
 doom-font (font-spec :family "Dank Mono" :size 28)
 doom-variable-pitch-font (font-spec :family "Dank Mono" :size 26)
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

(setq +magit-hub-features t)
