{
  description = "A very basic C flake template, providing a devshell.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        dependencies = with pkgs; [  ]; # Input the build dependencies here
        packageName = throw "Insert Name Here";
      in
        {
          packages.${packageName} = pkgs.stdenv.mkDerivation {
            pname = packageName;
            version = "0.0.1";
            src = ./src;
            buildInputs = dependencies;
            buildPhase = "gcc main.c -o ${packageName}";
            installPhase = ''
                         mkdir -p $out/bin
                         cp ${packageName} $out/bin
                         '';
          };

          defaultPackage = self.packages.${system}.${packageName};

          devShell = pkgs.mkShell {
            inputsFrom = [ self.packages.${system}.${packageName}
                         ];
            buildInputs = with pkgs;
              [ clang-tools
              ];
          };
        }
    );
}
