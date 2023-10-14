{
  description = "A development shell for a PureScript project.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    spago2nix.url = "github:justinwoo/spago2nix";
    purifix.url = "github:purifix/purifix";
    ps-overlay.url = "github:thomashoneyman/purescript-overlay";
    easy-purescript-nix.url = "github:justinwoo/easy-purescript-nix";
  };

  outputs = { self, nixpkgs, flake-utils, spago2nix, purifix, ps-overlay, easy-purescript-nix }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ purifix.overlay ps-overlay.overlays.default ];
        };
        easy-ps = easy-purescript-nix.packages.${system};
        dependencies = with pkgs;
          [ easy-ps.purescript
            spago-unstable
            # easy-ps.spago
            easy-ps.purs-backend-es
            easy-ps.psa
            easy-ps.zephyr
            esbuild
            watchexec
          ];
        purifx = pkgs.purifix.override {
          buildInputs = [ easy-ps.purs-backend-es pkgs.esbuild ];
        };
      in
        {
          packages.default = pkgs.purifix {
            src = ./.;
          }.overrideAttrs {
            buildInputs = [easy-ps.purs-backend-es];
          };
          devShell = pkgs.mkShell {
            # inputsFrom = [ ]; # Include build inputs from packages in
            # this list
            packages = with pkgs;
              [ easy-ps.purescript-language-server
                easy-ps.purs-tidy
                nodePackages.live-server
              ] ++ dependencies; # Extra packages to go in the shell
          };
        }
    );
}
