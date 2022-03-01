;;; settings/ui.el -*- lexical-binding: t; -*-

(setq doom-font (font-spec :family "JetBrainsMono" :size 13 :weight 'light)
      doom-variable-pitch-font (font-spec :family "JetBrainsMono" :size 13)
      ivy-posframe-font (font-spec :family "JetBrainsMono" :size 13))

;; (setq doom-theme 'doom-one)

(use-package! modus-themes
  :ensure
  :init
  ;; Add all your customizations prior to loading the themes
  (setq modus-themes-italic-constructs t
        modus-themes-bold-constructs nil
        modus-themes-region '(bg-only no-extend))

  ;; Load the theme files before enabling a theme
  (modus-themes-load-themes)
  :config
  ;; Load the theme of your choice:
  (modus-themes-load-vivendi) ;; OR (modus-themes-load-operandi)
  ;; 切换主题色
  :bind ("<f5>" . modus-themes-toggle))

(provide 'ui)
