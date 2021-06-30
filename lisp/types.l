;;; -*- coding: utf-8 -*-
;;; -*- Mode: Lisp -*-

;; C/C++
(setq c-indent-level 4)
(setq c-brace-offset -4)
(setq c-continued-statement-offset 4)
(setq c-argdecl-indent 4)
(setq c-label-offset -4)
(setq c-brace-imaginary-offset 0)

(setq *c-mode-hook*
      '(lambda ()
        (setq c-brace-offset -4)
        (setq indent-tabs-mode t)))

(setq *c++-mode-hook*
      '(lambda ()
        (setq c-brace-offset -4)
        (setq indent-tabs-mode t)))

;; LaTeX
(push '("\\.tex~?$" . LaTeX-mode) *auto-mode-alist*)
(push '("\\.sty~?$" . LaTeX-mode) *auto-mode-alist*)

;; PowerShell
(push '("\\.ps1~?$" . powershell-mode) *auto-mode-alist*)
(define-key *powershell-edit-mode-map* #\C-A nil)

;; Ruby
(load-library "ruby")
(push '("\\.rb~?$" . ruby-mode) *auto-mode-alist*)
(setq *ruby-mode-hook*
      '(lambda ()
        (setq *ruby-indent-column* 4)
        (setq indent-tabs-mode t)
        ))
(define-key *ruby-mode-map* #\C-h 'delete-backward-char-or-selection)

;; Swift
(load-library "swift-mode")
(push '("\\.swift~?$" . swift-mode) *auto-mode-alist*)

;; bash (sh)
(load-library "bash-mode")
(push '("\\.sh~?$" . bash-mode) *auto-mode-alist*)

;; Lisp
;; Emacs Lisp も .xyzzy も
(pushnew '("\\.el~?$" . lisp-mode) *auto-mode-alist*)
(pushnew '("/\\.xyzzy$" . lisp-mode) *auto-mode-alist*)
(setq *lisp-mode-hook*
      '(lambda ()
        (setq indent-tabs-mode nil)))

;; Markdown
(load-library "markdown-mode")
(load-library "markdown-misc")
(push '("\\.md~?$" . markdown-mode) *auto-mode-alist*)
(setq md::*markdown-converter* "C:\\Server\\php73\\php.exe C:\\Apps\\php-tools\\markdown\\markdown.php")


;; sql-mode
;(setq *sql-keyword-file* '("SQL" "Sql-NonStd/PostgreSQL"))
(in-package "editor")
(add-hook '*sql-mode-hook*
          #'(lambda ()
              (set-syntax-start-c++-comment *sql-mode-syntax-table* #\-)
              (set-syntax-end-c++-comment *sql-mode-syntax-table* #\LFD)))
(in-package "user")
(push '("/_table\\.txt$" . sql-mode) *auto-mode-alist*)

;; cmd
(push '("\\.bat~?$" . bat-mode) *auto-mode-alist*)
(push '("\\.cmd~?$" . bat-mode) *auto-mode-alist*)
