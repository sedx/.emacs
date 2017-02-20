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
    (solarized-theme pomodoro company-flx use-package helm powerline git-gutter helm-dash guide-key-tip rainbow-mode rainbow-delimiters helm-swoop dashboard god-mode helm-projectile helm-company helm-core highlight-indentation rvm robe grizzl rinari neotree projectile magit alchemist elixir-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(global-hl-line-mode)
(save-place-mode 1)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package which-key)

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
  (add-hook 'rinari-minor-mode-hook 'rvm-use-default)
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

 (defun my-update-cursor ()
(setq cursor-type (if (or god-local-mode buffer-read-only)
                       'box
                     'bar)))


(use-package god-mode
  :init
  (setq god-exempt-major-modes nil
	god-exempt-predicates nil)
  :config
  ; (defun god-mode-update-color ()
  ;; (let ((limited-colors-p (> 257 (length (defined-colors)))))
  ;;   (cond (god-local-mode (progn
  ;;                           (set-face-background 'mode-line (if limited-colors-p "white" "#e9e2cb"))
  ;;                           (set-face-background 'mode-line-inactive (if limited-colors-p "white" "#e9e2cb"))))
  ;;         (t (progn
  ;;              (set-face-background 'mode-line (if limited-colors-p "black" "#0a2832"))
  ;;              (set-face-background 'mode-line-inactive (if limited-colors-p "black" "#0a2832")))))))
 
  (add-hook 'god-mode-enabled-hook 'my-update-cursor)
  (add-hook 'god-mode-disabled-hook 'my-update-cursor)
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
          (if (neo-global--window-exists-p)
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

(use-package highlight-indentation
  :config
  (highlight-indentation-mode t)
  )

(use-package elixir-mode
  :config
  (add-hook 'elixir-mode-hook 'alchemist-mode)
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

 (global-set-key (kbd "C-c /") 'comment-or-uncomment-region-or-line)
