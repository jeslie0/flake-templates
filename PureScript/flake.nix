{
  description = "A flake for building PureScript projects.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    ps-overlay.url = "github:thomashoneyman/purescript-overlay";
    mkSpagoDerivation.url = "github:jeslie0/mkSpagoDerivation";
    easy-purescript-nix = {
      url = "github:justinwoo/easy-purescript-nix";
    };
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
        easy-ps = easy-purescript-nix.packages.${system};
        dependencies = with pkgs;
          [ easy-ps.purs
            spago-unstable
            purs-backend-es
            esbuild
          ];
      in
        {
          packages.default = pkgs.mkSpagoDerivation {
            version = "0.1.0";
            src = ./.;
          };

            devShell = pkgs.mkShell {
              inputsFrom = [  ]; # Include build inputs from packages in
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
