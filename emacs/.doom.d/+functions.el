;;; private/fourjuaneight/+bindings.el -*- lexical-binding: t; -*-

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
