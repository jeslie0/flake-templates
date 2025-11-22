;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((compile-command . "cargo build")
         (eglot-workspace-configuration . ())))
 (auto-mode-alist . (("\\.lock\\'" . json-ts-mode)))
 (rust-mode . ((eval . (eglot-ensure))))
 (nix-mode . ((eval . (eglot-ensure))))
 )
