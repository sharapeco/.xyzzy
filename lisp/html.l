;;; -*- coding: utf-8 -*-
;;; -*- Mode: Lisp; Package: EDITOR -*-
;;;
;;; This file is not part of xyzzy.
;;;

(provide "html5mode")

(in-package "editor")

(export '(*html5-mode-hook* *html5-mode-map* html5-mode *html5-comment-column*))

(defvar *html5-mode-hook* nil)
(defvar *html5-comment-column* 0)

(defvar *html5-mode-syntax-table* nil)
(unless *html5-mode-syntax-table*
  (setq *html5-mode-syntax-table* (make-syntax-table))
  (do ((x #x21 (1+ x)))((>= x #x7f))
    (let ((c (code-char x)))
      (unless (alphanumericp c)
	(set-syntax-punctuation *html5-mode-syntax-table* c))))
  (set-syntax-symbol-prefix *html5-mode-syntax-table* #\&)
  (set-syntax-symbol *html5-mode-syntax-table* #\-)
  (set-syntax-symbol *html5-mode-syntax-table* #\:)
  ;(set-syntax-string *html5-mode-syntax-table* #\")
  (set-syntax-tag *html5-mode-syntax-table* #\< #\>)
  (set-syntax-symbol *html5-mode-syntax-table* #\/))

;; キーワード色分け、正規表現版
(defvar *html5-mustache-format*
  (compile-regexp-keyword-list
   '(
     ;; Mustache (Mustache-PHP + ZZL-Mustache)
     ("{{![^}]*}}" nil :comment)
     ("{{% +[^}]+ +}}" nil (:keyword 1 :bold))
     ("{{< +[^}]+ +}}" nil (:keyword 2 :bold))
     ("{{$ +[^}]+ +}}" nil (:keyword 2 :bold))
     ("{{[^}]+}}" nil (:color 3))
     ;; Latte
;;      ("{\\*[^}]*\\*}" nil :comment)
;;      ("{\\(layout\\|block\\|include\\) +[^}]+}" nil (:keyword 2 :bold))
;;      ("{/\\(block\\)}" nil (:keyword 2 :bold))
;;      ("{\\(var\\|default\\|capture\\) +[^}]+}" nil (:keyword 1))
;;      ("{\\(if\\|elseif\\|ifset\\|elseifset\\|switch\\|case\\|foreach\\|for\\|while\\|continueIf\\|breakIf\\|\\) +[^}]+}" nil (:color 1))
;;      ("{\\(else\\|default\\|first\\|last\\|sep\\|spaceless\\)}" nil (:color 1))
;;      ("{/\\(if\\|ifset\\|switch\\|foreach\\|for\\|spaceless\\)}" nil (:color 1))
;;      ("{[^}]+}" nil (:color 3))
     ;; HTML
     ("<[^>]*>" nil (:keyword 0))
     ("&[#A-Za-z][0-9A-Za-z]\\{,6\\};" nil (:color 6))
     ))
  "html5-mode: キーワード色分け、正規表現版")

(defvar *html5-mode-map* nil)
(unless *html5-mode-map*
  (setq *html5-mode-map* (make-sparse-keymap)))

(defvar *html5-mode-abbrev-table* nil)
(unless *html5-mode-abbrev-table*
  (define-abbrev-table '*html5-mode-abbrev-table*))

;; モード定義
(defun html5-mode ()
  (interactive)
  (kill-all-local-variables)
  (setq buffer-mode 'html5-mode)
  (setq mode-name "HTML5")
  (use-keymap *html5-mode-map*)
  (use-syntax-table *html5-mode-syntax-table*)
  (make-local-variable 'regexp-keyword-list)
  (setq regexp-keyword-list *html5-mustache-format*)
  (setq *local-abbrev-table* *html5-mode-abbrev-table*)
  (setq comment-start "<!-- ")
  (setq comment-end " -->")
  (setq comment-start-skip "<!--[ \t]*")
  (when *html5-comment-column*
    (setq comment-column *html5-comment-column*))
  (run-hooks '*html5-mode-hook*))

;; add extensions
(setq *html5-keyword-file* "HTML5-Mustache")
(pushnew '("\\.html$" . html5-mode) *auto-mode-alist*)
(pushnew '("\\.html~$" . html5-mode) *auto-mode-alist*)
(pushnew '("\\.ajp$" . html5-mode) *auto-mode-alist*)
(pushnew '("\\.ajp~$" . html5-mode) *auto-mode-alist*)
(pushnew '("\\.ctp$" . html5-mode) *auto-mode-alist*)
(pushnew '("\\.ctp~$" . html5-mode) *auto-mode-alist*)
