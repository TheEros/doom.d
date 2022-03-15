;;; settings/ui.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "JetBrainsMono" :size 13 :weight 'light)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono" :size 13)
      ivy-posframe-font (font-spec :family "JetBrainsMono" :size 13))

;; (setq doom-theme 'doom-one)

;; (use-package! modus-themes
;;   ;; :ensure t
;;   :init
;;   ;; Add all your customizations prior to loading the themes
;;   (setq modus-themes-italic-constructs t
;;         modus-themes-bold-constructs nil
;;         modus-themes-region '(bg-only no-extend))

;;   ;; Load the theme files before enabling a theme
;;   (modus-themes-load-themes)
;;   :config
;;   ;; Load the theme of your choice:
;;   (modus-themes-load-vivendi) ;; OR (modus-themes-load-operandi)
;;   ;; 切换主题色
;;   :bind ("<f5>" . modus-themes-toggle))

;;blamer
(use-package! blamer
  :bind (("s-i" . blamer-show-commit-info))
  :defer 20
  :custom
  (blamer-idle-time 0.3)
  (blamer-min-offset 70)
  :custom-face
  (blamer-face ((t :foreground "#7a88cf"
                    :background nil
                    :height 140
                    :italic t)))
  :config
  (global-blamer-mode 1))

(provide 'ui)
