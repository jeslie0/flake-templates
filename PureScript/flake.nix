{
  description = "A flake for building PureScript projects.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    ps-overlay.url = "github:thomashoneyman/purescript-overlay";
    mkSpagoDerivation.url = "github:jeslie0/mkSpagoDerivation";
  };

  outputs = { self, nixpkgs, ps-overlay, mkSpagoDerivation, }:
    let
      supportedSystems =
        [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];

      forAllSystems =
        nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          overlays = [ ps-overlay.overlays.default
                       mkSpagoDerivation.overlays.default
                     ];
        });

      dependencies =
        system:
        with nixpkgsFor.${system};
        [ purs-unstable
          spago-unstable
          purs-backend-es
          esbuild
        ];

        packageJson =
          builtins.fromJSON (builtins.readFile ./package.json);

        devDeps = system:
          nixpkgsFor.${system}.buildNpmPackage {
            name =
              packageJson.name;

            src =
              nixpkgsFor.${system}.lib.sources.cleanSourceWith {
                src =
                  ./.;

                filter =
                  path: type: builtins.baseNameOf path == "package.json" ||builtins.baseNameOf path == "package-lock.json";
              };


            dontNpmBuild =
              true;

            npmDepsHash =
              "sha256-AOuluSr60Q0Ru6SmKJA1hJ8s9sdSBC9l2Yp2Z39gH1I=";
          };
      in
        {
          packages =
            forAllSystems (system:
              let
                pkgs =
                  nixpkgsFor.${system};

                packageName =
                  (pkgs.fromYAML
                    (builtins.readFile "${./.}/spago.yaml")).package.name;
              in
                {
                  default =
                    pkgs.mkSpagoDerivation {
                      pname =
                        packageName;

                      version =
                        "0.1.0";

                      src =
                        ./.;

                      nativeBuildInputs =
                        [ pkgs.esbuild pkgs.purs-backend-es ];

                      buildPhase =
                        "spago build && purs-backend-es bundle-app --no-build --minify --to=main.min.js";

                      installPhase =
                        "mkdir $out; cp -r main.min.js $out";
                    };
              }
            );

          devShell =
            forAllSystems (system:
              let
                pkgs =
                  nixpkgsFor.${system};
              in
                pkgs.mkShell {
                  inputsFrom = [
                    # self.packages.${system}.default
                  ]; # Include build inputs from packages in
                  # this list

                  shellHook = ''
                    echo "Run the following command to get the development dependencies in place using nix:

ln -s ${devDeps system}/lib/node_modules/${packageJson.name}/node_modules $(git rev-parse --show-toplevel)/node_modules

Then run \"npm start\" to start the development server.
Run \"spago init\" then uncomment the default package from the shell inputs.
Make sure \"dist\" and \".parcel-cache\" are added to the .gitignore file."
                  '';

                  packages = with pkgs;
                    [ purescript-language-server
                      purs-tidy
                      nodejs
                    ] ++ (dependencies system); # Extra packages to go in the shell
                }
            );
        };
}
