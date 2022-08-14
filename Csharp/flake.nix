{
  description = "A very basic C# flake template, providing a devshell.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        dependencies = with pkgs; [ mono ]; # Input the build dependencies here
        packageName = throw "InsertPackageName";
      in
        {
          packages.exe = pkgs.stdenv.mkDerivation {
            name = "exe";
            src = ./src;
            buildInputs = dependencies;
            buildPhase = ''
                         chmod +x main.cs
                         mcs main.cs -out:exe
                         '';
            installPhase = ''
                           mkdir -p $out/bin
                           cp exe $out/bin
                           '';
          };

          packages.${packageName} = pkgs.stdenv.mkDerivation {
            pname = packageName;
            version = "0.0.1";
            src = ./.;
            inputsFrom = [ self.packages.${system}.exe ];
            buildInputs = [ pkgs.makeWrapper self.packages.${system}.exe ];
            buildPhase = ''
                         mkdir -p $out/bin
                         echo "#!/usr/bin/env sh
                         ${pkgs.mono}/bin/mono ${self.packages.${system}.exe}/bin/exe" > $out/bin/${packageName}
                         '';
            installPhase = "chmod +x $out/bin/${packageName}";
            postInstall = ''
                          wrapProgram $out/bin/${packageName} \
                          --prefix PATH : ${pkgs.lib.getBin pkgs.mono}/bin \
                                           ${pkgs.lib.getBin self.packages.${system}.exe}/bin
                            '';
          };

          defaultPackage = self.packages.${system}.${packageName};

          devShell = pkgs.mkShell {
            buildInputs = with pkgs;
              dependencies ++ [
                omnisharp-roslyn
                msbuild
                dotnet-sdk
              ];
          };
        }
    );
  }
