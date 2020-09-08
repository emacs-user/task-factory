;; Установка клавиши-модификатора "Meta" (Alt в большинстве клавиатур) 
(setq modifyKey "M") ; Клавиша-модификатор по умолчанию
(when (eq system-type 'darwin) (setq modifierKey "s")) 
(when (eq system-type 'windows-nt) (setq modifierKey "M"))
(when (eq system-type 'gnu/linux) (setq modifierKey "M"))
;;
;; Управление курсором
;; ===================
;;
;; Курсор вверх
(global-unset-key (kbd (concat modifierKey "-i")))
(global-set-key (kbd (concat modifierKey "-i")) 'previous-line)
;; Курсор вниз
(global-unset-key (kbd (concat modifierKey "-k")))
(global-set-key (kbd (concat modifierKey "-k")) 'next-line)
;; Курсор влево
(global-unset-key (kbd (concat modifierKey "-j")))
(global-set-key (kbd (concat modifierKey "-j")) 'backward-char)
;; Курсор вправо
(global-unset-key (kbd (concat modifierKey "-l")))
(global-set-key (kbd (concat modifierKey "-l")) 'forward-char)
;; Курсор на страницу вверх
(global-unset-key (kbd (concat modifierKey "-I")))
(global-set-key (kbd (concat modifierKey "-I")) 'scroll-down-command)
;; Курсор на страницу вниз
(global-unset-key (kbd (concat modifierKey "-K")))
(global-set-key (kbd (concat modifierKey "-K")) 'scroll-up-command)
;; Курсор на одно слово вперед
(global-unset-key (kbd (concat modifierKey "-L")))
(global-set-key (kbd (concat modifierKey "-L")) 'forward-word)
;; Курсор на одно слово назад
(global-unset-key (kbd (concat modifierKey "-J")))
(global-set-key (kbd (concat modifierKey "-J")) 'backward-word)
;; Курсор в конец строки
(global-unset-key (kbd (concat modifierKey "-;")))
(global-set-key (kbd (concat modifierKey "-;")) 'move-end-of-line)
;; Курсор в начало строки
(global-unset-key (kbd (concat modifierKey "-h")))
(global-set-key (kbd (concat modifierKey "-h")) 'move-beginning-of-line)
;; Курсор в конец буфера
(global-unset-key (kbd (concat modifierKey "-:")))
(global-set-key (kbd (concat modifierKey "-:")) 'end-of-buffer)
;; Курсор в начало буфера
(global-unset-key (kbd (concat modifierKey "-H")))
(global-set-key (kbd (concat modifierKey "-H")) 'beginning-of-buffer)
;; Удалить символ справа от курсора
(global-unset-key (kbd (concat modifierKey "-o")))
(global-set-key (kbd (concat modifierKey "-o")) 'delete-forward-char)
;; Удалить символ слева от курсора
(global-unset-key (kbd (concat modifierKey "-u")))
(global-set-key (kbd (concat modifierKey "-u")) 'delete-backward-char)
;; Перевод строки с выравниванием (две идентичные комбинации)
(global-unset-key (kbd (concat modifierKey "-n")))
(global-set-key (kbd (concat modifierKey "-n")) 'reindent-then-newline-and-indent)
(global-unset-key (kbd (concat modifierKey "-m")))
(global-set-key (kbd (concat modifierKey "-m")) 'reindent-then-newline-and-indent)
;;
;; Управление копированием и вставкой
;; ==================================
;;
;; Вставить метку
(global-unset-key (kbd (concat modifierKey "-SPC")))
(global-set-key (kbd (concat modifierKey "-SPC")) 'set-mark-command)
;; Копировать выделение
(global-unset-key (kbd (concat modifierKey "-c")))
(global-set-key (kbd (concat modifierKey "-c")) 'copy-region-as-kill)
;; Вырезать выделение
(global-unset-key (kbd (concat modifierKey "-x")))
(global-set-key (kbd (concat modifierKey "-x")) 'kill-region)
;; Вставить фрагмент из буфера
(global-unset-key (kbd (concat modifierKey "-v")))
(global-set-key (kbd (concat modifierKey "-v")) 'yank)
;; Отменить действие
(global-unset-key (kbd (concat modifierKey "-z")))
(global-set-key (kbd (concat modifierKey "-z")) 'undo)
;;
;; Управление окнами
;; =================
;;
;; Переместить окно вверх
(global-unset-key (kbd (concat "C" modifierKey "-i")))
(global-set-key (kbd (concat "C" modifierKey "-i")) 'windmove-up)
;; Переместить окно вниз
(global-unset-key (kbd (concat "C" modifierKey "-k")))
(global-set-key (kbd (concat "C" modifierKey "-k")) 'windmove-down)
;; Переместить окно влево
(global-unset-key (kbd (concat "C" modifierKey "-j")))
(global-set-key (kbd (concat "C" modifierKey "-j")) 'windmove-left)
;; Переместить окно вправо
(global-unset-key (kbd (concat "C" modifierKey "-l")))
(global-set-key (kbd (concat "C" modifierKey "-l")) 'windmove-right)


(global-unset-key (kbd "C-I"))
(global-set-key (kbd "C-I") 'buf-move-up)
(global-unset-key (kbd "C-K"))
(global-set-key (kbd "C-K") 'buf-move-down)
(global-unset-key (kbd "C-J"))
(global-set-key (kbd "C-J") 'buf-move-left)
(global-unset-key (kbd "C-L"))
(global-set-key (kbd "C-L") 'buf-move-right)

(defun my-enlarge-vert ()
  (interactive)
  (enlarge-window 2))

(defun my-shrink-vert ()
  (interactive)
  (enlarge-window -2))

(defun my-enlarge-horz ()
  (interactive)
  (enlarge-window-horizontally 2))

(defun my-shrink-horz ()
  (interactive)
  (enlarge-window-horizontally -2))

(global-unset-key (kbd "C-("))
(global-set-key (kbd "C-(") 'my-shrink-vert)
(global-unset-key (kbd "C-)"))
(global-set-key (kbd "C-)") 'my-enlarge-vert)
(global-unset-key (kbd "C-9"))
(global-set-key (kbd "C-9") 'my-shrink-horz)
(global-unset-key (kbd "C-0"))
(global-set-key (kbd "C-0") 'my-enlarge-horz)

(defun my-50%-horz ()
  (interactive)
  (let* ((width (round (* (frame-width) 0.5)))
         (cur-width (window-width))
         (delta (- width (+ cur-width 5))))
    (enlarge-window-horizontally delta)))

(defun my-50%-vert ()
  (interactive)
  (let* ((height (round (* (frame-height) 0.5)))
         (cur-height (window-height))
         (delta (- height (+ cur-height 5))))
    (enlarge-window delta)))

(defvar *larg-window-size-percent* 0.7)

(defun my-50%-horz ()
  (interactive)
  (let* ((width (round (* (frame-width) 0.5)))
         (cur-width (window-width))
         (delta (- width (+ cur-width 5))))
    (enlarge-window-horizontally delta)))

(defun my-50%-vert ()
  (interactive)
  (let* ((height (round (* (frame-height) 0.5)))
         (cur-height (window-height))
         (delta (- height (+ cur-height 5))))
    (enlarge-window delta)))

(defun my-super-enlarge-horz ()
  (interactive)
  (let* ((width (round (* (frame-width) *larg-window-size-percent*)))
         (cur-width (window-width))
         (delta (- width cur-width)))
    (enlarge-window-horizontally delta)))

(defun my-super-enlarge-vert ()
  (interactive)
  (let* ((height (round (* (frame-height) *larg-window-size-percent*)))
         (cur-height (window-height))
         (delta (- height cur-height)))
    (enlarge-window delta)))

(defun my-super-shrink-horz ()
  (interactive)
  (let* ((width (round (* (frame-width) (- 1 *larg-window-size-percent*))))
         (cur-width (window-width))
         (delta (- width cur-width)))
    (enlarge-window-horizontally delta)))

(defun my-super-shrink-vert ()
  (interactive)
  (let* ((height (round (* (frame-height) (- 1 *larg-window-size-percent*))))
         (cur-height (window-height))
         (delta (- height cur-height)))
    (enlarge-window delta)))

(when (eq system-type 'windows-nt)
  (global-unset-key (kbd (concat modifierKey "-("))
  (global-set-key (kbd (concat modifierKey "-(") 'my-super-shrink-vert)
  (global-unset-key (kbd (concat modifierKey "-)"))
  (global-set-key (kbd (concat modifierKey "-)") 'my-super-enlarge-vert)
  (global-unset-key (kbd (concat modifierKey "-9"))
  (global-set-key (kbd (concat modifierKey "-9") 'my-super-shrink-horz)
  (global-unset-key (kbd (concat modifierKey "-0"))
  (global-set-key (kbd (concat modifierKey "-0") 'my-super-enlarge-horz)
  (global-unset-key (kbd (concat modifierKey "-8"))
  (global-set-key (kbd (concat modifierKey "-8") 'my-50%-horz)
  (global-unset-key (kbd (concat modifierKey "-*"))
  (global-set-key (kbd (concat modifierKey "-*") 'my-50%-vert))
