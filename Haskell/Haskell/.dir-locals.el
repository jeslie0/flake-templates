((nil
  . ((compile-command
      . "cabal build")

     (eglot-workspace-configuration
      . (:haskell (:formatingProvider "floskell")))
     ))

 (auto-mode-alist
  . (("\\.lock\\'"
      . json-ts-mode)))

 (haskell-mode
  . ((eval
      . (eglot-ensure))))

 (nix-mode
  . ((eval
      . (eglot-ensure))))
 )
