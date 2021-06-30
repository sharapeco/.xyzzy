;;; -*- coding: utf-8 -*-
;;; -*- Mode: Lisp -*-

;; 漢字コード・改行コードの初期設定
(setq *default-fileio-encoding* *encoding-utf8n*)
(setq *default-eol-code* *eol-crlf*)

;; http://xyzzy-022.github.io/xyzzy/2012/09/29/xyzzy-0_2_2_244-release-note/
;; ファイル保存時に一時ファイルを ... 作成する t / しない nil
;; Windows 10 で . で始まるファイルが保存できないので t にした
(setq file-precious-flag t)

;; ファイル保存時にハードリンクが切れないように
;; 常にコピーしてバックアップファイルを作成
(setq backup-by-copying t)

;; バックアップファイルはまとめて
(require "backup")
(setq *backup-directory* (merge-pathnames "~xyzzy/backup" (user-homedir-pathname)))
(setq *hierarchic-backup-directory* nil)
