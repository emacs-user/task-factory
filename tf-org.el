(setq org-agenda-files (list "~/pro"))

(setq calendar-month-name-array
      ["Январь" "Февраль" "Март"     "Апрель"  "Май"    "Июнь"
       "Июль"   "Август"  "Сентябрь" "Октябрь" "Ноябрь" "Декабрь"])

(setq calendar-month-abbrev-array
      ["Янв" "Фев" "Мар" "Апр" "Май" "Июн"
       "Июл" "Авг" "Сен" "Окт" "Ноя" "Дек"])

(setq calendar-day-name-array
      ["Воскресенье" "Понедельник" "Вторник" "Среда" "Четверг" "Пятница" "Суббота"])

(setq calendar-day-abbrev-array
      ["Вс" "Пн" "Вт" "Ср" "Чт" "Пт" "Сб"])

(setq calendar-week-start-day 1)

(setq org-todo-keywords
      (quote ((sequence "TODO(1)" "NEXT(2@/!)" "|" "DONE(3@/!)")
	      (sequence "CONTROL(4@/!)" "MEET(5@/!)" "WAIT(6@/!)" "HOLD(7@/!)" "|" "CANCEL(8@/!)"))))

(setq org-todo-keyword-faces
      (quote (("TODO"    :foreground "red"          :weight bold)
	      ("NEXT"    :foreground "blue"         :weight bold)
	      ("DONE"    :foreground "forest green" :weight bold)
	      ("CONTROL" :foreground "orange"       :weight bold)
	      ("WAIT"    :foreground "orange"       :weight bold)
	      ("HOLD"    :foreground "magenta"      :weight bold)
	      ("CANCEL"  :foreground "forest green" :weight bold)
	      ("MEET"    :foreground "blue"         :weight bold))))

(setq org-use-fast-todo-selection t)
(setq org-treat-S-cursor-todo-selection-as-state-change nil)
(global-set-key (kbd "<f9> q") 'org-todo)

(add-hook 'org-after-todo-state-change-hook 'si/org-todo-state-change-property)

;; (require 'org-collector)

(defun si/org-todo-state-change-property ()
  (pcase (org-get-todo-state)
	       ("NEXT" (si/org-NEXT-state-property))
	       ("TODO" (si/org-TODO-state-property))
	       ("DONE" (si/org-DONE-state-property))
	       ("CONTROL" (si/org-CONTROL-state-property))
	       ("WAIT" (si/org-WAIT-state-property))
	       ("HOLD" (si/org-HOLD-state-property))
	       ("CANCEL" (si/org-CANCEL-state-property))
	       ("MEET" (si/org-MEET-state-property))))

(defun si/org-TODO-state-property ()
  (org-set-property "Effort" "0:15")
  (org-set-property "CLOCK_MODELINE_TOTAL" "auto")
  (org-delete-property "Участники"))

(defun si/org-NEXT-state-property ()
  (org-set-property "Effort" "0:30")
  (org-set-property "CLOCK_MODELINE_TOTAL" "auto")
  (org-delete-property "Участники"))

(defun si/org-DONE-state-property ()
  (org-delete-property "Участники"))

(defun si/org-CONTROL-state-property ()
  (org-set-property "Effort" "0:15")
  (org-set-property "CLOCK_MODELINE_TOTAL" "today")
  (org-delete-property "Участники"))

(defun si/org-WAIT-state-property ()
  (org-set-property "Effort" "0:15")
  (org-set-property "CLOCK_MODELINE_TOTAL" "today")
  (org-delete-property "Участники"))

(defun si/org-HOLD-state-property ()
  (org-set-property "Effort" "0:15")
  (org-set-property "CLOCK_MODELINE_TOTAL" "today")
  (org-delete-property "Участники"))

(defun si/org-CANCEL-state-property ()
  (org-delete-property "Участники"))

(defun si/org-MEET-state-property ()
  (org-set-property "Effort" "1:00")
  (org-set-property "CLOCK_MODELINE_TOTAL" "auto")
  (call-interactively 'org-schedule))

(setq org-directory "~/pro")
(setq org-default-notes-file "~/pro/inbox.org")
(setq org-capture-templates
       (quote (("н" "Новая задача" entry (file "~/pro/inbox.org")
		"* TODO %?\n:PROPERTIES:\n:CREATED: %U\n:CONTEXT: %a\n:END:\n" :clock-in t :clock-resume t)
	       ("з" "Заметка" entry (file "~/pro/inbox.org")
		"* %?\n:PROPERTIES:\n:CREATED: %U\n:CONTEXT: %a\n:END:\n" :clock-in t :clock-resume t)
	       ("к" "Новый контакт" entry (file "~/pro/contacts.org")
		"* %^{ФИО}%^{ORG}p%^{TITLE}p%^{PHONE}p%^{EMAIL}p")
	       ("в" "Встреча" entry (file "~/pro/inbox.org")
		"* MEET %?\n:PROPERTIES:\n:CREATED: %U\n:CONTEXT: %a\n:END:\n" :clock-in t :clock-resume t)
	       ("т" "Звонок" entry (file "~/pro/inbox.org")
		"* PHONE %?\n:PROPERTIES:\n:CREATED: %U\n:CONTEXT: %a\n:END:\n" :clock-in t :clock-resume t)
	       ("х" "Habit" entry (file "~/pro/inbox.org")
		"* NEXT %?\nSCHEDULED: %(format-time-string \"%<<%Y-%m-%d %a .+1d/3d>>\")\n:PROPERTIES:\n:CREATED: %U\n:CONTEXT: %a\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:END:\n"))))

(require 'helm-org)
(global-set-key (kbd "<f9> <f9>") 'helm-org-capture-templates)

(defun bh/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
    (beginning-of-line 0)
    (org-remove-empty-drawer-at (point))))
(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)

(defun si/get-task-from-1c-mail ()
  "Формирование задачи из письма 1С"
  (interactive)
  (if (equal (substring (buffer-name) 0 13) " *WL:Message*")
      (let ((fields (si/parse-1c-message-buffer)))
	(org-capture t "н")
	(insert (nth 0 fields))
	(goto-char (point-max))
	(insert (nth 1 fields))
	(org-set-property "INIT" (nth 4 fields))
	(org-set-property "EXEC" (nth 3 fields))
	(org-set-property "OBJECT" (nth 5 fields))
	(org-set-property "LINK1C" (nth 6 fields))
	(org-schedule nil "+0d")
	(org-deadline nil (si/convert-date-to-org-format (nth 2 fields)))
	(goto-char (point-min)))
    (message "it's not a WL:Message buffer")))

(global-set-key (kbd "<f9> 1 c") 'si/get-task-from-1c-mail)

(defun si/convert-date-to-org-format (date-str)
  "Преобразует дату в формате писем 1С в формат org"
  (if (string= date-str "не указан")
      nil
    (let ((date-comp (delete " " (split-string date-str))))
      (concat (nth 2 date-comp) "-" (si/ru-month-convert (nth 1 date-comp)) "-" (nth 0 date-comp)))))

(defun si/ru-month-convert (ru-month)
  "Преобразует русские наименования месяцев в родительном падеже в числовое значение"
  (let (month)
    (cond ((string= ru-month "января")   (setq month "1"))
	  ((string= ru-month "февраля")  (setq month "2"))
	  ((string= ru-month "марта")    (setq month "3"))
	  ((string= ru-month "апреля")   (setq month "4"))
	  ((string= ru-month "мая")      (setq month "5"))
	  ((string= ru-month "июня")     (setq month "6"))
	  ((string= ru-month "июля")     (setq month "7"))
	  ((string= ru-month "августа")  (setq month "8"))
	  ((string= ru-month "сентября") (setq month "9"))
	  ((string= ru-month "октября")  (setq month "10"))
	  ((string= ru-month "ноября")   (setq month "11"))
	  ((string= ru-month "декабря")  (setq month "12")))
    month))

(defun si/parse-1c-message-buffer ()
  "Разбор буфера с письмом на отдельные поля"
  (let ((text (buffer-substring-no-properties (point-min) (point-max)))
	(line-counter 1)
	task
	note
	deadline
	executor
	author
	thing
	link)
    (with-temp-buffer
      (insert text)
      (goto-char (point-min))
      (while (< line-counter (line-number-at-pos (point-max)))
	(cond ((search-forward "Задача: " (+ (point) 15) t) (setq task (buffer-substring (point) (line-end-position))))
	      ((search-forward "Описание: " (+ (point) 15) t) (setq note (buffer-substring (point) (line-end-position))))
	      ((search-forward "Крайний срок: " (+ (point) 15) t) (setq deadline (buffer-substring (point) (line-end-position))))
	      ((search-forward "Исполнитель: " (+ (point) 15) t) (setq executor (buffer-substring (point) (line-end-position))))
	      ((search-forward "Автор: " (+ (point) 15) t) (setq author (buffer-substring (point) (line-end-position))))
	      ((search-forward "Предмет: " (+ (point) 15) t) (setq thing (buffer-substring (point) (line-end-position))))
	      ((search-forward "Ссылка: " (+ (point) 15) t) (setq link (buffer-substring (point) (line-end-position)))))
	(setq line-counter (1+ line-counter))
	(goto-line line-counter)))
   (list task note deadline executor author thing link)))

(global-set-key (kbd "<f12>") 'org-agenda)

	(setq org-id-method (quote uuidgen))
	(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

	(setq org-refile-use-outline-path 'file)

	(setq org-outline-path-complete-in-steps nil)
	(setq org-refile-targets '((org-agenda-files :maxlevel . 20)))

	(setq org-agenda-dim-blocked-tasks nil)
	(setq org-agenda-compact-blocks t)
	(setq org-agenda-custom-commands
	      (quote ((" " "Расписание"
		       ((agenda "" ((org-agenda-span 'day)
;				    (org-agenda-skip-function
;				     '(org-agenda-skip-entry-if 'todo '("TODO" "NEXT" "DONE" "WAIT" "CONTROL" "HOLD" "")))
    ))
			(tags "вхд"
			      ((org-agenda-overriding-header "ВХОДЯЩИЕ")
			       (org-tags-match-list-sublevels nil)))
			(alltodo ""
				 ((org-agenda-cmp-user-defined 'si/agenda-sort)
				  (org-agenda-sorting-strategy '(user-defined-down))
				  (org-agenda-overriding-header "ПРИОРИТЕТЫ"))))))))

	(setq org-deadline-warning-days -1)

	(defun si/skip-if-not-today ()
	  "If this function returns nil, the current match should not be skipped.
	Otherwitse, the function must return a position from where the search
	should be continued."
	  (let ((subtree-end (save-excursion (org-end-of-subtree t)))
		(deadline-day
		 (or (ignore-errors (time-to-days
				     (org-time-string-to-time
				      (org-entry-get nil "DEADLINE"))))
		     0))
		(scheduled-day
		 (or (ignore-errors (time-to-days
				     (org-time-string-to-time
				      (org-entry-get nil "SCHEDULED"))))
		     0))
		(now (time-to-days (current-time))))
	    (and (and (not (= deadline-day now)) (not (= scheduled-day now)))
		 subtree-end)))

	(defun si/agenda-sort (a b)
	  (let* ((aPos (get-text-property 0 'org-marker a))
		(bPos (get-text-property 0 'org-marker b))
		(aPriorityValue (string-to-number (or (org-entry-get aPos "FPRIORITY") "")))
		(bPriorityValue (string-to-number (or (org-entry-get bPos "FPRIORITY") ""))))
	    (if (eq aPriorityValue bPriorityValue)
		nil
	      (cl-signum (- aPriorityValue bPriorityValue)))))

	(global-set-key (kbd "C-<f12>") 'si/task-priority-set)

	(defun si/task-priority-set ()
	  (interactive)
	  (save-restriction
	    (save-excursion
	      (org-todo-list)
	      (let (priority
		    deadline
		    effort)
		(while (not (eq (line-number-at-pos) (count-lines (point-min) (point-max))))
		  (org-agenda-next-item 1)
		  (setq priority (or (org-entry-get (org-agenda-get-any-marker) "PRIORITY" t nil) ""))
		  (setq deadline (org-entry-get (org-agenda-get-any-marker) "DEADLINE" t nil))
		  (setq effort (org-entry-get (org-agenda-get-any-marker) "EFFORT" t nil))
		  (if (or (string= deadline "") (eq deadline nil))
		      (setq deadline (current-time-string)))
		  (if (or (string= effort "") (eq effort nil))
		      (setq effort "01:01"))
		  (org-entry-put
		   (org-agenda-get-any-marker)
		   "FPRIORITY"
		   (number-to-string (si/calc-fact-priority
				      priority
				      deadline
				      effort)))
		  (org-entry-put
		   (org-agenda-get-any-marker)
		   "BUFFER"
		   (si/buffer-calc 
		    effort
		    (current-time-string)
		    deadline)))) 
	      (org-agenda-Quit))))

	(defun si/calc-fact-priority (priority deadline effort &optional current)
	  "Расчет фактического приоритета задачи"
	  (let ((E (si/convert-time-to-work-day effort))
		(x (si/work-days-calc (or current (current-time-string)) deadline))
		(P (si/priority-calc priority)))
	    (/ P (exp (- x E)))))

	(defun si/convert-time-to-work-day (time)
	  "Преобразование строки времени формата 'HH:MM' в рабочие дни"
	  (let ((tm (parse-time-string time))
		(dr (parse-time-string si/work-day-duration)))
	    (/ (si/convert-time-list-to-hours tm) (si/convert-time-list-to-hours dr))))

	(defun si/convert-time-list-to-hours (time-list)
	  "Преобразование списка вида '(SS MM HH)' к значению в часах"
	  (+ (/ (nth 0 time-list) 3600.0)
	     (/ (nth 1 time-list) 60.0)
	     (nth 2 time-list)))

	(defun si/work-days-calc (begin end)
	  "Возвращает разницу во времени между BEGIN и END в рабочих днях
	Если BEGIN раньше END то возвращаемое значение положительно или равно нулю
	В ином случае возвращаемое значение отрицательно"
	  (let ((work-day-begin (parse-time-string si/work-day-begin))
		(work-day-end (parse-time-string si/work-day-end))
		(work-day-duration (parse-time-string si/work-day-duration))
		(beginPoint (parse-time-string begin))
		(endPoint (parse-time-string end))
		(workDays 0)
		(deltaBegin 0)
		(deltaEnd 0)
		forwardPlan)
	    (setq beginPoint (si/test-time-correct beginPoint))
	    (setq endPoint (si/test-time-correct endPoint))
	    (setq beginPoint (si/shift-timePoint-to-work-time beginPoint))
	    (setq endPoint (si/shift-timePoint-to-work-time endPoint))
	    (if (si/day-is-same beginPoint endPoint)
		(si/time-difference beginPoint endPoint)
	      (setq forwardPlan (si/plan-forward-p beginPoint endPoint))
	      (setq deltaBegin (si/time-delta beginPoint forwardPlan))
	      (setq deltaEnd (si/time-delta endPoint forwardPlan))
	      (setq workDays (si/work-days-dif beginPoint endPoint forwardPlan))
	      (if forwardPlan
		  (+ workDays deltaBegin deltaEnd)
		(* (+ workDays deltaBegin deltaEnd) -1.0))) 
	    ))

	(defun si/test-time-correct (time)
	  ""
	  (if (or (eq (nth 0 time) nil) (eq (nth 1 time) nil) (eq (nth 2 time) nil))
	      (append '(59 59 23) (nthcdr 3 time))
	    time))

	  (defun si/shift-timePoint-to-work-time (time)
	    "Возвращает ближайшее рабочее время к TIME"
	    (let ((work-day-begin (parse-time-string si/work-day-begin))
		  (work-day-end (parse-time-string si/work-day-end))
		  (current-time time))
	      (if (< (si/convert-time-list-to-hours current-time) (si/convert-time-list-to-hours work-day-begin))
		  (setq current-time (append (seq-take work-day-begin 3) (nthcdr 3 current-time))))
	      (if (> (si/convert-time-list-to-hours current-time) (si/convert-time-list-to-hours work-day-end))
		  (setq current-time (append (seq-take work-day-end 3) (nthcdr 3 current-time))))
	      (if (= (calendar-day-of-week (list (nth 4 current-time) (nth 3 current-time) (nth 5 current-time))) 6)
		  (setq current-time (decode-time (time-add (encode-time (nth 0 current-time) (nth 1 current-time)
									 (nth 2 current-time) (nth 3 current-time)
									 (nth 4 current-time) (nth 5 current-time))
							    (* 86400 2))))) ; + 2 дня
	      (if (= (calendar-day-of-week (list (nth 4 current-time) (nth 3 current-time) (nth 5 current-time))) 0)
		  (setq current-time (decode-time (time-add (encode-time (nth 0 current-time) (nth 1 current-time)
									 (nth 2 current-time) (nth 3 current-time)
									 (nth 4 current-time) (nth 5 current-time))
							    (* 86400 1))))) ; + 1 день
	      current-time
	      )
	    )

	  (defun si/day-is-same (time1 time2)
	    "Возвращает t если даты TIME1 и TIME2 совпадают"
	    (and (= (nth 3 time1) (nth 3 time2))
		 (= (nth 4 time1) (nth 4 time2))
		 (= (nth 5 time1) (nth 5 time2)))
	    )

	  (defun si/time-difference (time1 time2)
	    "Возвращает разницу в рабочем времени между TIME1 и TIME2 игнорируя дату"
	    (let ((work-day-duration (parse-time-string si/work-day-duration)))
	      (if (>= (abs (- (si/convert-time-list-to-hours time1) (si/convert-time-list-to-hours time2)))
		      (si/convert-time-list-to-hours work-day-duration))
		  1.0
		(/ (abs (- (si/convert-time-list-to-hours time1) (si/convert-time-list-to-hours time2)))
		   (si/convert-time-list-to-hours work-day-duration)))))

	  (defun si/time-delta (time forward)
	    "Возвращает разницу между TIME и началом (FORWARD=nil) или концом (FORWARD=t) рабочего дня
	Если разница больше продолжительности рабочего дня, то возвращается продолжительность"
	    (let ((work-day-begin (parse-time-string si/work-day-begin))
		  (work-day-end (parse-time-string si/work-day-end))
		  (work-day-duration (parse-time-string si/work-day-duration))
		  (delta 0))
	      (if forward
		  (setq delta (/ (abs (- (si/convert-time-list-to-hours time) (si/convert-time-list-to-hours work-day-end)))
		     (si/convert-time-list-to-hours work-day-duration)))
		(setq delta (/ (abs (- (si/convert-time-list-to-hours time) (si/convert-time-list-to-hours work-day-begin)))
			       (si/convert-time-list-to-hours work-day-duration))))
	      (if (> delta 1.0) (setq delta 1.0))
	      delta))

	  (defun si/plan-forward-p (time1 time2)
	    "Возвращает t если TIME1 < TIME2 и nil в ином случае"
	    (< (time-to-seconds (encode-time (nth 0 time1) (nth 1 time1)
					     (nth 2 time1) (nth 3 time1)
					     (nth 4 time1) (nth 5 time1)))
	       (time-to-seconds (encode-time (nth 0 time2) (nth 1 time2)
					   (nth 2 time2) (nth 3 time2)
					   (nth 4 time2) (nth 5 time2)))))

	(defun si/work-days-dif (start end forward)
	  "Возвращает количество полных рабочих дней между временем START и END"
	  (let ((dif nil)
		(count 0)
		day-w)
	    (setq dif (abs (- (time-to-days (encode-time (nth 0 start) (nth 1 start)
							 (nth 2 start) (nth 3 start)
							 (nth 4 start) (nth 5 start)))
			      (time-to-days (encode-time (nth 0 end) (nth 1 end)
							 (nth 2 end) (nth 3 end)
							 (nth 4 end) (nth 5 end))))))
	    (if (> dif 0) (setq dif (1- dif)))
	    (if forward
		(setq day-w (calendar-day-of-week (list (nth 4 start)
							(nth 3 start)
							(nth 5 start))))
	      (setq day-w (calendar-day-of-week (list (nth 4 end)
						      (nth 3 end)
						      (nth 5 end)))))
	    (while (> dif 0)
	      (if (= day-w 6)
		  (setq day-w 1
			dif (- dif 2))
		(setq day-w (1+ day-w)))
	      (setq count (1+ count))
	      (setq dif (1- dif)))
	    count
	    ))

	(defvar si/work-day-begin    "09:00" "Время начала рабочего дня. По умолчанию '09:00'")
	(defvar si/work-day-end      "18:00" "Время окончания работчего дня. По умолчанию '18:00'")
	(defvar si/work-day-duration "06:00" "Продолжительность рабочего дня в часах. По умолчанию '6:00'")

	(defun si/priority-calc (priority)
	  "Преобразование приоритета в виде буквы в число"
	  (cond ((string= priority "A") 5)
		((string= priority "B") 4)
		((string= priority "C") 3)
		((string= priority "D") 2)
		((string= priority "")  1)))

	(defun si/three-point-effort (min norm max)
	  "Оценка по трем точкам
	Оценка производится по формуле '(MIN + 4xNORM + MAX) / 6'"
	  (/ (+ min (* norm 4.0) max) 6.0))

	(defun si/effort-set (norm min max)
	  "Установка трудоемкости задачи методом оценки по трем точкам"
	  (interactive "nНормальная оценка (часов): \nnОптимистичная оценка (часов): \nnПессимистичная оценка (часов): ")
	  (let ((ef (si/three-point-effort min norm max))
		hh
		mm)
		(setq hh (floor ef))
		(setq mm (floor (* 60 (- ef hh))))
	    (org-set-property "EFFORT" (concat (number-to-string hh) ":" (number-to-string mm)))))

	(defun si/buffer-calc (effort begin end)
	  "Расчитывает расходование буфера на текущий момент"
	  (let ((bf (/ (si/convert-time-list-to-hours (parse-time-string effort)) 2.0))
		(work-day-duration (si/convert-time-list-to-hours (parse-time-string si/work-day-duration)))
		delta
		result)
	    (setq delta (* (si/work-days-calc begin end) work-day-duration))
	    (if (>= delta bf) "100%"
	      (setq result (* (/ delta bf) 100.0))
	      (concat (number-to-string (round result)) "%"))))

;;
;; Resume clocking task when emacs is restarted
(org-clock-persistence-insinuate)
;;
;; Show lot of clocking history so it's easy to pick items off the C-F11 list
(setq org-clock-history-length 23)
;; Resume clocking task on clock-in if the clock is open
(setq org-clock-in-resume t)
;; Change tasks to NEXT when clocking in
(setq org-clock-in-switch-to-state 'bh/clock-in-to-next)
;; Separate drawers for clocking and logs
(setq org-drawers (quote ("PROPERTIES" "LOGBOOK")))
;; Save clock data and state changes and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Sometimes I change tasks I'm clocking quickly - this removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)
;; Clock out when moving task to a done state
(setq org-clock-out-when-done t)
;; Save the running clock and all clock history when exiting Emacs, load it on startup
(setq org-clock-persist t)
;; Do not prompt to resume an active clock
(setq org-clock-persist-query-resume nil)
;; Enable auto clock resolution for finding open clocks
(setq org-clock-auto-clock-resolution (quote when-no-clock-is-running))
;; Include current clocking task in clock reports
(setq org-clock-report-include-clocking-task t)

(setq bh/keep-clock-running nil)

(defun bh/clock-in-to-next (kw)
  "Switch a task from TODO to NEXT when clocking in.
    Skips capture tasks, projects, and subprojects.
    Switch projects and subprojects from NEXT back to TODO"
  (when (not (and (boundp 'org-capture-mode) org-capture-mode))
    (cond
     ((and (member (org-get-todo-state) (list "TODO"))
	   (bh/is-task-p))
      "NEXT")
     ((and (member (org-get-todo-state) (list "NEXT"))
	   (bh/is-project-p))
      "TODO"))))

(defun bh/find-project-task ()
  "Move point to the parent (project) task if any"
  (save-restriction
    (widen)
    (let ((parent-task (save-excursion (org-back-to-heading 'invisible-ok) (point))))
      (while (org-up-heading-safe)
	(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	  (setq parent-task (point))))
      (goto-char parent-task)
      parent-task)))

(defun bh/punch-in (arg)
  "Start continuous clocking and set the default task to the
    selected task.  If no task is selected set the Organization task
    as the default task."
  (interactive "p")
  (setq bh/keep-clock-running t)
  (if (equal major-mode 'org-agenda-mode)
      ;;
      ;; We're in the agenda
      ;;
      (let* ((marker (org-get-at-bol 'org-hd-marker))
	     (tags (org-with-point-at marker (org-get-tags-at))))
	(if (and (eq arg 4) tags)
	    (org-agenda-clock-in '(16))
	  (bh/clock-in-organization-task-as-default)))
    ;;
    ;; We are not in the agenda
    ;;
    (save-restriction
      (widen)
					; Find the tags on the current task
      (if (and (equal major-mode 'org-mode) (not (org-before-first-heading-p)) (eq arg 4))
	  (org-clock-in '(16))
	(bh/clock-in-organization-task-as-default)))))

(defun bh/punch-out ()
  (interactive)
  (setq bh/keep-clock-running nil)
  (when (org-clock-is-active)
    (org-clock-out))
  (org-agenda-remove-restriction-lock))

(defun bh/clock-in-default-task ()
  (save-excursion
    (org-with-point-at org-clock-default-task
      (org-clock-in))))

(defun bh/clock-in-parent-task ()
  "Move point to the parent (project) task if any and clock in"
  (let ((parent-task))
    (save-excursion
      (save-restriction
	(widen)
	(while (and (not parent-task) (org-up-heading-safe))
	  (when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	    (setq parent-task (point))))
	(if parent-task
	    (org-with-point-at parent-task
	      (org-clock-in))
	  (when bh/keep-clock-running
	    (bh/clock-in-default-task)))))))

(defvar bh/organization-task-id "991a68d0-9e2e-47f4-84aa-3acf0a142bea")

(defun bh/clock-in-organization-task-as-default ()
  (interactive)
  (org-with-point-at (org-id-find bh/organization-task-id 'marker)
    (org-clock-in '(16))))

(defun bh/clock-out-maybe ()
  (when (and bh/keep-clock-running
	     (not org-clock-clocking-in)
	     (marker-buffer org-clock-default-task)
	     (not org-clock-resolving-clocks-due-to-idleness))
    (bh/clock-in-parent-task)))

(add-hook 'org-clock-out-hook 'bh/clock-out-maybe 'append)

(require 'org-id)
(defun bh/clock-in-task-by-id (id)
  "Clock in a task by id"
  (org-with-point-at (org-id-find id 'marker)
    (org-clock-in nil)))

(defun bh/clock-in-last-task (&optional arg)
  "Clock in the interrupted task if there is one
    Skip the default task and get the next one.
    A prefix arg forces clock in of the default task."
  (interactive "p")
  (let ((clock-in-to-task
	 (cond
	  ((eq arg 4) org-clock-default-task)
	  ((and (org-clock-is-active)
		(equal org-clock-default-task (cadr org-clock-history)))
	   (caddr org-clock-history))
	  ((org-clock-is-active) (cadr org-clock-history))
	  ((equal org-clock-default-task (car org-clock-history)) (cadr org-clock-history))
	  (t (car org-clock-history)))))
    (widen)
    (org-with-point-at clock-in-to-task
      (org-clock-in nil))))

(defun bh/is-project-p ()
  "Any task with a todo keyword subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
	  (subtree-end (save-excursion (org-end-of-subtree t)))
	  (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
	(forward-line 1)
	(while (and (not has-subtask)
		    (< (point) subtree-end)
		    (re-search-forward "^\*+ " subtree-end t))
	  (when (member (org-get-todo-state) org-todo-keywords-1)
	    (setq has-subtask t))))
      (and is-a-task has-subtask))))

(defun bh/is-project-subtree-p ()
  "Any task with a todo keyword that is in a project subtree.
    Callers of this function already widen the buffer view."
  (let ((task (save-excursion (org-back-to-heading 'invisible-ok)
			      (point))))
    (save-excursion
      (bh/find-project-task)
      (if (equal (point) task)
	  nil
	t))))

(defun bh/is-task-p ()
  "Any task with a todo keyword and no subtask"
  (save-restriction
    (widen)
    (let ((has-subtask)
	  (subtree-end (save-excursion (org-end-of-subtree t)))
	  (is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
      (save-excursion
	(forward-line 1)
	(while (and (not has-subtask)
		    (< (point) subtree-end)
		    (re-search-forward "^\*+ " subtree-end t))
	  (when (member (org-get-todo-state) org-todo-keywords-1)
	    (setq has-subtask t))))
      (and is-a-task (not has-subtask)))))

(defun bh/is-subproject-p ()
  "Any task which is a subtask of another project"
  (let ((is-subproject)
	(is-a-task (member (nth 2 (org-heading-components)) org-todo-keywords-1)))
    (save-excursion
      (while (and (not is-subproject) (org-up-heading-safe))
	(when (member (nth 2 (org-heading-components)) org-todo-keywords-1)
	  (setq is-subproject t))))
    (and is-a-task is-subproject)))

(defun bh/list-sublevels-for-projects-indented ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
      This is normally used by skipping functions where this variable is already local to the agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels 'indented)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defun bh/list-sublevels-for-projects ()
  "Set org-tags-match-list-sublevels so when restricted to a subtree we list all subtasks.
      This is normally used by skipping functions where this variable is already local to the agenda."
  (if (marker-buffer org-agenda-restrict-begin)
      (setq org-tags-match-list-sublevels t)
    (setq org-tags-match-list-sublevels nil))
  nil)

(defvar bh/hide-scheduled-and-waiting-next-tasks t)

(defun bh/toggle-next-task-display ()
  (interactive)
  (setq bh/hide-scheduled-and-waiting-next-tasks (not bh/hide-scheduled-and-waiting-next-tasks))
  (when  (equal major-mode 'org-agenda-mode)
    (org-agenda-redo))
  (message "%s WAITING and SCHEDULED NEXT Tasks" (if bh/hide-scheduled-and-waiting-next-tasks "Hide" "Show")))

(defun bh/skip-stuck-projects ()
  "Skip trees that are not stuck projects"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (bh/is-project-p)
	  (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
		 (has-next ))
	    (save-excursion
	      (forward-line 1)
	      (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
		(unless (member "WAITING" (org-get-tags-at))
		  (setq has-next t))))
	    (if has-next
		nil
	      next-headline)) ; a stuck project, has subtasks but no next task
	nil))))

(defun bh/skip-non-stuck-projects ()
  "Skip trees that are not stuck projects"
  ;; (bh/list-sublevels-for-projects-indented)
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (if (bh/is-project-p)
	  (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
		 (has-next ))
	    (save-excursion
	      (forward-line 1)
	      (while (and (not has-next) (< (point) subtree-end) (re-search-forward "^\\*+ NEXT " subtree-end t))
		(unless (member "WAITING" (org-get-tags-at))
		  (setq has-next t))))
	    (if has-next
		next-headline
	      nil)) ; a stuck project, has subtasks but no next task
	next-headline))))

(defun bh/skip-non-projects ()
  "Skip trees that are not projects"
  ;; (bh/list-sublevels-for-projects-indented)
  (if (save-excursion (bh/skip-non-stuck-projects))
      (save-restriction
	(widen)
	(let ((subtree-end (save-excursion (org-end-of-subtree t))))
	  (cond
	   ((bh/is-project-p)
	    nil)
	   ((and (bh/is-project-subtree-p) (not (bh/is-task-p)))
	    nil)
	   (t
	    subtree-end))))
    (save-excursion (org-end-of-subtree t))))

(defun bh/skip-non-tasks ()
  "Show non-project tasks.
    Skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((bh/is-task-p)
	nil)
       (t
	next-headline)))))

(defun bh/skip-project-trees-and-habits ()
  "Skip trees that are projects"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
	subtree-end)
       ((org-is-habit-p)
	subtree-end)
       (t
	nil)))))

(defun bh/skip-projects-and-habits-and-single-tasks ()
  "Skip trees that are projects, tasks that are habits, single non-project tasks"
  (save-restriction
    (widen)
    (let ((next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((org-is-habit-p)
	next-headline)
       ((and bh/hide-scheduled-and-waiting-next-tasks
	     (member "WAITING" (org-get-tags-at)))
	next-headline)
       ((bh/is-project-p)
	next-headline)
       ((and (bh/is-task-p) (not (bh/is-project-subtree-p)))
	next-headline)
       (t
	nil)))))

(defun bh/skip-project-tasks-maybe ()
  "Show tasks related to the current restriction.
    When restricted to a project, skip project and sub project tasks, habits, NEXT tasks, and loose tasks.
    When not restricted, skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
	   (next-headline (save-excursion (or (outline-next-heading) (point-max))))
	   (limit-to-project (marker-buffer org-agenda-restrict-begin)))
      (cond
       ((bh/is-project-p)
	next-headline)
       ((org-is-habit-p)
	subtree-end)
       ((and (not limit-to-project)
	     (bh/is-project-subtree-p))
	subtree-end)
       ((and limit-to-project
	     (bh/is-project-subtree-p)
	     (member (org-get-todo-state) (list "NEXT")))
	subtree-end)
       (t
	nil)))))

(defun bh/skip-project-tasks ()
  "Show non-project tasks.
    Skip project and sub-project tasks, habits, and project related tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
	subtree-end)
       ((org-is-habit-p)
	subtree-end)
       ((bh/is-project-subtree-p)
	subtree-end)
       (t
	nil)))))

(defun bh/skip-non-project-tasks ()
  "Show project tasks.
    Skip project and sub-project tasks, habits, and loose non-project tasks."
  (save-restriction
    (widen)
    (let* ((subtree-end (save-excursion (org-end-of-subtree t)))
	   (next-headline (save-excursion (or (outline-next-heading) (point-max)))))
      (cond
       ((bh/is-project-p)
	next-headline)
       ((org-is-habit-p)
	subtree-end)
       ((and (bh/is-project-subtree-p)
	     (member (org-get-todo-state) (list "NEXT")))
	subtree-end)
       ((not (bh/is-project-subtree-p))
	subtree-end)
       (t
	nil)))))

(defun bh/skip-projects-and-habits ()
  "Skip trees that are projects and tasks that are habits"
  (save-restriction
    (widen)
    (let ((subtree-end (save-excursion (org-end-of-subtree t))))
      (cond
       ((bh/is-project-p)
	subtree-end)
       ((org-is-habit-p)
	subtree-end)
       (t
	nil)))))

(defun bh/skip-non-subprojects ()
  "Skip trees that are not projects"
  (let ((next-headline (save-excursion (outline-next-heading))))
    (if (bh/is-subproject-p)
	nil
      next-headline)))

(setq org-time-stamp-rounding-minutes (quote (1 1)))
(setq org-clock-out-remove-zero-time-clocks t)
(setq org-agenda-clockreport-parameter-plist
      (quote (:link t :maxlevel 5 :fileskip0 t :compact t :narrow 80)))
(setq org-columns-default-format "%80ITEM(Задача) %10Effort(Запланировано){:} %10CLOCKSUM(Потрачено)")
(setq org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 6:00 8:00")
				    ("STYLE_ALL" . "habit"))))
(setq org-agenda-log-mode-items (quote (closed state)))
(setq org-log-done 'time)
(setq org-log-into-drawer t)
(setq org-log-state-notes-insert-after-drawers nil)
(setq org-log-reschedule 'note)
(setq org-log-redeadline 'note)
(setq org-log-refile 'time)

(setq org-log-note-headings
      '((done .        "%t: Задача закрыта")
	(state .       "%t: Статус изменен с %-9S на %-9s")
	(note .        "%t: Заметка")
	(reschedule .  "%t: Напоминание изменено с %S на %s")
	(delschedule . "%t: Напоминание %S удалено")
	(redeadline .  "%t: Срок изменен с %S на %s")
	(deldeadline . "%t: Срок %S удален")
	(refile .      "%t: Задача перемещена")
	(clock-out .   "")))

(global-set-key (kbd "<f9> I") 'bh/punch-in)
(global-set-key (kbd "<f9> O") 'bh/punch-out)
(global-set-key (kbd "<f11>") 'org-clock-goto)
(global-set-key (kbd "C-<f11>") 'org-clock-in)
(global-set-key (kbd "<f9> SPC") 'bh/clock-in-last-task)

(setq org-clock-out-remove-zero-time-clocks t)

(setq org-time-stamp-rounding-minutes (quote (1 1)))

(global-set-key (kbd "<f9> i") 'si/interrupt)

(defun si/interrupt (arg)
  "Unscheduled interruption: switching to the scratch buffer with timing enabled for other tasks"
  (interactive "p")
  (bh/punch-in arg)
  (switch-to-buffer "*scratch*")
  (delete-other-windows))

(defun si/org-set-tags ()
  (interactive)
  (save-excursion
    (outline-previous-visible-heading 1)
    (org-set-tags)))

(define-key org-mode-map (kbd "<f9> t") 'si/org-set-tags)

(define-key org-mode-map (kbd "<f7>") 'org-narrow-to-subtree)
(define-key org-mode-map (kbd "C-<f7>") 'widen)

(define-key org-mode-map (kbd "<f9> n") 'org-add-note)

(define-key org-mode-map (kbd "<f9> p") 'org-set-property)

(define-key org-mode-map (kbd "<f9> a") 'org-attach-reveal)
(define-key org-mode-map (kbd "<f9> A") 'org-attach-reveal-in-emacs)
(setq org-attach-method 'mv)

(global-set-key (kbd "C-c l") 'org-store-link)
(define-key org-mode-map (kbd "C-c C-l") 'org-insert-link)
(define-key org-mode-map (kbd "C-c C-o") 'org-open-at-point)

(defun si/helm-org-agenda-files-headings ()
  "Модифицированная функция 'helm-org-agenda-files-headings' без проверки временных файлов"
  (interactive)
  (let ((autosaves nil))
    (when (or (null autosaves)
	   helm-org-ignore-autosaves
	   (y-or-n-p (format "%s have auto save data, continue?"
			     (mapconcat 'identity autosaves ", "))))
      (helm :sources (helm-source-org-headings-for-files (org-agenda-files))
	 :candidate-number-limit 99999
	 :truncate-lines helm-org-truncate-lines
	 :buffer "*helm org headings*"))))


(defun si/org-insert-extension-link ()
  "Вставка ссылки с интерактивным поиском"
  (interactive)
  (dolist (buf (buffer-list))
    (with-current-buffer buf
      (when (and (buffer-file-name) (buffer-modified-p))
     (save-buffer))))
  (let (link
     description)
    (save-excursion
      (call-interactively 'si/helm-org-agenda-files-headings)
      (setq link (org-id-copy))
      (setq description (org-get-heading t t t t)))
    (org-insert-link nil (concatenate 'string "id:" link) description)))


(define-key org-mode-map (kbd "<f9> l") 'si/org-insert-extension-link)

(org-add-link-type "e1c" 'org-1c-open)

(defcustom org-e1c-command 'e1c
  "Команда для отображения ссылки 1С."
  :group 'org-link
  :type 'e1c)

(defun org-1с-open (path)
  "Переход по ссылке 1С к PATH."
  (funcall org-1с-command path))

(global-set-key (kbd "<f9> f") 'si/helm-org-agenda-files-headings)

(global-set-key (kbd "<f9> F") 'org-search-view)

(setq org-archive-mark-done nil)
(setq org-archive-location "%s_archive::* Archived Tasks")

(setq org-alphabetical-lists t)
					;(require 'ox-html)
					;(require 'ox-latex)
					;(require 'ox-ascii)
					;(require 'ox-taskjuggler)

(setq org-ditaa-jar-path "~/.emacs.d/noelpa/ditaa0_9.jar")
(setq org-plantuml-jar-path "~/.emacs.d/noelpa/plantuml.1.2019.4.jar")
					;(setq org-pla)

(add-hook 'org-babel-after-execute-hook 'bh/display-inline-images 'append)
(setq org-image-actual-width '(400))

					; Make babel results blocks lowercase
(setq org-babel-results-keyword "results")

(defun bh/display-inline-images ()
  (condition-case nil
      (org-display-inline-images)
    (error nil)))

					;(load-file "~/.emacs.d⁩/lisp/ob-sh.el⁩")

;; (org-babel-do-load-languages
;;  (quote org-babel-load-languages)
;;  (quote ((emacs-lisp . t)
;;          (dot . t)
;;          (ditaa . t)
;;          (R . t)
;;          (python . t)
;;          (ruby . t)
;;          (gnuplot . t)
;;          (clojure . t)
;;          ;(sh . t)
;;          (ledger . t)
;;          (org . t)
;;          (plantuml . t)
;;          (latex . t))))

(setq org-confirm-babel-evaluate nil)
(add-to-list 'org-src-lang-modes (quote ("plantuml" . fundamental)))

(when (eq system-type 'darwin)
  (setenv "PATH" (concat (getenv "PATH") ":/Library/TeX/texbin"))
  (setenv "PATH" (concat (getenv "PATH") ":/opt/local/bin")))  

(defvar si/export-tmp-dir "~/tmp/"
  "Путь к временной директории для PDF и служебных файлов")

(defvar si/export-template-dir "~/.template/"
  "Путь к директории с шаблонами")

(defvar si/export-template-TeX "orgTaskTemplate.tex"
  "Имя файла с шаблоном TeX по умолчанию")

(defvar si/export-template-pdf "orgTemplate1.pdf"
  "Имя файла с шаблоном PDF по умолчанию")

(defun si/export-task (title create status id priority link shedule deadline effort tags content notes resolution filename &optional open)
  "Экспорт данных задачи в формат PDF
    title - заголовок задачи
    create - дата создания
    status - текущий статус
    id - идентификатор
    priority - приоритет
    link - ссылка
    shedule - напоминание
    deadline - крайний срок
    effort - длительность
    tags - теги
    content - содержание
    notes - заметка
    resolution - решение
    filename - имя выходного файла без расширения
    open - если не nil, то созданный файл будет открыт"
  (copy-file (concat si/export-template-dir si/export-template-TeX)
	     (concat si/export-tmp-dir si/export-template-TeX) t)
  (copy-file (concat si/export-template-dir si/export-template-pdf)
	     (concat si/export-tmp-dir si/export-template-pdf) t)
  (with-temp-buffer
    (insert-file-contents (concat si/export-tmp-dir si/export-template-TeX))
    (si/export-serch-and-replace "{Title}" (concat "{" title "}"))
    (si/export-serch-and-replace "{CreateDate}" (concat "{" create "}"))
    (si/export-serch-and-replace "{Status}" (concat "{" status "}"))
    (si/export-serch-and-replace "{ID}" (concat "{" id "}"))
    (si/export-serch-and-replace "{Priority}" (concat "{" priority "}"))
    (si/export-serch-and-replace "{Link}" (concat "{" link "}"))
    (si/export-serch-and-replace "{Shedule}" (concat "{" shedule "}"))
    (si/export-serch-and-replace "{Deadline}" (concat "{" deadline "}"))
    (si/export-serch-and-replace "{Effort}" (concat "{" effort "}"))
    (si/export-serch-and-replace "{Tags}" (concat "{" tags "}"))
    (si/export-serch-and-replace "{Content}" (concat "{" content "}"))
    (si/export-serch-and-replace "{Notes}" (concat "{" notes "}"))
    (si/export-serch-and-replace "{Resolution}" (concat "{" resolution "}"))
    (write-file (concat si/export-tmp-dir si/export-template-TeX) nil))
  (shell-command (concat "cd " si/export-tmp-dir " && xelatex -jobname=" (or filename "tmpfile") " " si/export-template-TeX))
  (if open
      (shell-command (concat "cd " si/export-tmp-dir " && open " (or filename "tmpfile") ".pdf"))))

(defun si/export-serch-and-replace (search replace)
  "Находит в буфере первое вхождение строки SEARCH и заменяет ее на REPLACE"
  (goto-char (point-min))
  (replace-string search replace))

(defun si/export-search-logbook-content ()
  "Находит и возвращает содержимое LOGBOOK DRAWER в формате, приемлемом для экспорта"
  (interactive)
  (save-excursion
    (outline-back-to-heading)
    (let ((start (search-forward-regexp ":LOGBOOK:"))
	  (end (- (search-forward-regexp ":END:") 5)))
      (replace-regexp-in-string "CLOCK:.*" "" (buffer-substring start end)))))

(defun si/export-convert-org-to-latex (orgString)
  "Возвращает `orgString' в формате LaTeX"
  (with-temp-buffer
    (insert orgString)
    (set-mark (point-max))
    (goto-char (point-min))
    (org-latex-convert-region-to-latex)
    (buffer-string)))

(defun si/org-export-current-task (&optional file-name open)
  "Экспорт текущей задачи в формат PDF
    Экспортирует задачу в которой находится точка"
  (interactive)
  (let ((title (org-entry-get (point) "ITEM"))
	(create (replace-regexp-in-string "\\(\\[\\|\\]\\)" "" (or (org-entry-get (point) "CREATED") "")))
	(status (org-entry-get (point) "TODO"))
	(id (concat (ignore-errors (substring (org-entry-get (point) "ID") 0 2)) "..."
		    (ignore-errors (substring (org-entry-get (point) "ID") 30 36))))
	(priority (or (ignore-errors (substring (org-entry-get (point) "FPRIORITY") 0 10)) ""))
	(link (replace-regexp-in-string "]]" ""
					(replace-regexp-in-string "\\[\\[.*\\]\\[" ""
								  (or (org-entry-get (point) "CONTEXT") ""))))
	(shedule (replace-regexp-in-string "\\(<\\|>\\)" "" (or (org-entry-get (point) "SCHEDULED") "")))
	(deadline (replace-regexp-in-string "\\(<\\|>\\)" "" (or (org-entry-get (point) "DEADLINE") "")))
	(effort (concat (or (org-entry-get (point) "Effort") "0:00") "/" (number-to-string (/ (org-clock-sum-current-item) 60)) ":" (format "%02d" (% (org-clock-sum-current-item) 60))))
	(tags (replace-regexp-in-string ":" " " (or (org-entry-get (point) "ALLTAGS") "")))
	(content nil)
	(notes (si/export-convert-org-to-latex (substring-no-properties (si/export-search-logbook-content)
									nil (if (< (length (si/export-search-logbook-content)) 1500)
										(length (si/export-search-logbook-content))
									      1500))))
	(resolution (or (org-entry-get (point) "RESOLVE") "")))
    (si/export-task title create status id priority link shedule deadline effort tags content notes resolution file-name open)))

(defun si/export-active-task-tags (tag &optional end-date)
  "Возвращает PDF из активных задач, имеющих тег TAG
    TAG - строка имени тега для поиска
    END-DATE - дата ограничивающая поиск задач справа"
  (interactive "sВведите тег для экспорта задач: ")
  (save-restriction
    (save-excursion
      (let ((count 1)
	    (cmd-string ""))
	(delete-directory si/export-tmp-dir t nil)
	(make-directory si/export-tmp-dir)
	(org-todo-list)
	(let ((line-num (count-lines (point-min) (point-max))))
	  (while (not (eq (line-number-at-pos) line-num))
	    (org-agenda-next-item 1)
	    (save-excursion
	      (when (string-match tag (or (org-entry-get (org-agenda-get-any-marker) "TAGS" t nil) ""))
		(org-agenda-goto)
		(si/org-export-current-task (concat "export-" (number-to-string count)) nil)
		(setq count (1+ count))))))
	(org-agenda-Quit)
	(setq count (1- count))
	(while (not (eq count 0))
	  (setq cmd-string (concat (concat "export-" (number-to-string count) ".pdf ") cmd-string))
	  (setq count (1- count)))
	(if (not (eq cmd-string ""))
	    (shell-command (concat "cd " si/export-tmp-dir " && pdftk " cmd-string " cat output export.pdf && open export.pdf"))
	  (message "Задач для экспорта не найдено"))))))


(defun si/find-shorten-long-word (string long short)
  "Возвращает сроку STRING в которой все слова длиннее LONG укорочены до длины SHORT"
  (let ((words (split-string string))
	number
	(index 0))
    (setq number  (length words))
    (while (< index number)
      (if (> (length (nth index words)) long) (setcar (nthcdr index words) (s-truncate short (nth index words))))
      (setq index (1+ index)))
    (s-join " " words)))

					;(require 'org-contacts)
(setq org-contacts-files '("~/projects/contacts/contacts.org"))

					;(load-file "~/.emacs.d/noelpa/helm-org-contacts/helm-org-contacts.el")
					;(require 'helm-org-contacts)

(global-set-key (kbd "<f9> k") 'helm-org-contacts)

(defun si/normalize-contact-item ()
  (interactive)
  (outline-next-heading)
  (let ((end-line (line-number-at-pos)))
    (outline-previous-heading)
    (while (< (line-number-at-pos) end-line)
      (next-line)
      (let ((begin (search-forward-regexp "." nil t (line-end-position)))
	    (end (line-end-position)))
	))))

					;(global-set-key (kbd "<f5>") 'si/normalize-contact-item)

(load-file "~/.emacs.d/noelpa/emacs-calfw/calfw.el")
(load-file "~/.emacs.d/noelpa/emacs-calfw/calfw-org.el")
(require 'calfw)
(require 'calfw-org)

(defun si/open-org-calendar ()
  "Close other windows and open cfw-calendar"
  (interactive)
  (delete-other-windows)
  (cfw:open-org-calendar))

					;(global-set-key (kbd "<f9> c") 'si/open-org-calenda)
(global-set-key (kbd "<f9> c") 'cfw:open-org-calendar)

(when (eq system-type 'darwin)
  (global-set-key (kbd "s-<f9>") 'org-toggle-inline-images))

(when (eq system-type 'windows-nt)
  (global-set-key (kbd "M-<f9>") 'org-toggle-inline-images))
