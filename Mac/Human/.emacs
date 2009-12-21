(custom-set-variables
 '(require-final-newline t)
 '(ps-paper-type (quote a4))
 '(paren-mode (quote paren) nil (paren))
 '(mouse-avoidance-mode (quote exile) nil (avoid))
 '(java-mode-hook nil)
 '(delete-key-deletes-forward t)
 '(load-home-init-file t t)
 '(column-number-mode t)
 '(track-eol t)
 '(gnuserv-program (concat exec-directory "/gnuserv"))
 '(c-echo-syntactic-information-p nil)
 '(browse-url-browser-function (quote browse-url-netscape))
 '(tex-dvi-view-command "/usr/X11R6/bin/xdvi")
 '(c-indent-comments-syntactically-p t)
 '(bar-cursor nil)
 '(font-menu-this-frame-only-p nil)
 '(nnmail-spool-file "/var/spool/mail/$user")
 '(line-number-mode t)
 '(c-basic-offset 8)
 '(mouse-yank-at-point t)
 '(transient-mark-mode t)
 '(user-mail-address "jakob@nym.se")
 '(query-user-mail-address nil)
 '(get-frame-for-buffer-default-instance-limit 2))

  (global-font-lock-mode)
  (define-key global-map [del] 'delete-char)
  (define-key global-map [end] 'end-of-line)
  (define-key global-map [home] 'beginning-of-line)
  (define-key global-map [C-end] 'end-of-buffer)
  (define-key global-map [C-home] 'beginning-of-buffer)

(define-key global-map (kbd "RET") 'newline-and-indent)
(define-key text-mode-map (kbd "RET") 'newline)
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

(setq load-path (append load-path '("/home/jb/lib/emacs/")))
(setq auto-mode-alist (cons '("mutt-" . text-mode) auto-mode-alist))
(setq auto-mode-alist (cons '(".txt" . text-mode) auto-mode-alist))

(defun boxes-create ()
         (interactive)
         (shell-command-on-region (region-beginning) (region-end) "boxes -d c-cmt2" nil 1 nil))

(defun boxes-remove ()
         (interactive)
         (shell-command-on-region (region-beginning) (region-end) "boxes -r -d c-cmt2" nil 1 nil))

(add-hook 'tex-mode-hook
	  (function
	   (lambda ()
	     (setq tex-open-quote "''"))))

(add-hook 'text-mode-hook
	  (function
	   (lambda ()
	     (auto-fill-mode))))

(add-hook 'c-mode-hook
	  (function
	   (lambda ()
	     (c-set-style "K&R")
	     (setq c-basic-offset 8)
	     (if (not (string-match "XEmacs" emacs-version))
		 (show-paren-mode)))))

(add-hook 'c++-mode-hook
	  (function
	   (lambda ()
	     (c-set-style "K&R")
	     (setq c-basic-offset 8)
	     (if (not (string-match "XEmacs" emacs-version))
		 (show-paren-mode)))))

(add-hook 'cxx-mode-hook
	  (function
	   (lambda ()
	     (c-set-style "K&R")
	     (setq c-basic-offset 8)
	     (if (not (string-match "XEmacs" emacs-version))
		 (show-paren-mode)))))

(add-hook 'java-mode-hook
	  (function
	   (lambda ()
	     (setq c-basic-offset 8)
	     (if (not (string-match "XEmacs" emacs-version))
		 (show-paren-mode)))))

(defun my-asm-mode-set-comment-hook ()
  (when (string-match ".s$" (buffer-file-name))
    (setq asm-comment-char ?!)))
(add-hook 'asm-mode-set-comment-hook 'my-asm-mode-set-comment-hook)

(custom-set-faces)

(setq auto-mode-alist
      (append auto-mode-alist
              '(("\\.[hg]s$"  . haskell-mode)
                ("\\.hi$"     . haskell-mode)
                ("\\.py$"     . python-mode)
                ("\\.l[hg]s$" . literate-haskell-mode))))

(setq interpreter-mode-alist
      (append interpreter-mode-alist
              '(("^#!.*runhugs" . haskell-mode))))

(autoload 'python-mode "python-mode"
  "Major mode for editing Python scripts." t)

(autoload 'haskell-mode "haskell-mode"
  "Major mode for editing Haskell scripts." t)
(autoload 'literate-haskell-mode "haskell-mode"
  "Major mode for editing literate Haskell scripts." t)
(autoload 'turn-on-haskell-ghci "haskell-ghci"
  "Turn on interaction with a GHC interpreter." t)
(add-hook 'haskell-mode-hook 'turn-on-haskell-font-lock)
(add-hook 'haskell-mode-hook 'turn-on-haskell-decl-scan)
(if (not (string-match "Lucid\\|XEmacs" emacs-version))
    (add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode))
(add-hook 'haskell-mode-hook 'turn-on-haskell-indent)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-simple-indent)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-hugs)
;(add-hook 'haskell-mode-hook 'turn-on-haskell-ghci)

;; Options Menu Settings
;; =====================
(cond
 ((and (string-match "XEmacs" emacs-version)
       (boundp 'emacs-major-version)
       (or (and
            (= emacs-major-version 19)
            (>= emacs-minor-version 14))
           (= emacs-major-version 20))
       (fboundp 'load-options-file))
  (load-options-file "/home/people/jb/.xemacs-options")))
;; ============================
;; End of Options Menu Settings
