;; Windows Terminal を開く
(defun open-terminal ()
  (interactive)
  (let ((command "wt.exe new-tab")
		(params "")
		(current-file (get-buffer-file-name (selected-buffer))))
	(if current-file
		(setq params (format nil " --startingDirectory \"~A\"" (directory-namestring current-file))))
	(launch-application (concat command params))))

;; (run-console) のかわりにする
(global-set-key '(#\C-x #\c) 'open-terminal)
