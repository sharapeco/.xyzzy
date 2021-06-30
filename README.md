# xyzzy settings

次の内容を `~/.xyzzy` に設定して、 `~/~xyzzy/lisp/*.l` を読み込むようにしている。

```lisp
;; 初期ディレクトリ
(cd "C:/path/to/directory")

;; xyzzy 起動時にワーキングディレクトリを $XYZZY に移動
(defun chdir-to-system-root ()
  (chdir (si:system-root)))
(add-hook '*post-startup-hook* 'chdir-to-system-root)

;; ~/~xyzzy/lisp 配下の lisp ファイルを読み込む
(mapcar #'mc-load-file (directory "~/~xyzzy/lisp/" :absolute t :wild "*.l"))
```

- 読み込み順はよく調べていないので順序が重要な内容は別ファイルにしないほうがいいかも
