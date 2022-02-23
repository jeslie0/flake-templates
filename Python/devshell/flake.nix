{
  description = "A very basic python flake template, providing a devshell.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pyPkgs = pkgs.python39Packages;
        customPython = pkgs.python39.buildEnv.override {
          extraLibs = with pyPkgs; [ ipython
                                     # Other dependencies here
                                   ]; };
      in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs;
              [
                python-language-server
                customPython
              ];
          };
        }
    );
        }
