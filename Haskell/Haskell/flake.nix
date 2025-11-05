{
  description = "A haskell project built on haskell.nix, providing a dev shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    haskell-nix = { url = "github:input-output-hk/haskell.nix"; };
  };

  outputs = { self, nixpkgs, haskell-nix }:
    let
      supportedSystems =
        [ "aarch64-linux" "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          # Might want to use an overlay but this can cause ghc to be rebuilt.
          # overlays = [ haskell-nix.overlay ];
        });

      ghcVersion = "ghc9122";

      project = forAllSystems (system:
        haskell-nix.legacyPackages.${system}.haskell-nix.project' {
          compiler-nix-name = ghcVersion;
          src = ./.;
          modules = [ ];
        });

      flake = system: project.${system}.flake { };

    in {
      overlays = { };

      checks = forAllSystems (system: let pkgs = nixpkgsFor.${system}; in { });

      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};

          flakePkgs = (flake system).packages;
        in {
          default = pkgs.hello;
        }
        #// (flakePkgs system)
      );

      devShell = forAllSystems (system:
        let
          initShell = nixpkgsFor.${system}.mkShell {
            packages =
              [ nixpkgsFor.${system}.cabal-install nixpkgsFor.${system}.ghc ];
          };

          hls-wrapper = nixpkgsFor.${system}.writeScriptBin
            "haskell-language-server-wrapper" ''
              #!${nixpkgsFor.${system}.stdenv.shell}
              ${
                haskell-nix.legacyPackages.${system}.haskell-nix.tool ghcVersion
                "haskell-language-server" "latest"
              }/bin/haskell-language-server "$@"
            '';

          projectShell = project.${system}.shellFor {
            withHoogle = true;
            inputsFrom = [ ];
            buildInputs = [ hls-wrapper ];
            tools = {
              haskell-language-server = { };
              cabal = { };
            };
          };
        in initShell);
    };
}
