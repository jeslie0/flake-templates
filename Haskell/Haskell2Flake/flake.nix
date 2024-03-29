{
  description = "My Haskell project";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        haskellPackages = pkgs.haskellPackages;
        packageName = with builtins;
          let cabalFileName = head (filter
            (name: pkgs.lib.hasSuffix ".cabal" name)
            (attrNames (readDir ./.)));
          in head (match "^.*name\:\ *([^[:space:]]*).*$" (readFile "${./.}\/${cabalFileName}"));
      in
      {
        packages.${packageName} = haskellPackages.callCabal2nix packageName self { };

        defaultPackage = self.packages.${system}.${packageName};

        devShell = haskellPackages.shellFor {
          packages = p: [ self.defaultPackage.${system} ]; # This automatically pulls cabal libraries into the devshell, so they can be used in ghci
          buildInputs = with haskellPackages;
            [ haskell-language-server
              cabal-install
            ];

          # Add build inputs of the following derivations.
          inputsFrom = [ ];

          # Enables Hoogle for the builtin packages.
          withHoogle = true;
        };
      }
    );
}
