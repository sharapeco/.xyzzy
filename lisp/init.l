;;; -*- coding: utf-8 -*-
;;; -*- Mode: Lisp -*-

;; Netinstaller
(require "ni/setup")
(ni-autoload)

;; 辞書をポップアップで表示する
(require "edict-popup")

;; カスタム版 buffer-menu
(require "my-buf-menu")

;; ステータスバーに現在の文字コードとUnicodeを表示する
(setq *status-bar-format* "cu")

;; ウィンドウをはじめから分割しておく
(if (= (count-windows) 1)
    (split-window-vertically))
