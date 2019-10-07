;;; private/fourjuaneight/+bindings.el -*- lexical-binding: t; -*-

(map!
  "C-c C-m"    #'mc/edit-lines
  "C-j"        #'mc/mark-next-like-this
  "C-k"        #'mc/mark-previous-like-this
  "C-c C-j"    #'mc/mark-all-like-this)