;;; -*- coding: utf-8 -*-
;;; -*- Mode: Lisp -*-

;; CSS
;; @規則や!に色付けする。
;; (load-library "css-mode")
;; (set-syntax-word ed::*css-mode-syntax-table* #\@)
;; (set-syntax-word ed::*css-mode-syntax-table* #\!)

;; Less CSS
(load-library "less-mode")
(pushnew '("\\.css$" . less-mode) *auto-mode-alist*)
(pushnew '("\\.less$" . less-mode) *auto-mode-alist*)
(pushnew '("\\.scss$" . less-mode) *auto-mode-alist*)

;; Stylus CSS
(load-library "stylus-mode")
(pushnew '("\\.styl$" . less-mode) *auto-mode-alist*)
;(pushnew '("\\.styl$" . stylus-mode) *auto-mode-alist*)

;; SCSS
;; (load-library "sass-mode")
;; (setq ed::*sass-mode-hook*
;;       '(lambda ()
;;         (setq c-indent-level 4)
;;         (setq c-brace-offset -4)
;;         (setq c-continued-statement-offset 0)
;;         (setq c-argdecl-indent 4)
;;         (setq c-label-offset 0)
;;         (setq c-brace-imaginary-offset 0)
;;         (setq indent-tabs-mode t)))
