;;; settings/bindings.el -*- lexical-binding: t; -*-

;;global
(map!
 :i  "C-;"       #'backward-char
 :i  "C-'"       #'forward-char
 :ni "C-h"       #'evil-window-left
 :ni "C-j"       #'evil-window-down
 :ni "C-k"       #'evil-window-up
 :ni "C-l"       #'evil-window-right)

(provide 'bindings)
