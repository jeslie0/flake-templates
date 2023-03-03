{
  description = "Basic elm flake with dev shell.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
    mkElmDerivation.url = github:jeslie0/mkElmDerivation;
  };

  outputs = { self, nixpkgs, mkElmDerivation, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        elmPackages = pkgs.elmPackages;
      in
        {
          packages.default = mkElmDerivation.mkElmDerivation {
            pname = throw "Enter package name";
            version = "0.1.0";
            src = ./.;
            nixpkgs = pkgs;
          };

          devShell = pkgs.mkShell {
            packages = with pkgs; with pkgs.elmPackages;
              [ elm-language-server
                elm-format
                elm-live
              ];
            inputsFrom = [ self.packages.${system}.default ];
          };
        }
    );
}
