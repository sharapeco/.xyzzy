;; スキーマ文字列のリスト
;; 使わないプロトコルは除外する
(setq ed::*clickable-uri-scheme-list*
      '("http" "https" "mailto" "ttp"))

;; URI に使用する文字列のリスト
;; 余計なものを除く
; original
; (setq ed::*clickable-uri-chars* "-a-zA-Z0-9_/~.@?&=;+(),'$!*:#%|")
(setq ed::*clickable-uri-chars* "-a-zA-Z0-9_./:~.@%?&=;+#,$!")
