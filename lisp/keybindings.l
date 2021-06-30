;;; -*- coding: utf-8 -*-
;;; -*- Mode: Lisp -*-
;;
;; キーバインド
;;

;; No-break space を挿入する
(defun insert-nbsp ()
  (interactive)
  (insert (unicode-char 160)))
(global-set-key '(#\C-x #\SPC) 'insert-nbsp)

;; 簡単に終了するな
(global-unset-key '(#\C-x #\C-c))

;; タブをスペースに崩すな
(global-set-key #\C-h 'delete-backward-char-or-selection)

;; M-g のエイリアス
(global-set-key '(#\C-c #\g) 'goto-line)

;; やっぱヴァーチャル
(global-set-key #\C-a 'beginning-of-virtual-line)
(global-set-key #\C-e 'end-of-virtual-line)

;; Home, End で変なところに飛ばないように
(global-set-key #\Home 'beginning-of-virtual-line)
(global-set-key #\S-Home 'selection-beginning-of-virtual-line)
(global-set-key #\End 'end-of-virtual-line)
(global-set-key #\S-End 'selection-end-of-virtual-line)

;; ややEmacsちっくに
(global-set-key #\M-% 'query-replace)
(global-set-key #\C-/ 'undo)
(global-set-key #\C-\\ 'redo)
(global-set-key '(#\C-x #\C-w) 'emacs-write-file)
(global-set-key '(#\C-x #\u) 'undo)
(global-set-key #\M-C-\\ 'indent-region)
(require "dabbrev")
(global-set-key #\M-/ 'dabbrev-expand)
(global-set-key #\M-\\ 'dabbrev-popup)
(global-set-key '(#\C-x #\3) 'split-window-vertically) ; VSCode の Emacs キーバインドに合わせる

;; コメント
(global-set-key '(#\C-c #\q) 'comment-out-region)

;; clickable-uri
(require "clickable-uri")
(setq ed::*clickable-uri-scheme-list* '("http" "https" "file" "mailto" "ttp"))
(global-set-key '(#\C-c #\C-o) 'clickable-uri-open)

;; 文字変換
(global-set-key '(#\C-c #\C-u) 'superscript-backward)
(global-set-key '(#\C-c #\C-l) 'subscript-backward)

;; フレーム移動
(global-set-key #\S-M-Right 'next-pseudo-frame)
(global-set-key #\S-M-Left 'previous-pseudo-frame)

;;; ミニバッファに入ったときIMEをOFFにする
(export '(*ime-mode-into-minibuffer*))
(defvar *ime-mode-into-minibuffer* nil)

(defun ime-state-get-and-setoff (bef-buffer file-name)
  (interactive)
  (setq *ime-mode-into-minibuffer* (get-ime-mode))
  (toggle-ime nil))

(defun ime-state-set (bef-buffer file-name)
  (interactive)
  (toggle-ime *ime-mode-into-minibuffer*))

(add-hook '*enter-minibuffer-hook* 'ime-state-get-and-setoff)
(add-hook '*exit-minibuffer-hook* 'ime-state-set)

(global-set-key #\TAB 'indent-selected-lines)
(global-set-key #\C-] 'indent-selected-lines)
(set-extended-key-translate-table exkey-S-tab #\F20)
(global-set-key #\F20 'unindent-selected-lines)
(global-set-key #\M-C-] 'unindent-selected-lines)

;; 行頭にあると改行を含めた行全体をkillをする。 それ以外は標準の Kill-Lineと同じ処理をする。
(defun kill-line-CR (&optional lines)
  (interactive "*p")
  (kill-region (point)
	(progn
	  (cond ((null lines)
		 (cond ((eolp) (forward-line 1))
		       ((bolp) (goto-eol)(forward-char))
		       (t (goto-eol))))
		((zerop lines) (if(bolp)(forward-line -1)(goto-bol)))
		(t (forward-line lines)))
	  (point)
	)
  ))
(global-set-key #\C-k 'kill-line-CR)
