{
  description = "A derivation and flake for building an elm package.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
    mkElmDerivation.url = github:jeslie0/mkElmDerivation;
  };

  outputs = { self, nixpkgs, mkElmDerivation, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          overlays = [ mkElmDerivation.overlay ];
          inherit system;
        };
        elmPackageName = throw "Enter elm package name";
      in
        {
          packages.default = pkgs.mkElmDerivation {
            pname = elmPackageName;
            version = "0.1.0";
            src = ./.;
          };

          devShell = pkgs.mkShell {
            inputsFrom = [ self.packages.${system}.default ];
            packages = with pkgs;
              [ elmPackages.elm-language-server
                elmPackages.elm-live
              ];
          };
        }
    );
}
