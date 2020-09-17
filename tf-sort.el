
(add-to-list 'load-path "/usr/local/Cellar/mu/1.4.13/share/emacs/site-lisp/mu/mu4e/")
(require 'mu4e)
(require 'org-mu4e)
;;
(global-set-key (kbd "<f9> m") 'mu4e)
;;
(setq mu4e-mu-binary "/usr/local/Cellar/mu/1.4.13/bin/mu")
;;
(setq mu4e-get-mail-command "mbsync -q -c ~/pro/task-factory/.mbsyncrc MailRu-group")
;;
(setq
 mue4e-headers-skip-duplicates  t
 mu4e-view-show-images t
 mu4e-view-show-addresses t
 mu4e-compose-format-flowed nil
 mu4e-date-format "%y/%m/%d"
 mu4e-headers-date-format "%Y/%m/%d"
 mu4e-change-filenames-when-moving t
 mu4e-attachments-dir "~/Downloads"
 mu4e-maildir       "~/Maildir"
 mu4e-sent-folder   "/Отправленные"
 mu4e-drafts-folder "/Черновики"
 mu4e-trash-folder  "/Корзина"
 )

(setq user-mail-address "sergey.ievlev@mail.ru")

