;;; -*- coding: utf-8 -*-
;;; -*- Mode: Lisp -*-

;; クリップボードエンコーディングを自動判別
(setq *clipboard-char-encoding* *encoding-auto*)

;; キルリングをポップアップで選択
(defvar *yank-select-popup-menu* nil)
(setq *yank-select-popup-menu* (create-popup-menu nil))
(defun yank-select ()
  (interactive)
  (while (get-menu-position *yank-select-popup-menu* 'yank-select)
    (delete-menu *yank-select-popup-menu* 'yank-select))
  (continue-pre-selection)
  (dotimes (arg (length *kill-ring*))
    (let ((string (car (ed::current-kill arg t))))
      (add-menu-item *yank-select-popup-menu* 'yank-select
                     (if (< (length string) 40)
                         string
                       (substring string 0 40))
                     #'(lambda ()
                         (interactive)
                         (insert string)))))
  (track-popup-menu *yank-select-popup-menu*))

(global-set-key '(#\C-c #\C-y) 'yank-select)
