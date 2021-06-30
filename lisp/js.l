;;; -*- coding: utf-8 -*-

;; 共通のキーワードファイル
(setq ed::*jscript-keyword-file* "ES2015")

;; JavaScript
(require "jscript-mode")
(define-key *jscript-mode-map* '(#\C-c #\l) 'eslint)
(define-key *jscript-mode-map* #\C-h 'delete-backward-char-or-selection)
(setq *jscript-mode-hook*
      '(lambda ()
        (setq *jscript-keyword-file* "ES2015")
        (setq *jscript-keyword-hash-table*
              (load-keyword-file *jscript-keyword-file*))
        (setq keyword-hash-table *jscript-keyword-hash-table*)
        (setq jscript-comment-indent 4)
        (setq c-indent-level 4)
        (setq c-brace-offset -4)
        (setq c-continued-statement-offset 0)
        (setq c-argdecl-indent 4)
        (setq c-label-offset 0)
        (setq c-brace-imaginary-offset 0)
        (setq indent-tabs-mode t)))
(pushnew '("\\.js~$" . jscript-mode) *auto-mode-alist*)
(pushnew '("\\.json$" . jscript-mode) *auto-mode-alist*)
(pushnew '("\\.json~$" . jscript-mode) *auto-mode-alist*)
(pushnew '("\\.jsx$" . jscript-mode) *auto-mode-alist*)
(pushnew '("\\.jsx~$" . jscript-mode) *auto-mode-alist*)
(pushnew '("\\.as$" . jscript-mode) *auto-mode-alist*)
(pushnew '("\\.as~$" . jscript-mode) *auto-mode-alist*)
(pushnew '("\\.mxml$" . jscript-mode) *auto-mode-alist*)
(pushnew '("\\.mxml~$" . jscript-mode) *auto-mode-alist*)
(pushnew '("\\.qml$" . jscript-mode) *auto-mode-alist*) ; MuseScore Plugin

;; TypeScript
(require "typescript-mode")
(define-key *typescript-mode-map* '(#\C-c #\l) 'eslint)
(define-key *typescript-mode-map* #\C-h 'delete-backward-char-or-selection)
(setq *typescript-mode-hook*
      '(lambda ()
        (setq *jscript-keyword-file* "TypeScript")
        (setq *jscript-keyword-hash-table*
              (load-keyword-file *jscript-keyword-file*))
        (setq keyword-hash-table *jscript-keyword-hash-table*) ; キーワードファイルを再読み込み
        (setq typescript-comment-indent 4)
        (setq c-indent-level 4)
        (setq c-brace-offset -4)
        (setq c-continued-statement-offset 0)
        (setq c-argdecl-indent 4)
        (setq c-label-offset 0)
        (setq c-brace-imaginary-offset 0)
        (setq indent-tabs-mode t)))
(pushnew '("\\.ts$" . typescript-mode) *auto-mode-alist*)
(pushnew '("\\.ts~$" . typescript-mode) *auto-mode-alist*)
(pushnew '("\\.tsx$" . typescript-mode) *auto-mode-alist*)
(pushnew '("\\.tsx~$" . typescript-mode) *auto-mode-alist*)

;; Coffee script
(load-library "coffee-mode")
(pushnew '("\\.coffee$" . coffee-mode) *auto-mode-alist*)
(pushnew '("\\.coffee~$" . coffee-mode) *auto-mode-alist*)
(setq coffee::*hook*
      '(lambda ()
        (setq coffee::*tab-width* 4)
        ))

;; Linter の設定
(defun eslint (&optional (filename (get-buffer-file-name)))
  "jscript-mode: このファイルの文法チェック"
  (interactive)
  (let (command
        (bufname "*ESLint*")
        (noerror-message "No errors detected")
        buf
        line
        col
        (error-message nil))
    (when filename
      (save-window-excursion
        (execute-shell-command
         (concat "eslint --fix \"" filename "\"") nil bufname)
        (switch-to-buffer bufname)
        (goto-char (point-min))
        (unless (looking-for noerror-message)
          (when (scan-buffer "^ *\\([0-9]+\\):\\([0-9]+\\) +error +.+$" :regexp t)
            (setq error-message (match-string 0)
                  noerror-message (match-string 0)
                  line (parse-integer (match-string 1))
                  col (parse-integer (match-string 2))
                  )))
        (kill-buffer bufname))
      (when error-message
        (setq buf (get-file-buffer filename))
        (unless buf
          (setq buf (create-file-buffer filename)))
        (switch-to-buffer buf)
        (goto-line line)
        (reverse-region (progn (goto-eol) (point))
                        (progn (goto-bol) (point)) t)
        (goto-column (- col 1))
        (ding))
      (message noerror-message))))
