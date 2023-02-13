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
            src = ./.;
            nixpkgs = pkgs;
          };

          devShell = pkgs.mkShell {
            packages = with pkgs; with pkgs.elmPackages;
              [ elm-language-server
                elm-format
              ];
            inputsFrom = [ self.packages.${system}.default ];
          };
        }
    );
}
