;;; settings/app.el -*- lexical-binding: t; -*-
;; 用于配置rss elfeed
(after! elfeed
  (setq elfeed-search-filter "@2-years-ago"))

;;用于配置rss elfeed-org
(use-package! elfeed-org
  :config
  (setq rmh-elfeed-org-files (list "~/.doom.d/org/elfeed/elfeed.org")))

(provide 'app)
