(define-key mu4e-headers-mode-map (kbd "<f9> <f9>") 'tf-mu4e-headers-task-create)
(define-key mu4e-headers-mode-map (kbd "<f9> <f9>") 'tf-mu4e-headers-task-create)

(defvar tf-inbox-dir "~/pro/inbox"
  "Path to the directory with incoming files")

(defun tf-open-dir-incoming-files ()
  "Open a directory with incoming files.
The directory is set by the variable `tf-inbox-dir`"
  (interactive)
  (dired tf-inbox-dir)
  (delete-other-windows))

(global-unset-key (kbd "C-<f9> i"))
(global-set-key (kbd "C-<f9> i") 'tf-open-dir-incoming-files)

(setq exec-path (append exec-path '("/usr/local/bin")))

(defun tf-insert-note (text &optional file)
  "Adds a new note `text' to the task where the point is located.
Optionally, the `file' is added to the attachment"
  ())

(define-key dired-mode-map (kbd "<f9> a") 'org-attach-dired-to-subtree)

(use-package pdf-tools
  ; :pin manual
   :config
   (pdf-tools-install)
   (setq-default pdf-view-display-size 'fit-width)
   (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
   :custom
   (pdf-annot-activate-created-annotations t "automatically annotate highlights"))

(setq TeX-view-program-selection '((output-pdf "PDF Tools"))
      TeX-view-program-list '(("PDF Tools" TeX-pdf-tools-sync-view))
      TeX-source-correlate-start-server t)

(add-hook 'TeX-after-compilation-finished-functions
	  #'TeX-revert-document-buffer)
