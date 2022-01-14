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

          devShell = pkgs.mkShell {
            buildInputs = with haskellPackages;
              [ ghc
                haskell-language-server
                cabal-install
              ];
            inputsFrom = builtins.attrValues self.packages.${system};
          };
        }
    );
}
