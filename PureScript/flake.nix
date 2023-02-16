{
  description = "A development shell for a PureScript project.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        dependencies = with pkgs;
          [ purescript
            spago
            nodejs ];
      in
      {
        devShell = pkgs.mkShell {
          inputsFrom = [ ]; # Include build inputs from packages in
          # this list
          packages = with pkgs;
            [ nodePackages.purescript-language-server
              purescript
              spago
              nodejs
            ]; # Extra packages to go in the shell
        };
      }
    );

}
