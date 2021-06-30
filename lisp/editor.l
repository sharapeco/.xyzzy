;;; -*- coding: utf-8 -*-
;;; -*- Mode: Lisp -*-

;; インクリメンタルサーチ
(require "isearch")

;; 日付を挿入
(defun my-insert-date()
  (interactive)
  (insert (format-date-string "%Y-%m-%d (%v)")))
(global-set-key '(#\C-x #\t #\d) 'my-insert-date)

;; ファイル名も欲しい (C-x C-v)
(setq *find-other-file-requires-file-name* t)

;; カーソル位置の単語を選択
(defun select-word ()
  (interactive)
  (progn
	(skip-syntax-spec-backward "w_")
	(start-selection 2 t)
	(skip-syntax-spec-forward "w_")
	))
(global-set-key #\M-e 'select-word)

;; バッファ全体をコピー
(defun copy-buffer ()
  (interactive)
  (let ((currentpo (point)))
    (selection-whole-buffer)
    (copy-selection-to-clipboard)
    (start-selection-as-line)
    (goto-char currentpo)
    (message "Copied entire buffer to clipboard")))
(global-set-key '(#\C-c #\C-a) 'copy-buffer)

;; TABで選択範囲をインデント
(defun indent-selected-lines ()
  (interactive "*")
  (let ((start-line-number nil) (end-line-number nil) (do-indent-flag nil))
    (selection-start-end (start end)

      (goto-char start)
      (if (and (bolp) (> start end)) (backward-char 1))
      (setq start-line-number (current-line-number))

      (goto-char end)
      (if (and (bolp) (< start end)) (backward-char 1))
      (setq end-line-number (current-line-number))

      (if (> start-line-number end-line-number)
        (rotatef start-line-number end-line-number)
      )

      (if (/= (progn (goto-char start) (current-line-number)) (progn (goto-char end) (current-line-number)) ) 
        (progn 
          (setq do-indent-flag t)
          (shift-region start end)
          (goto-line start-line-number)
          (start-selection 1 t)
          (while (<= (current-line-number) end-line-number)
            (selection-next-virtual-line)
          )
        )
        (delete-region start end)
      )
    )

    (if (null do-indent-flag) (insert "\t"))
  )
)

(defun unindent-selected-lines ()
  (interactive "*")
  (let ((start-line-number nil) (end-line-number nil))
    (selection-start-end (start end)
      (goto-char start)
      (if (and (bolp) (> start end)) (backward-char 1))
      (setq start-line-number (current-line-number))

      (goto-char end)
      (if (and (bolp) (< start end)) (backward-char 1))
      (setq end-line-number (current-line-number))

      (if (> start-line-number end-line-number)
        (rotatef start-line-number end-line-number)
      )

      (unshift-region start end)

      (goto-line start-line-number)
      (start-selection 1 t)
      (while (<= (current-line-number) end-line-number)
         (selection-next-virtual-line)
      )
    )
  )
)

;; かな入力時の補助
(load-library "hankana")

