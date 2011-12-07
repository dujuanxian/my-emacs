(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-engine (quote xetex))
 '(TeX-shell "/bin/bash")
 '(TeX-view-program-list nil)
 '(TeX-view-program-selection (quote (((output-dvi style-pstricks) "dvips and gv") (output-dvi "xdvi") (output-pdf "xpdf") (output-html "xdg-open"))))
 '(gud-gdb-command-name "gdb --annotate=1")
 '(inhibit-startup-screen t)
 '(initial-buffer-choice t)
 '(initial-frame-alist (quote ((menu-bar-lines . 1))))
 '(initial-scratch-message "")
 '(large-file-warning-threshold nil)
 '(org-agenda-files (quote ("~/Desktop/mine/notes/reading-list.txt" "~/Desktop/mine/articles/todo.org" "~/Desktop/mine/notes/ideas.org" "~/Desktop/mine/notes/todo.org")))
 '(org-agenda-include-diary t)
 '(org-log-into-drawer t)
 '(safe-local-variable-values (quote ((Package . CCL) (Base . 10) (Syntax . Common-lisp) (Package . monitor)))))

(set-fontset-font (frame-parameter nil 'font) 
		  'han '("STHeiTi" . "unicode-bmp"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dired-directory ((t (:inherit font-lock-function-name-face :foreground "Green"))))
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :background "#1C1C1C" :foreground "#E6E1DC" :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 140 :width normal :foundry "apple" :family "Monaco")))))

;;; Emacs general behavior setup
(setq backup-inhibited t)
(tool-bar-mode -1)
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed t)
(setq user-full-name "Huang Liang")
(setq user-mail-address "lhuang@thoughtworks.com")
(setq tramp-default-user "lhuang")
(setq tramp-default-user "john" tramp-default-host "shell01.kp.realestate.com.au")
;; suppress bell sound
(setq visible-bell 1)
(setq ring-bell-function 'ignore)

;;Allow you to type just "y" instead of "yes" when you exit
(fset 'yes-or-no-p 'y-or-n-p) 
;;set auto fill mode
(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;;; Common Lisp with Slime
(set-language-environment "utf-8")

;;; Set Aspell
(setq-default ispell-program-name "/opt/local/bin/aspell")


(add-to-list 'load-path "~/.emacs.d")
(add-to-list 'load-path "~/.emacs.d/elpa")

(require 'package)
(defvar package-archives '("tromey" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(unless (require 'el-get nil t)
  (url-retrieve
   "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
   (lambda (s)
     (end-of-buffer)
     (eval-print-last-sexp))))

(defun ruby-mode-hook ()
  (autoload 'ruby-mode "ruby-mode" nil t)
  (add-to-list 'auto-mode-alist '("Capfile" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Gemfile" . ruby-mode))
  (add-to-list 'auto-mode-alist '("Rakefile" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.rake\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.rb\\'" . ruby-mode))
  (add-to-list 'auto-mode-alist '("\\.ru\\'" . ruby-mode))
  (add-hook 'ruby-mode-hook '(lambda ()
			       (setq ruby-deep-arglist t)
			       (setq ruby-deep-indent-paren nil)
			       (setq c-tab-always-indent nil)
			       (require 'inf-ruby)
			       (require 'ruby-compilation)
			       (define-key ruby-mode-map (kbd "C-.") 'ac-complete-rsense)
			       (add-to-list 'ac-sources 'ac-source-rsense-method)
			       (add-to-list 'ac-sources 'ac-source-rsense-constant)
			       (define-key ruby-mode-map (kbd "C-c C-e") 'run-rails-test-or-ruby-buffer)
			       (define-key ruby-mode-map (kbd "M-r") 'run-rails-test-or-ruby-buffer)
			       (define-key ruby-mode-map (kbd "M-n") 'ruby-end-of-block)
			       (define-key ruby-mode-map (kbd "M-p") 'ruby-beginning-of-block)
			       (define-key ruby-mode-map (kbd "s-n") 'ruby-forward-sexp)
			       (define-key ruby-mode-map (kbd "s-p") 'ruby-backward-sexp))))
(defun rhtml-mode-hook ()
  (autoload 'rhtml-mode "rhtml-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . rhtml-mode))
  (add-to-list 'auto-mode-alist '("\\.rjs\\'" . rhtml-mode))
  (add-hook 'rhtml-mode '(lambda ()
			   (define-key rhtml-mode-map (kbd "M-s") 'save-buffer))))

(defun yaml-mode-hook ()
  (autoload 'yaml-mode "yaml-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))
  (add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode)))

(defun css-mode-hook ()
  (autoload 'css-mode "css-mode" nil t)
  (add-hook 'css-mode-hook '(lambda ()
			      (setq css-indent-level 2)
			      (setq css-indent-offset 2))))
(defun is-rails-project ()
  (when (textmate-project-root)
    (file-exists-p (expand-file-name "config/environment.rb" (textmate-project-root)))))

(defun run-rails-test-or-ruby-buffer ()
  (interactive)
  (if (is-rails-project)
      (let* ((path (buffer-file-name))
	     (filename (file-name-nondirectory path))
	     (test-path (expand-file-name "test" (textmate-project-root)))
	     (command (list ruby-compilation-executable "-I" test-path path)))
	(pop-to-buffer (ruby-compilation-do filename command)))
    (ruby-compilation-this-buffer)))

(defun auctex-hook ()
  (setq TeX-engine 'xetex)
  (TeX-global-PDF-mode t) ; PDF mode enable, not plain
  (define-key LaTeX-mode-map (kbd "TAB") 'TeX-complete-symbol)
  (setq TeX-auto-save t)
  (setenv "PATH" (concat (getenv "PATH") ":/usr/local/texlive/2010/bin/universal-darwin:/usr/local/bin"))
  (setq exec-path (append exec-path '("/usr/local/texlive/2010/bin/universal-darwin"))) 
  (setq exec-path (append exec-path '("/usr/local/bin"))))

(defun smex-hook ()
  (smex-initialize)
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  ;; This is your old M-x.
  (global-set-key (kbd "C-c C-c M-x") 'execute-extended-command))

(defun slime-hook ()
;;; Note that if you save a heap image, the character
;;; encoding specified on the command line will be preserved,
;;; and you won't have to specify the -K utf-8 any more.
  (setq inferior-lisp-program "/usr/local/bin/ccl -K utf-8")
  (setq slime-net-coding-system 'utf-8-unix)
  (add-hook 'lisp-mode-hook 'slime-mode)
  (require 'slime)
  (load "slime-indentation.el")
  (slime-setup '(slime-indentation slime-repl)))

(defun paredit-hook ()
  (add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode +1)))
  (add-hook 'lisp-mode-hook             (lambda () (paredit-mode +1)))
  (add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode +1)))
  (add-hook 'scheme-mode-hook           (lambda () (paredit-mode +1))))  
  
(require 'package)
(setq package-archives (cons '("tromey" . "http://tromey.com/elpa/") package-archives))
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/el-get/el-get")
(require 'el-get)

(setq el-get-sources
      '(ido-hacks ack yasnippet auto-complete magit clojure-mode color-theme
		  (:name color-theme-merbivore
			 :type git
			 :url "git://github.com/mig/color-theme-merbivore.git"
			 :load "color-theme-merbivore.el")
		  (:name ruby-mode 
			 :type elpa
			 :load "ruby-mode.el"
			 :after (lambda () (ruby-mode-hook)))
		  (:name inf-ruby  :type elpa)
		  (:name ruby-compilation :type elpa)
		  (:name css-mode 
			 :type elpa 
			 :after (lambda () (css-mode-hook)))
		  (:name textmate
			 :type git
			 :url "git://github.com/defunkt/textmate.el"
			 :load "textmate.el")
		  (:name rhtml
			 :type git
			 :url "https://github.com/crazycode/rhtml.git"
			 :features rhtml-mode
			 :after (lambda () (rhtml-mode-hook)))
		  (:name yaml-mode 
			 :type git
			 :url "http://github.com/yoshiki/yaml-mode.git"
			 :features yaml-mode
			 :after (lambda () (yaml-mode-hook)))
		  (:name smex 
			 :load "smex.el"
			 :after (lambda () (smex-hook)))
		  (:name slime
			 :after (lambda () (slime-hook)))
		  (:name ac-slime
			 :type git
			 :url "https://github.com/purcell/ac-slime.git"
			 :load "ac-slime.el"
			 :after (lambda () (add-hook 'slime-mode-hook 'set-up-slime-ac)))
		  (:name paredit 
			 :type elpa
			 :load "paredit.el"
			 :after (lambda () (paredit-hook)))
		  (:name anything
			 :load "anything-config.el"))
      ;; (:name auctex :after (lambda () (auctex-hook)))
      )
(el-get 'sync)

;;; Muse
(require 'muse-init)

;;; Buffer switch
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

(require 'ebs)
(ebs-initialize)
(global-set-key [(control tab)] 'ebs-switch-buffer)

(require 'ido)
(ido-mode t)
(setq ido-enable-flex-matching t) ;; enable fuzzy matching

;;; set recent-jump
(setq recent-jump-threshold 4)
(setq recent-jump-ring-length 10)
(global-set-key (kbd "s-P") 'recent-jump-backward)
(global-set-key (kbd "s-N") 'recent-jump-forward)
(require 'recent-jump)
(recent-jump-mode 1)

;;; set mic-paren
(require 'mic-paren)
(paren-activate) 

;;; speedbar
(require 'sr-speedbar)
; (global-set-key (kbd "s-s") 'sr-speedbar-toggle)

;;; Global key bindings
(global-set-key (kbd "s-t") 'ido-switch-buffer)
(global-set-key (kbd "s-1") 'delete-other-windows)
(global-set-key (kbd "s-2") 'other-window)
(global-set-key (kbd "<kp-delete>") 'delete-char)
(global-set-key (kbd "s-d") 'kill-whole-line)
(global-set-key (kbd "s-p") 'backward-sexp)
(global-set-key (kbd "s-n") 'forward-sexp)
(global-set-key (kbd "M-p") 'backward-list)
(global-set-key (kbd "M-n") 'forward-list)
(global-set-key (kbd "M-u") 'backward-up-list)
(global-set-key (kbd "M-U") 'down-list)
(global-set-key (kbd "M-C-n") 'make-frame)
(global-set-key (kbd "<M-down>") 'scroll-up-command)
(global-set-key (kbd "<M-up>") 'scroll-down-command)
(global-set-key (kbd "C-c d e") 'kill-sexp)
(global-set-key (kbd "C-c d a") 'backward-kill-sexp)
(global-set-key (kbd "<s-down>") 'end-of-buffer)
(global-set-key (kbd "<s-up>") 'beginning-of-buffer)
(global-set-key (kbd "s-/") 'comment-region)
(global-set-key (kbd "s-?") 'uncomment-region)
(global-set-key (kbd "C-M-f") 'grep-find)
(define-key paredit-mode-map (kbd ")") 'paredit-close-parenthesis)
(define-key paredit-mode-map (kbd "M-)") 'paredit-close-parenthesis-and-newline)
;; (global-set-key (kbd "s-w") ')
;; (global-set-key (kbd "s-q") 'quit-window)

;;; Org mode key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

;;; setup rsense
(setq rsense-home "/usr/local/rsense-0.3")
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'rsense)

;;; open previous and next line
;; Behave like vi's o command
(defun open-next-line (arg)
  "Move to the next line and then opens a line.
    See also `newline-and-indent'."
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line 1)
  (when newline-and-indent
    (indent-according-to-mode)))

;; Behave like vi's O command
(defun open-previous-line (arg)
  "Open a new line before the current one. 
     See also `newline-and-indent'."
  (interactive "p")
  (beginning-of-line)
  (open-line arg)
  (when newline-and-indent
    (indent-according-to-mode)))

;; Autoindent open-*-lines
(defvar newline-and-indent t
  "Modify the behavior of the open-*-line functions to cause them to autoindent.")

(global-set-key (kbd "<s-return>")   'open-next-line)
(global-set-key (kbd "<C-s-return>") 'open-previous-line)

;;; move deleted file to trash bin
(setq delete-by-moving-to-trash t)

(color-theme-merbivore)

;; (setq cursor-type 'bar)
(put 'dired-find-alternate-file 'disabled nil)

;;; set shell mode
(defun shell-mode-hook ()
  (interactive)
  (setq sh-basic-offset 2
        sh-indentation 2))
(add-hook 'sh-mode-hook 'shell-mode-hook)

;;; Anything: find all files under some dir
(defun my-get-find-args (dir pattern)
  (format "'%s' \\( -path \\*/.svn -o -path \\*/.rvm -o -path \\*/.chef -o -path \\*/.dropbox \\) -prune -o -iregex '.*%s.*' -print" dir pattern))

(defun my-get-source-directory ()
  "Please imlement me. Currently returns `path' inchanged."
  (let ((project-root (textmate-find-project-root (car (last (split-string default-directory " "))))))
    (if (null project-root)
	(expand-file-name default-directory)
      project-root)))

(defvar my-find-files-source
  '((name . "My find files source")
    (candidates . (lambda ()
                    (with-anything-current-buffer 
		      (let ((args (my-get-find-args (my-get-source-directory) anything-pattern)))
			(start-process-shell-command "file-search-process" nil "find" args)))))
    (type . file)))

(defun anything-my-files ()
  (interactive)
  (anything-other-buffer '(my-find-files-source)
                         "*anything-my-files*"))

(global-set-key (kbd "s-f") 'anything-my-files)
