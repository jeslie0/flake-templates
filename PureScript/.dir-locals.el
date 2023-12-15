((nil
  . ((compile-command
      . "spago bundle")

     (eglot-workspace-configuration
      . (:purescript (:outputDirectory "./output" :formatter "purs-tidy")))))

 (auto-mode-alist
  . (("\\.lock\\'"
      . json-ts-mode)))

 (purescript-mode
  . ((eval
      . (eglot-ensure))))

 (nix-mode
  . ((eval
      . (eglot-ensure))))
 )
