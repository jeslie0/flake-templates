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

      cpp-wasm = {
        path = ./Cpp/wasm;
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
        description = (import ./Haskell/Haskell/flake.nix).description;
      };

      haskell2flake = {
        path = ./Haskell/Haskell2Flake;
        description = "Add a flake.nix to an existing Haskell project.";
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
        description = "A very basic PureScript dev-shell";
      };

      python = {
        path = ./Python;
        description = "A very basic Python project, with a devshell.";
      };

      rust = {
        path = ./rust;
        description = (import ./rust/flake.nix).description;

      };
    };
  };
}
