;;; -*- coding: utf-8 -*-
;;; -*- Mode: Lisp -*-
;;
;; diff
;;

;; diff コマンド
(setq *my-diff-command* "\"C:/Program Files/WinMerge/WinMergeU.exe\" /s")

;; カレントバッファでdiff
;; new file: 現在のバッファがファイルに紐づいていればこのバッファ、そうでなければファイルを指定する
;; old file: 別ウィンドウに開いているバッファがファイルに紐づいていればそのバッファ、そうでなければファイルを指定する
(defun diff-current-buffers ()
  (interactive)
  (let ((current-file-name (get-buffer-file-name (selected-buffer)))
        (another-file-name (and (not (eq (count-windows) 1))
                                (get-buffer-file-name (window-buffer (next-window (selected-window)))))))
    (call-process
     (format nil "~A \"~A\" \"~A\"" *my-diff-command*
          (or current-file-name (read-file-name "diff(new file): "))
             (or (and (not (eq current-file-name another-file-name)) another-file-name)
                 (read-file-name "another file(older): "))))))

(define-key ctl-x-map #\d 'diff-current-buffers)

;; ファイラで左右のファイル・ディレクトリを比較
(defun filer-diff-file ()
  (let ((file1 (ed::filer-fetch-file nil nil))
	(file2 (ed::filer-fetch-file nil t)))
    (unless (and file1 file2)
      (error "比較するファイルを指定して"))
    (call-process
     (format nil "~A \"~A\" \"~A\"" *my-diff-command* file1 file2))))

(define-key filer-keymap #\M-d 'filer-diff-file)
