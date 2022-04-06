{
  description = "James's flake templates";

  outputs = { self, ... }: {
    templates = {
      haskell-new-template = { path = ./Haskell/HaskellNew;
                               description = "Flake template for a general Haskell project";
                             };

      haskell2flake-template = { path = ./Haskell/Haskell2Flake;
                                 description = "Add a flake.nix to an existing Haskell project";
                               };

      hakyll = { path = ./Hakyll/hakyll-init;
                 description = "A new Hakyll site, generated from hakyll-init";
               };

      python = { path = ./Python;
                 description = "A very basic Python project with a devshell";
            };

      C = { path = ./C;
            description = "A very basic C project, with devshell";
          };

      Csharp = { path = ./Csharp;
                 description = "A very basic C# project, with devshell";
               };
    };
  };
}
