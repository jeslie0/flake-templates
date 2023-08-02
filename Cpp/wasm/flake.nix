{
  description = "A very basic C++ flake template, using CMake to compile to wasm, providing a devshell.";

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
          packageName = with builtins;
            head (match "^.*PROJECT\\(([^\ ]+).*$" (readFile ./CMakeLists.txt));
          version' = with builtins;
             head (match "^.*PROJECT\\(${packageName}.*VERSION\ ([^\)]+).*$" (readFile ./CMakeLists.txt));
      in
        {
          packages.${packageName} = pkgs.buildEmscriptenPackage rec {
            pname = packageName;
            version = version';
            src = ./.;
            dontUseCmakeConfigure=true;
            buildInputs = dependencies;
            configurePhase = ''
                             runHook preConfigure
                             HOME=$TMPDIR
                             mkdir -p .emscriptencache
                             export EM_CACHE=$(pwd)/.emscriptencache
                             runHook postConfigure
                           '';
            buildPhase = ''
                         emcmake cmake -Bbuild -DUSE_LOCAL_PACKAGES=true;
                         cd build;
                         make
                         '';
            installPhase = ''
                         mkdir -p $out
                         cd src
                         cp ${packageName}.* $out
                         '';
            checkPhase = "";
          };

          defaultPackage = self.packages.${system}.${packageName};

          devShell = pkgs.mkShell {
            inputsFrom = [ self.packages.${system}.${packageName}
                         ];
            packages = with pkgs;
              [ clang-tools
              ];
          };
        }
    );
}
