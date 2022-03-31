{
  description = "My Haskell project";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        haskellPackages = pkgs.haskellPackages;
        packageName = throw "Insert Project Name Here";
      in
        {
          packages.${packageName} = haskellPackages.callCabal2nix packageName self {};

          defaultPackage = self.packages.${system}.${packageName};


          devShell = haskellPackages.shellFor {
            packages = p: [ self.defaultPackage.${system} ]; # This automatically pulls cabal libraries into the devshell, so they can be used in ghci
            buildInputs = with haskellPackages; [ ghc
                                                  haskell-language-server
                                                  cabal-install
                                                  apply-refact
                                                  hlint
                                                  stylish-haskell
                                                  hasktags
                                                  hindent
                                                ];

            # This will build the cabal project and add it to the path. We probably don't want that to happen.
            # inputsFrom = builtins.attrValues self.packages.${system};

            # Enables Hoogle for the builtin packages.
            withHoogle = true;
          };
        }
    );
}
