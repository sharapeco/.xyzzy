;;; -*- coding: utf-8 -*-
;;; -*- Mode: Lisp -*-
;;
;; アプリ
;;

;; FreeCommander XE を起動する
(defun open-freecommander (&optional (dir nil))
  "FreeCommander で開く"
  (interactive)
  (let ((command "\"C:\\Program Files\\FreeCommander XE\\FreeCommander.exe\""))
	(if dir
		(call-process
		 (concat command " /C \"" dir "\" /T"))
	  (call-process
	   (concat command " /C"))
	  )))

;; 標準のファイラがわりに使う
(global-set-key '(#\C-c #\C-f) 'open-freecommander)
