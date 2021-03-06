(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(package-selected-packages
   (quote
    (yaml-mode pow exec-path-from-shell chess markdown-mode solarized-theme pomodoro company-flx use-package helm powerline git-gutter helm-dash guide-key-tip rainbow-mode rainbow-delimiters helm-swoop dashboard god-mode helm-projectile helm-company helm-core highlight-indentation rvm robe grizzl rinari neotree projectile magit alchemist elixir-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(global-hl-line-mode)
(save-place-mode 1)

(when (memq window-system '(mac ns))
  (use-package exec-path-from-shell
    :config
    (exec-path-from-shell-initialize))
 )



(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package which-key
  :config
  (which-key-mode)
 )

(use-package solarized-theme
  :config
  (load-theme 'solarized-light)
)
  
(use-package spaceline
  :config
  (require 'spaceline-config)
  (spaceline-emacs-theme)
  (spaceline-helm-mode)
)

(use-package pomodoro
  :config
  (pomodoro-add-to-mode-line)
  )

(use-package alchemist
)

(use-package rvm
)

(use-package robe
)

(use-package rinari
  :config
  (add-hook 'rinari-minor-mode 'rvm-activate-corresponding-ruby)
  (add-hook 'rinari-minor-mode-hook 'robe-mode)
)

(use-package magit
  :config
  :bind
  ("M-g s" . magit-status)
)

(use-package helm-core
  :disabled
  )

(use-package helm
  :init
  (setq helm-semantic-fuzzy-match t
	helm-imenu-fuzzy-match t
	helm-M-x-fuzzy-match t)
  (if (executable-find "ack")
    (setq helm-grep-default-command "ack -Hn --no-group --no-color %e %p"
	  helm-grep-default-recurse-command "ack -H --no-group --no-color %e %p %f")
    (message-box "%s" "Package ask-grep not found in system. `greep` will be used as helm-greep-deafult-comand"))
  :config
  (helm-mode 1)
  :bind
  ("<f12>" . helm-semantic-or-imenu)
  ("M-x" . helm-M-x)
  ("M-y" . helm-show-kill-ring)
)

(use-package helm-projectile
  )

(defun update-hl-color ()
  (set-face-inverse-video 'hl-line god-local-mode )
)

(use-package god-mode
  :init
  (setq god-exempt-major-modes nil
	god-exempt-predicates nil)
  :config
  (add-hook 'god-mode-enabled-hook 'update-hl-color)
  (add-hook 'god-mode-disabled-hook 'update-hl-color)
  :bind
  ("ESC ESC" . god-mode-all)
)

(use-package helm-swoop
)

(use-package rainbow-mode
)

(use-package helm-dash
)

(use-package linum
  :init
  (setq linum-format "%4d \u2502 ")
  :config
  (global-linum-mode)
 )

(use-package neotree)

(use-package projectile
  :init
  (setq projectile-enable-caching t
	projectile-completion-system 'helm
	projectile-switch-project-action 'neotree-projectile-action)
  :config
  (helm-projectile-on)
  ;; Press Command-p for fuzzy find in project
;  (global-set-key (kbd "s-p") 'projectile-find-file)
  ;; Press Command-b for fuzzy switch buffer
 ; (global-set-key (kbd "s-b") 'projectile-switch-to-buffer)
  (projectile-global-mode)
  (defun neotree-project-dir ()
    "Open NeoTree using the git root."
    (interactive)
    (let ((project-dir (projectile-project-root))
          (file-name (buffer-file-name)))
      (neotree-toggle)
      (if project-dir
          (if (neotree-toggleo-global--window-exists-p)
              (progn
                (neotree-dir project-dir)
                (neotree-find file-name)))
        (message "Could not find git project root."))))
  :bind
  ([f8] . neotree-project-dir)
  )


(use-package company
  :config
  (push 'company-robe company-backends)
  (add-hook 'prog-mode-hook 'company-mode)
)

(use-package helm-company
  :bind(
	:map company-mode-map
	     ("C-c ;" . helm-company)
        :map company-active-map
	     ("C-c ;" . helm-company))
)

(use-package flyspell
  :init
  (setq flyspell-issue-message-flg nil)
  :config
  (add-hook 'prog-mode-hook
	    (lambda () (flyspell-prog-mode)))
  :bind
  ("C-c s" . flyspell-buffer)
)


(use-package ruby-mode
  :config
  (add-hook 'ruby-mode-hook 'robe-mode)
  (add-hook 'ruby-mode-hook
          (lambda () (rvm-activate-corresponding-ruby)))
   )

(use-package pow
  )

(use-package highlight-indentation
  :config
  (highlight-indentation-mode t)
  )

(use-package elixir-mode
  :config
  (add-hook 'elixir-mode-hook 'alchemist-mode)
  )

(use-package markdown-mode
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  ;; :init (setq markdown-command "multimarkdown"))
  )
(use-package yaml-mode
  :mode
  ("\\.yml'" . yaml-mode)
 )
 
 (defun comment-or-uncomment-region-or-line ()
     "Comments or uncomments the region or the current line if there's no active region."
     (interactive)
     (let (beg end)
         (if (region-active-p)
             (setq beg (region-beginning) end (region-end))
             (setq beg (line-beginning-position) end (line-end-position)))
         (comment-or-uncomment-region beg end)
         (next-line)))

(setq show-paren-style 'mixed)
(add-hook 'prog-mode-hook 'show-paren-mode)

(global-unset-key (kbd "M-/"))
(global-set-key (kbd "M-/") 'comment-or-uncomment-region-or-line)

(global-unset-key (kbd "C-s"))
(global-set-key (kbd "C-s") 'helm-swoop)

(setq frame-title-format
      '(buffer-file-name "%b - %f" ; File buffer
        (dired-directory dired-directory ; Dired buffer
         (revert-buffer-function "%b" ; Buffer Menu
          ("%b - Dir: " default-directory)))))
