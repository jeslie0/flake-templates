{
  description = "James's flake templates";

  outputs = { self, ... }: {
    templates = {
      haskell-template = {
        path = ./Haskell;
        description = "Flake template for a general Haskell project";
      };
    };
  };
}
