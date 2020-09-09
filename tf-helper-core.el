;; БАЗОВЫЕ НАСТРОЙКИ ДЛЯ ВСЕХ РЕЖИМОВ
;; ==================================
;;
;;
;; Репозитории пакетов
;; -------------------
;;
;; В силу разных обстоятельств я ВСЕГДА получаю свежие пакеты в OSX,
;; а затем распространяю их на другие машины (Windows и Linux)
;; Если у вас с этим проще -- просто раскомментируйте строки с
;; соответствующими репозиториями
;;
(condition-case nil
    (require 'package)
  (error nil))
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
    (setq package-archives '(;("elpa" . "http://tromey.com/elpa/")
                             ;("gnu" . "http://elpa.gnu.org/packages/")
                             ;("marmalade" . "http://marmalade-repo.org/packages/")
                             ;("melpa-stable" . "http://stable.melpa.org/packages/")
                             ;("melpa" . "http://melpa.org/packages/")
                             ;("org" . "http://orgmode.org/elpa/")
			     ("myelpa" . "~/.emacs.p/")
			     )))
(setq package-check-signature nil)
(package-initialize)
;;
;; Инструмент для создания пользовательского репозитория "myelpa",
;; который применялся выше для машин с Windows и Linux
;; ---------------------------------------------------------------
;;
(condition-case nil
    (require 'elpa-mirror)
  (error nil))
(setq elpamr-default-output-directory "~/.emacs.p")
;;
;; Подсветка скобок разными цветами
;; --------------------------------
;;
(condition-case nil
    (lambda ()
      (require 'rainbow-delimiters)
      (rainbow-delimiters-mode))
  (error nil))
