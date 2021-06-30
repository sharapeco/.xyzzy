;; -*- coding: utf-8 -*-

;; PHP
(load-library "myphp-mode")
(setq ed::*php-prog* "C:\\Server\\php72nts\\php.exe")
(pushnew '("\\.php$" . php-mode) *auto-mode-alist*)
(pushnew '("\\.php~$" . php-mode) *auto-mode-alist*)
(setq *php-mode-hook*
      '(lambda ()
        (setq c-indent-level 4)
        (setq c-brace-offset -4)
        (setq c-continued-statement-offset 4)
        (setq c-argdecl-indent 4)
        (setq c-label-offset 0)
        (setq c-brace-imaginary-offset 0)
        (setq indent-tabs-mode t)))

;; PHP マニュアル
(in-package "editor")

; (setq *php-doc-base-path* "http://php.net/manual/ja/function.")
(setq *php-doc-base-path* "https://www.google.co.jp/search?btnI=I&q=site:php.net%20")
(defun php-doc-function (&optional (func (php-get-word)))
  "php-mode: カーソル位置のPHPの関数マニュアルを開く"
  (interactive)
  (let ((path (concat *php-doc-base-path* (substitute-string func "_" "-"))))
    (shell-execute path t)))

;; 文法チェックを PHPStan に任せる
(defun php-phpstan (&optional (filename (get-buffer-file-name)))
  "php-mode: PHPStan でチェック"
  (interactive)
  (let (command
        (bufname "*phpstan*")
        buf
        line
        (error-message nil))
    (when filename
      (save-window-excursion
        (execute-shell-command
         (concat "phpstanan --loose \"" filename "\"") nil bufname)
        (switch-to-buffer bufname)
        (goto-char (point-min))
        (when (scan-buffer "^\\(.+\\):\\([0-9]+\\): *\\(.+\\)$" :regexp t)
          (setq error-message (match-string 3)
                line (parse-integer (match-string 2))))
        (kill-buffer bufname))
      (when error-message
        (setq buf (get-file-buffer filename))
        (unless buf
          (setq buf (create-file-buffer filename)))
        (switch-to-buffer buf)
        (goto-line line)
        (reverse-region (progn (goto-eol) (point))
                        (progn (goto-bol) (point)) t)
        (ding)
        (message (concat "♠♠♠PHPStan♠♠♠ " error-message)))
      (unless error-message
        (message (concat "♡♡♡PHPStan♡♡♡ No errors detected"))))))

(define-key *php-mode-map* '(#\C-c #\l) 'ed::php-phpstan)

(in-package "user")
