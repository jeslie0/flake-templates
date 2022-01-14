{
  description = "James's flake templates";

  outputs = { self, ... }: {
    templates = {
      haskell-new-template = {
        path = ./Haskell/HaskellNew;
        description = "Flake template for a general Haskell project";
      };

      haskell2flake-template = {
        path = ./Haskell/Haskell2Flake;
        description = "Add a flake.nix to an existing Haskell project";
      };
    };
  };
}
