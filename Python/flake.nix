{
  description = "A very basic python flake template, providing a devshell.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pyPkgs = pkgs.python39Packages;
        customPython = pkgs.python39.buildEnv.override {
          extraLibs = with pyPkgs; [
            ipython
            # Other python dependencies here
          ];
        };
        packageName = throw "InsertPackageName";
      in
      {
        packages.${packageName} = pkgs.stdenv.mkDerivation {
          pname = packageName;
          version = "0.1.0";
          src = ./src;
          buildInputs = [ customPython ];
          buildPhase = "chmod +x main.py";
          installPhase = ''
            mkdir -p $out/bin
            cp main.py $out/bin/${packageName}
          '';
        };

        defaultPackage = self.packages.${system}.${packageName};

        devShell = pkgs.mkShell {
          packages = with pkgs;
            [ python310Packages.python-lsp-server ];
          buildInputs = with pkgs;
            [ customPython ];
        };
      }
    );
}
