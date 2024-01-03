{
  description = "A flake for building PureScript projects.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    ps-overlay.url = "github:thomashoneyman/purescript-overlay";
    mkSpagoDerivation.url = "github:jeslie0/mkSpagoDerivation";
  };

  outputs = { self, nixpkgs, flake-utils, ps-overlay, mkSpagoDerivation, easy-purescript-nix }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ ps-overlay.overlays.default
                       mkSpagoDerivation.overlays.default
                     ];
        };
        dependencies = with pkgs;
          [ purs-unstable
            spago-unstable
            purs-backend-es
            esbuild
          ];
      in
        {
          packages.default = pkgs.mkSpagoDerivation {
            version = "0.1.0";
            src = ./.;
            nativeBuildInputs = [ pkgs.esbuild pkgs.purs-backend-es ];
            buildPhase = "spago build && purs-backend-es bundle-app --no-build --minify --to=main.min.js";
            installPhase = "mkdir $out; cp -r main.min.js $out";
          };

          devShell = pkgs.mkShell {
            inputsFrom = [
              # self.packages.${system}.default
            ]; # Include build inputs from packages in
            # this list
            packages = with pkgs;
              [ purescript-language-server
                watchexec
                purs-tidy
                nodePackages.live-server
              ] ++ dependencies; # Extra packages to go in the shell
          };
        }
    );
}
