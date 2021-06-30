;;; -*- coding: utf-8 -*-
;;; -*- Mode: Lisp -*-
;;
;; 文字列関連関数
;;
;; Reference: https://github.com/xyzzy-022/xyzzy/blob/develop/lisp/builtin.l

;; フルパスのファイル名だけ置換
(defun filter-filename (path filter)
  (let (slashpos dotpos dir file basename extension)
	(setq slashpos (string-match "/[^/]+$" path))
	(setq dir (substring path 0 slashpos))
	(setq file (substring path slashpos))
	(setq dotpos (string-match "[.]" file))
	(setq basename (substring file 0 dotpos))
	(setq extension (substring file dotpos))
	(concat dir (funcall filter basename) extension)))

;; snake_case を PascalCase に
(defun pascalize (str)
  (substitute-string
   (string-capitalize
    (substitute-string str "_" " "))
   " " ""))

;; loop の使い方
;; http://www.nct9.ne.jp/m_hiroi/clisp/abcl27.html
;;
;; loop for x from 1 to 10 ...           ; 1 から 10 まで
;; loop for x form 1 to 10 by 2 ...      ; 1, 3, 5, 7, 9
;; loop for x from 1 below 10 ...        ; 1 から 9 まで (10 を含まない)
;; loop for x from 10 downto 1 ...       ; 10 から 1 まで
;; loop for x from 10 downto 1 by 2 ...  ; 10, 8, 6, 4, 2
;; loop for x from 10 above 1 ...        ; 10 から 2 まで (1 を含まない)

;; Superscript に変換
(defun map-to-superscript (str)
  (let ((from "0123456789+--=()") (to "⁰¹²³⁴⁵⁶⁷⁸⁹⁺⁻⁻⁼⁽⁾"))
    (loop for i from 0 below (length from)
      do (setq str (substitute-string str (subseq from i (1+ i)) (subseq to i (1+ i)))))
    str))

;; Subscript に変換
(defun map-to-subscript (str)
  (let ((from "0123456789+--=()") (to "₀₁₂₃₄₅₆₇₈₉₊₋₋₌₍₎"))
    (loop for i from 0 below (length from)
      do (setq str (substitute-string str (subseq from i (1+ i)) (subseq to i (1+ i)))))
    str))

;; リージョンを superscript にする
(defun superscript-region (begin end)
  (interactive "r")
  (when (and begin end)
    (let ((replaced (map-to-superscript (buffer-substring begin end))))
      (delete-region begin end)
      (insert replaced))))

;; リージョンを subscript にする
(defun subscript-region (begin end)
  (interactive "r")
  (when (and begin end)
    (let ((replaced (map-to-subscript (buffer-substring begin end))))
      (delete-region begin end)
      (insert replaced))))

;; progn の使い方
;; https://wiki.gz-labs.net/index.php/Progn
;; 各式を順に評価して最後の式の値を返す。
;;
;; (progn (goto-bol) (point)) ; 式の値は行の先頭のポイントとなる

;; 指定した文字を含まない位置までカーソルを移動する
;; (skip-chars-forward "0123456789+--=()")

;; 現在の位置より前の変換できる文字を superscript にする
(defun superscript-backward ()
  (interactive)
  (let ((end (point))
        (begin (progn (skip-chars-backward "0123456789+--=()") (point))))
    (let ((replaced (map-to-superscript (buffer-substring begin end))))
      (delete-region begin end)
      (insert replaced))))

;; 現在の位置より前の変換できる文字を subscript にする
(defun subscript-backward ()
  (interactive)
  (let ((end (point))
        (begin (progn (skip-chars-backward "0123456789+--=()") (point))))
    (let ((replaced (map-to-subscript (buffer-substring begin end))))
      (delete-region begin end)
	  (insert replaced))))
