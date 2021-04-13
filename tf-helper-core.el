(ignore-error
    (require 'package))
(if (eq system-type 'darwin)
    (setq package-archives '(("elpa" . "http://tromey.com/elpa/")
			     ("gnu" . "http://elpa.gnu.org/packages/")
			     ("marmalade" . "http://marmalade-repo.org/packages/")
			     ("melpa-stable" . "http://stable.melpa.org/packages/")
			     ("melpa" . "http://melpa.org/packages/")
			     ("org" . "http://orgmode.org/elpa/")
			     ;("myelpa" . "~/.emacs.p/")
			     )))
(if (eq system-type 'windows-nt)
    (setq package-archives '(;("elpa" . "http://tromey.com/elpa/")
			     ;("gnu" . "http://elpa.gnu.org/packages/")
			     ;("marmalade" . "http://marmalade-repo.org/packages/")
			     ;("melpa-stable" . "http://stable.melpa.org/packages/")
			     ;("melpa" . "http://melpa.org/packages/")
			     ;("org" . "http://orgmode.org/elpa/")
			     ("myelpa" . "~/.emacs.p/")
			     )))
(if (eq system-type 'gnu/linux)
    (setq package-archives '(("elpa" . "http://tromey.com/elpa/")
			     ("gnu" . "http://elpa.gnu.org/packages/")
			     ("marmalade" . "http://marmalade-repo.org/packages/")
			     ("melpa-stable" . "http://stable.melpa.org/packages/")
			     ("melpa" . "http://melpa.org/packages/")
			     ("org" . "http://orgmode.org/elpa/")
			     ;("myelpa" . "~/.emacs.p/")
			     )))
(setq package-check-signature nil)
(ignore-error
    (package-initialize))

(ignore-error
    (require 'elpa-mirror)
    (setq elpamr-default-output-directory "~/.emacs.p"))

(ignore-error
    (load-theme 'zenburn t))

(global-unset-key (kbd "C-c l"))
(global-unset-key (kbd "C-c C-l"))
(global-unset-key (kbd "C-c C-o"))
(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c C-l") 'org-insert-link)
(global-set-key (kbd "C-c C-o") 'org-open-at-point)
(setq org-id-link-to-org-use-id t)

(setq org-confirm-babel-evaluate nil
      org-src-fontify-natively t
      org-src-tab-acts-natively t)
(org-babel-do-load-languages
 (quote org-babel-load-languages)
 (quote ((emacs-lisp . t)
	 (R . t)
	 (python . t)
	 (ruby . t)
	 (shell . t)
	 (org . t)
	 (plantuml . t)
	 (latex . t)
	 (calc . t)
	 (gnuplot . t))))

(add-hook 'org-mode-hook 'turn-on-visual-line-mode)

(ignore-error
   (require 'rainbow-delimiters)
   (rainbow-delimiters-mode))

(ignore-error
    (require 'helm-config)
    (helm-mode 1)
    (global-set-key (kbd "M-x") 'helm-M-x)
    (global-set-key (kbd "<f5>") 'helm-M-x)
    (global-set-key (kbd "C-o") 'helm-find-files))

(ignore-error
  (require 'auto-complete)
  (ac-config-default)
  (auto-complete-mode))

(ignore-error
  (add-to-list 'load-path
	      "~/.emacs.d/elpa/yasnippet-snippets-20200909.1058/snippets")
  (require 'yasnippet)
  (yas-global-mode 1))

(ignore-error
    (require 'magit))

(global-set-key (kbd "<f2>") 'bs-show)

(add-hook 'after-init-hook 'electric-pair-mode)

(add-hook 'after-init-hook 'show-paren-mode)

(tool-bar-mode -1)
(menu-bar-mode -1)

(setq org-plantuml-jar-path "~/.emacs.d/noelpa/plantuml.jar")
(setq plantuml-default-exec-mode 'jar)
(add-to-list 'org-src-lang-modes '("plantuml" . plantuml))

(setq org-confirm-babel-evaluate nil)

(add-to-list 'exec-path "/usr/local/bin")

(if (eq system-type 'darwin)     
    (add-to-list 'load-path "/usr/local/Cellar/mu/1.4.13/share/emacs/site-lisp/mu/mu4e"))
(if (eq system-type 'gnu/linux)     
    (add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu4e"))

(require 'mu4e)
(require 'org-mu4e)

(global-set-key (kbd "<f9> m") 'mu4e)

(setq mu4e-maildir "~/Maildir")
(setq mu4e-sent-folder   "/G/Отправленные")
;; (setq mu4e-trash-folder  "/G/Корзина")
;; (setq mu4e-drafts-folder "/G/Черновики")
;; (setq mu4e-refile-folder "/G/Архив")

(setq mu4e-mu-binary "/usr/local/bin/mu")

;; allow for updating mail using 'U' in the main view:
(setq mu4e-get-mail-command "/usr/bin/mbsync -aq")

;; show images
(setq mu4e-show-images t)

;; use imagemagick, if available
(when (fboundp 'imagemagick-register-types)
  (imagemagick-register-types))

;; convert html emails properly
;; Possible options:
;;   - html2text -utf8 -width 72
;;   - textutil -stdin -format html -convert txt -stdout
;;   - html2markdown | grep -v '&nbsp_place_holder;' (Requires html2text pypi)
;;   - w3m -dump -cols 80 -T text/html
;;   - view in browser (provided below)
(if (eq system-type 'darwin)
    (setq mu4e-html2text-command "textutil -stdin -format html -convert txt -stdout"))
;; -stdin         read from stdin instead of files
;; -format fmt    force input files to be interpreted in this format
;; -convert fmt   convert each input file to format (txt, rtf, rtfd,
;; 	          html, doc, docx, odt, wordml, or webarchive)
;; -stdout        send first output file to stdout

(if (eq system-type 'gnu/linux)
    (setq mu4e-html2text-command "html2text -utf8 -width 72"))

;; ;; spell check
;; (add-hook 'mu4e-compose-mode-hook
;;         (defun my-do-compose-stuff ()
;;            "My settings for message composition."
;;            (set-fill-column 72)
;;            (flyspell-mode)))

;; ;; add option to view html message in a browser
;; ;; `aV` in view to activate
;; (add-to-list 'mu4e-view-actions
;;   '("ViewInBrowser" . mu4e-action-view-in-browser) t)

;; fetch mail every 10 mins
(setq mu4e-update-interval 600)

;; configuration for sending mail
(setq message-send-mail-function 'smtpmail-send-it)

(setq mu4e-contexts
      `( ,(make-mu4e-context
	   :name "G"
	   :match-func (lambda (msg)
			 (when msg 
			   (mu4e-message-contact-field-matches msg 
							       :to "ievlev.sergey@gmail.com")))
	   :vars '( (user-mail-address	    . "ievlev.sergey@gmail.com")
		    (user-full-name	    . "Сергей Иевлев")
		    (setq mu4e-sent-folder   "/G/Отправленные")
		    (setq mu4e-trash-folder  "/G/Корзина")
		    (setq mu4e-drafts-folder "/G/Черновики")
		    (setq mu4e-refile-folder "/G/Архив")
		    ( mu4e-compose-signature .
					     (concat
					      "С уважением,\n"
					      "Сергей Иевлев\n"))
		    (mu4e-sent-messages-behavior  . delete)
		    (smtpmail-stream-type         . nil )
		    (smtpmail-default-smtp-server . "smtp.gmail.com")
		    (smtpmail-smtp-server         . "smtp.gmail.com")
		    (smtpmail-smtp-service        . 587)
		    (smtpmail-queue-mail          . t)
		    (smtpmail-queue-dir           . "~/Maildir/G/Исходящие/cur")))
	 ,(make-mu4e-context
	   :name "C"
	   :match-func (lambda (msg)
			 (when msg 
			   (mu4e-message-contact-field-matches msg 
							       :to "ievlev.s.a@cniiag.local")))
	   :vars '( ( user-mail-address	    . "ievlev.s.a@cniiag.local"  )
		    ( user-full-name	    . "Сергей Иевлев" )
		    (setq mu4e-sent-folder   "/C/Отправленные")
		    (setq mu4e-trash-folder  "/C/Корзина")
		    (setq mu4e-drafts-folder "/C/Черновики")
		    (setq mu4e-refile-folder "/C/Архив")
		    ( mu4e-compose-signature .
					     (concat
					      "С уважением,\n"
					      "Начальник НТО-7\n"
					      "Иевлев Сергей Александрович\n"
					      "тел. +7(926)636-42-50\n"))
		    (mu4e-sent-messages-behavior  . delete)
		    (smtpmail-stream-type         . nil )
		    (smtpmail-default-smtp-server . "10.1.6.196")
		    (smtpmail-smtp-server         . "10.1.6.196")
		    (smtpmail-smtp-service        . 1025)
		    (smtpmail-queue-mail          . t)
		    (smtpmail-queue-dir           . "~/Maildir/G/Исходящие/cur")
		    ))))

(setq mu4e-bookmarks
      `( ,(make-mu4e-bookmark
	   :name  "Unread messages"
	   :query "flag:unread AND NOT flag:trashed"
	   :key ?u)
	 ,(make-mu4e-bookmark
	   :name "Today's messages"
	   :query "date:today..now"
	   :key ?t)
	 ,(make-mu4e-bookmark
	   :name "Last 7 days"
	   :query "date:7d..now"
	   :key ?w)
	 ,(make-mu4e-bookmark
	   :name "Messages with images"
	   :query "mime:image/*"
	   :key ?p)
	 ,(make-mu4e-bookmark
	   :name  "Не обработанные"
	   :query "flag:unread AND NOT maildir:/G/Спам"
	   :key ?b)))

;; (add-to-list 'mu4e-bookmarks
;; 	     (make-mu4e-bookmark
;; 	      :name  "Не обработанные"
;; 	      :query "flag:unread AND NOT maildir:/G/Спам"
;; 	      :key ?b))

(add-hook 'message-mode-hook 'turn-on-orgtbl)

;; (add-to-list 'mu4e-headers-actions
;;              '("org-contact-add" . mu4e-action-add-org-contact) t)
;; (add-to-list 'mu4e-view-actions
;;              '("org-contact-add" . mu4e-action-add-org-contact) t)
