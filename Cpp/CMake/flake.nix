{
  description = "A very basic C++ flake template, using CMake, providing a devshell.";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let pkgs = nixpkgs.legacyPackages.${system};
          dependencies = with pkgs;
            [ cmake ]; # Input the build dependencies here
          packageName = with builtins; head (match "^.*PROJECT\\(([^\ ]+).*$" (readFile ./CMakeLists.txt));
          version' = with builtins; head (match "^.*PROJECT\\(${packageName}.*VERSION\ ([^\)]+).*$" (readFile ./CMakeLists.txt));
      in
        {
          packages.${packageName} = pkgs.stdenv.mkDerivation rec {
            pname = packageName;
            version = version';
            src = ./.;
            dontUseCmakeConfigure=true;
            buildInputs = dependencies;
            buildPhase = ''
                         cmake . -B build -DUSE_LOCAL_PACKAGES=true;
                         cd build;
                         make
                         '';
            installPhase = ''
                         mkdir -p $out/bin
                         cd src
                         cp ${packageName} $out/bin
                         '';
          };

          defaultPackage = self.packages.${system}.${packageName};

          devShell = pkgs.mkShell {
            inputsFrom = [ self.packages.${system}.${packageName}
                         ];
            packages = with pkgs;
              [ clang-tools
                cmake
              ];
          };
        }
    );
}
