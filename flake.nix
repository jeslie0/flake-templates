{
  description = "James's flake templates";

  outputs = { self, ... }: {
    templates = {
      basic = { path = ./basic;
                description = "A very basic flake template.";
              };

      C = { path = ./C;
            description = "A very basic C project, with devshell";
          };

      Cpp = { path = ./Cpp;
              description = "A very basic C++ project, with devshell";
            };

      Csharp = { path = ./Csharp;
                 description = "A very basic C# project, with devshell";
               };

      Elm-shell = { path = ./Elm;
                    description = "A very basic Elm devshell";
                  };

      hakyll = { path = ./Hakyll;
                 description = "A new Hakyll site, generated from hakyll-init";
               };

      haskell-new-template = { path = ./Haskell/HaskellNew;
                               description = "Flake template for a general Haskell project";
                             };

      haskell2flake-template = { path = ./Haskell/Haskell2Flake;
                                 description = "Add a flake.nix to an existing Haskell project";
                               };

      haskellStable = { path = ./Haskell/HaskellStable;
                        description = "Flake template for a general Haskell project, using GHC 8.10.7";
                      };

      javascript = { path = ./javascript;
                     description = "A basic javascript development shell";
                   };

      latex = { path = ./latex;
                description = "A very basic LaTeX project, with a devshell";
              };

      python = { path = ./Python;
                 description = "A very basic Python project, with a devshell";
               };

    };
  };
}
