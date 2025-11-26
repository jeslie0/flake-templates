;;; Directory Local Variables            -*- no-byte-compile: t -*-
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((compile-command . "cmake --build build")
         (eglot-workspace-configuration . ())))
 (auto-mode-alist . (("\\.lock\\'" . json-ts-mode)))
 (c-mode . ((eval . (eglot-ensure))))
 (c-ts-mode . ((eval . (eglot-ensure))))
 (c++-mode . ((eval . (eglot-ensure))))
 (c++-ts-mode . ((eval . (eglot-ensure))))
 (cmake-mode . ((eval . (eglot-ensure))))
 (cmake-ts-mode . ((eval . (eglot-ensure))))
 )
