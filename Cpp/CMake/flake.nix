{
  description = "A very basic C++ flake template, using CMake, providing a devshell.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems =
        [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];

      forAllSystems =
        nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ ];
        });

      rootCMakeFile =
        builtins.readFile ./CMakeLists.txt;

      pname = with builtins;
        head (match "^.*project\\([[:space:]]*([A-Za-z0-9_]+).*$" rootCMakeFile);

      version = with builtins;
        head (match "^.*[[:space:]]+VERSION[[:space:]]+([0-9_\.]+).*$" rootCMakeFile);
    in
      {
        overlays = {};

        checks = forAllSystems (system:
          let pkgs = nixpkgsFor.${system};
          in
            {}
        );

        packages = forAllSystems (system:
          let pkgs = nixpkgsFor.${system};
          in
            {
              default = pkgs.stdenv.mkDerivation {
                inherit pname version;
                src = ./.;
                # dontUseCmakeConfigure=true;
                buildInputs = [
                  pkgs.cmake
                ];
                buildPhase = ''
                         make
                         '';
                installPhase = ''
                         mkdir -p $out/bin
                         cp ${pname} $out/bin
                         '';
              };
            });

        devShell = forAllSystems (system:
          let pkgs = nixpkgsFor.${system};
          in
            pkgs.mkShell {
              inputsFrom = [
                self.outputs.packages.${system}.default
              ]; # Include build inputs from packages in
              # this list
              packages = [
                pkgs.clang-tools
                pkgs.clang
                pkgs.cmake-language-server
              ]; # Extra packages to go in the shell
            }
        );
      };
}
