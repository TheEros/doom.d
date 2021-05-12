;;; settings/ide.el -*- lexical-binding: t; -*-

;; LSP settings
(after! lsp-mode
  (map! :leader
        :desc "Diagnostics" "c-" #'lsp-ui-flycheck-list
        :desc "Imenu" "c," #'lsp-ui-imenu)
  (setq lsp-headerline-breadcrumb-enable-diagnostics nil
        lsp-headerline-breadcrumb-enable t
        lsp-lens-enable t
        lsp-ui-sideline-show-code-actions nil
        lsp-ui-imenu--custom-mode-line-format ""
        lsp-enable-file-watchers nil))
;;        +lsp-company-backends '(company-capf company-yasnippet)))

;; Completion settings
(after! company
  (map! :i "<tab>" #'company-indent-or-complete-common)
  (map! :map company-active-map "<tab>" #'company-complete-common)
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 1))

(provide 'ide)
