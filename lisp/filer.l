;;; -*- coding: utf-8 -*-
;;; -*- Mode: Lisp -*-
;;
;; ファイラ
;;

;; ファイラで上向きスクロール
(define-key filer-keymap #\M-v 'filer-backward-page)
(define-key filer-keymap #\M-o 'filer-view-file)
(define-key filer-keymap #\C-l 'filer-reload)
(define-key filer-keymap #\_ 'filer-goto-root)
(define-key filer-keymap #\TAB 'filer-swap-windows)
(define-key filer-keymap #\C-t 'filer-toggle-mark-files)

;; ファイラのフォント設定
(add-hook '*init-app-menus-hook*
          #'(lambda ()
              (set-filer-font :face "Yu Gothic UI" :size 14)))

;; ファイラのガイドテキスト
(setq *filer-guide-text*
      '("A:属性  C:コピー  D:削除  E:解凍  F:検索  J:DIR移動  K:mkdir  L:ドライブ  M:移動  N:ファイル名  O:圧縮  P:DIR??"
        "R:名前変更  S:DIR??  T:ショートカット  U:DIRサイズ  V:リスト  X:実行  .:マスク  /:マーク  *:load  C-t:トグル  C-l:リロード  M-d:WinMerge"))

;; ファイラの初期ディレクトリ
(setq *filer-primary-directory* (default-directory)) ; 左側
(setq *filer-secondary-directory* (default-directory)) ; 右側

;; ファイラの初期ファイルマスク
;; 2画面用
(setq *filer-primary-file-mask* '("*"))   ; 左側
(setq *filer-secondary-file-mask* '("*")) ; 右側
;; 1画面用
(setq *filer-last-file-mask* '("*"))

;; ファイラでファイル名をコピーする
(defun filer-get-filenamestring (filename type)
  (interactive)
  (let (str)
    (cond
     ((= type 1) (setq str (if (file-directory-p filename)
                               (car (reverse (pathname-directory (concat filename "x"))))
                             (file-namestring filename))))
     ((= type 2) (setq str filename))
     ((= type 3) (setq str (map-slash-to-backslash filename)))
     ((= type 4) (setq str (concat "file:///" filename))))
    str))

(defun my-filer-make-clipboard-string (lst)
   (apply #'concat (mapcar #'(lambda (x) (concat x "\n")) lst)))

(defun filer-get-filenames (type)
  (interactive)
  (let ((selected-files (or (filer-get-mark-files)
                            (list (filer-get-current-file)))))
    (copy-to-clipboard (my-filer-make-clipboard-string
                        (mapcar #'(lambda (filename) (filer-get-filenamestring filename type)) selected-files)))
    (message "ファイル名をコピーしました")))

;; ファイラでファイル名をコピーするメニュー
(defvar *get-filenamestring-menu* nil)
(define-key filer-keymap #\C-Insert
            #'(lambda () (interactive)
                (unless *get-filenamestring-menu*
                  (setq *get-filenamestring-menu*
                        (define-popup-menu
                          (:item nil "ファイル名のみコピー(&F)"
                           #'(lambda () (interactive) (filer-get-filenames 1)))
                          (:item nil "フルパス(/)でコピー(&S)"
                           #'(lambda () (interactive) (filer-get-filenames 2)))
                          (:item nil "フルパス(\\)でコピー(&E)"
                           #'(lambda () (interactive) (filer-get-filenames 3)))
                          (:item nil "URL表記でコピー(&U)"
                           #'(lambda () (interactive) (filer-get-filenames 4)))
                          )))
                (track-popup-menu *get-filenamestring-menu*)))

;; 大文字のファイル名をファイラで一括して小文字へ
(defun filer-downcase-filename ()
  (let ((files (filer-get-mark-files)))
    (when (and files (yes-or-no-p "小文字にしまっせ"))
      (filer-subscribe-to-reload (filer-get-directory))
      (mapc #'(lambda (x) (rename-file x (string-downcase x))) files)
      (filer-demand-reload)
      (filer-goto-file (file-namestring (car files))))
    t))
(define-key filer-keymap '(#\C-x #\C-l) 'filer-downcase-filename)

;; 大文字のファイル名をファイラで一括して小文字へ
(defun filer-pascalize-filename ()
  (let ((files (filer-get-mark-files)))
    (when (and files (yes-or-no-p "PascalCase にしまっせ"))
      (filer-subscribe-to-reload (filer-get-directory))
      (mapc #'(lambda (x) (rename-file x (filter-filename x 'pascalize))) files)
      (filer-demand-reload))
    t))
(define-key filer-keymap '(#\C-x #\t #\p) 'filer-pascalize-filename)

;; ファイラのデフォルト圧縮形式をZIPにする (lisp/filer.l を上書き)
(in-package "editor")
(defun filer-get-archive-name ()
  (multiple-value-bind (result data)
      (dialog-box '(dialog 0 0 251 95
		    (:caption "ファイルの圧縮")
		    (:font 9 "MS UI Gothic")
		    (:control
		     (:static nil "ファイル名(&N):" #x50020000 7 64 38 8)
		     (:edit name nil #x50810080 7 74 160 14)
		     (:button IDOK "OK" #x50010001 194 7 50 14)
		     (:button IDCANCEL "キャンセル" #x50010000 194 24 50 14)
		     (:static nil "作成するディレクトリ(&D):" #x50020000 8 7 64 8)
		     (:combobox dir nil #x50210102 8 18 160 85)
		     (:button ref "参照..." #x50010000 169 17 22 14)
		     (:static nil "基準ディレクトリ(&B):" #x50020000 7 35 53 8)
		     (:edit base nil #x50810080 7 45 160 14)
		     (:button baseref "参照..." #x50010000 169 45 22 14)))
		  (list (cons 'dir (filer-get-directory))
			(cons 'dir *filer-archive-directory-history*)
			(cons 'base (filer-get-directory)))
		  '((name :non-null "アーカイブファイル名を入力してください" :enable (IDOK))
		    (ref :related dir :directory-name-dialog (:title "参照"))
		    (baseref :related base :directory-name-dialog (:title "参照"))))
    (when result
      (let* ((dir (cdr (assoc 'dir data)))
	     (file (merge-pathnames (cdr (assoc 'name data)) dir)))
	(add-history dir '*filer-archive-directory-history*)
	(values (cond ((string-matchp "\\.lzh$" file) file)
		      ((string-matchp "\\.zip$" file) file)
		      ((string-matchp "\\.cab$" file) file)
		      ((string-matchp "\\.tar$" file) file)
		      ((string-matchp "\\.tar\\.gz$" file) file)
		      ((string-matchp "\\.tar\\.bz2$" file) file)
		      ((string-matchp "\\.tar\\.Z$" file) file)
		      ((string-matchp "\\.tar\\.lzma$" file) file)
		      ((string-matchp "\\.tar\\.xz$" file) file)
		      ((string-matchp "\\.tbz$" file) file)
		      ((string-matchp "\\.tgz$" file) file)
		      ((string-matchp "\\.taz$" file) file)
		      ((string-matchp "\\.bza$" file) file)
		      ((string-matchp "\\.gza$" file) file)
		      ((string-matchp "\\.yz1$" file) file)
		      ((string-matchp "\\.7z$" file) file)
		      ((string-matchp "\\.exe$" file) file)
		      (t (concat file ".zip")))
		(merge-pathnames (cdr (assoc 'base data))
				 (filer-get-directory)))))))
(in-package "user")
