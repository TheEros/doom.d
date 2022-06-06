;;; settings/ide.el -*- lexical-binding: t; -*-

;; LSP settings
(after! lsp-mode
  (map! :leader
        :desc "Diagnostics" "c-" #'lsp-ui-flycheck-list
        :desc "Imenu" "c," #'lsp-ui-imenu)
  (setq lsp-headerline-breadcrumb-enable-diagnostics nil
        lsp-headerline-breadcrumb-enable t
        ;;用以解决在wsl2 windows terminal中rust项目移动光标导致重复显示行的问题。
        lsp-lens-enable nil
        lsp-ui-sideline-show-code-actions nil
        lsp-ui-imenu--custom-mode-line-format ""
        lsp-enable-file-watchers nil
        ;;用于开启rust类型推断
        lsp-rust-analyzer-server-display-inlay-hints t
        +lsp-company-backends '(company-capf company-yasnippet
                                             company-tabnine
                                             :separate)))

;; Completion settings
(after! company
  (map! :i "<tab>" #'company-indent-or-complete-common)
  (map! :map company-active-map "<tab>" #'company-complete-common)
  ;; 打字卡顿或者提示卡顿可将数值提高到0.250,emacs >= 28，开启native-comp可将此值修改为0.000
  (setq company-idle-delay 0.000
        company-minimum-prefix-length 1
        company-show-quick-access t))

;;Increase the amount of data which Emacs reads from the process
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;;启动时自动搜索项目
(setq projectile-project-search-path '("~/IdeaProjects/" "~/PycharmProjects/"))

;;配置tabnine
(use-package! company-tabnine
  :when (featurep! :completion company)
  :config
  (defun company//sort-by-tabnine (candidates)
    (if (or (functionp company-backend)
            (not (and (listp company-backend) (memq 'company-tabnine company-backend))))
        candidates
      (let ((candidates-table (make-hash-table :test #'equal))
            candidates-1
            candidates-2)
        (dolist (candidate candidates)
          (if (eq (get-text-property 0 'company-backend candidate)
                  'company-tabnine)
              (unless (gethash candidate candidates-table)
                (push candidate candidates-2))
            (push candidate candidates-1)
            (puthash candidate t candidates-table)))
        (setq candidates-1 (nreverse candidates-1))
        (setq candidates-2 (nreverse candidates-2))
        (nconc (seq-take candidates-1 2)
               (seq-take candidates-2 2)
               (seq-drop candidates-1 2)
               (seq-drop candidates-2 2)))))
  (add-to-list 'company-transformers 'company//sort-by-tabnine t)
  ;; The free version of TabNine is good enough,
  ;; and below code is recommended that TabNine not always
  ;; prompt me to purchase a paid version in a large project.
  ;; 禁止tabnine提示升级付费版本
  (defadvice company-echo-show (around disable-tabnine-upgrade-message activate)
    (let ((company-message-func (ad-get-arg 0)))
      (when (and company-message-func
                 (stringp (funcall company-message-func)))
        (unless (string-match "The free version of TabNine only indexes up to" (funcall company-message-func))
          ad-do-it))))
  ;;将tabnine添加到backends
  (add-to-list 'company-backends 'company-tabnine))

;; (use-package! citre
;;   :defer t
;;   :init
;;   (require 'citre-config)
;;   (global-set-key (kbd "C-x c j") 'citre-jump)
;;   (global-set-key (kbd "C-x c J") 'citre-jump-back)
;;   (global-set-key (kbd "C-x c p") 'citre-ace-peek)
;;   :config
;;   (setq citre-project-root-function #'projectile-project-root)
;;   ;; See https://github.com/universal-ctags/citre/wiki/Use-Citre-together-with-lsp-mode
;;   (define-advice xref--create-fetcher (:around (-fn &rest -args) fallback)
;;     (let ((fetcher (apply -fn -args))
;;           (citre-fetcher
;;            (let ((xref-backend-functions '(citre-xref-backend t)))
;;              (apply -fn -args))))
;;       (lambda ()
;;         (or (with-demoted-errors "%s, fallback to citre"
;;               (funcall fetcher))
;;             (funcall citre-fetcher))))))

;;rust 这些代码行想要解决的问题是，在 lsp 模式下悬停几乎不会显示有用的 rust-analyzer 签名。
;;question https://github.com/emacs-lsp/lsp-mode/pull/1740
(cl-defmethod lsp-clients-extract-signature-on-hover (contents (_server-id (eql rust-analyzer)))
  (-let* (((&hash "value") contents)
          (groups (--partition-by (s-blank? it) (s-lines (s-trim value))))
          (sig_group (if (s-equals? "```rust" (car (-third-item groups)))
                         (-third-item groups)
                       (car groups)))
          (sig (--> sig_group
                    (--drop-while (s-equals? "```rust" it) it)
                    (--take-while (not (s-equals? "```" it)) it)
                    (--map (s-trim it) it)
                    (s-join " " it))))
    (lsp--render-element (concat "```rust\n" sig "\n```"))))

;;用来格式化toml文件，cargo install taplo-cli
(set-formatter! 'taplo "taplo format" :modes '(conf-toml-mode))
(provide 'ide)
