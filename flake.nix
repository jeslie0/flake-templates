{
  description = "James's flake templates";

  outputs = { self, ... }: {
    templates = {
      basic = {
        path = ./basic;
        description = "A very basic flake template.";
      };

      c = {
        path = ./C;
        description = "A very basic C project, with devshell.";
      };

      cpp-basic = {
        path = ./Cpp/basic;
        description = "A very basic C++ project, with devshell.";
      };

      cpp-cmake = {
        path = ./Cpp/CMake;
        description = "A very basic C++ project using CMake, with a devshell.";
      };

      csharp = {
        path = ./Csharp;
        description = "A very basic C# project, with devshell.";
      };

      elm-shell = {
        path = ./Elm;
        description = "A very basic Elm devshell.";
      };

      hakyll = {
        path = ./Hakyll;
        description = "A new Hakyll site, generated from hakyll-init.";
      };

      haskell = {
        path = ./Haskell/Haskell;
        description = "Flake template for a general Haskell and Cabal project.";
      };

      haskell2flake = {
        path = ./Haskell/Haskell2Flake;
        description = "Add a flake.nix to an existing Haskell project.";
      };

      haskell8-10-7 = {
        path = ./Haskell/Haskell8-10-7;
        description = "Flake template for a general Haskell project, using GHC 8.10.7.";
      };

      javascript = {
        path = ./Javascript/basic;
        description = "A basic javascript development shell.";
      };

      latex = {
        path = ./LaTeX;
        description = "A very basic LaTeX project, with a devshell.";
      };

      purescript = {
        path = ./PureScript;
        description = "A very basic PureScript dev-shell"
      }

      python = {
        path = ./Python;
        description = "A very basic Python project, with a devshell.";
      };

    };
  };
}
