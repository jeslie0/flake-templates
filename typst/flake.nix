{
  description = "A basic flake to build a typst project, with an lsp server.";

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

      pname = throw "Set project name";

      version = throw "Set project version";
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
              default = pkgs.stdenvNoCC.mkDerivation {
                inherit pname version;

                src =
                  ./.;

                nativeBuildInputs = [
                  (pkgs.typst.withPackages (p: []))
                ];

                buildPhase = "typst compile src/main.typ";

                installPhase = "mkdir -p $out; cp src/main.pdf $out/${pname}.pdf";
              };
            }
        );

        devShell = forAllSystems (system:
          let pkgs = nixpkgsFor.${system};
          in
            pkgs.mkShell {
              inputsFrom = [
                self.packages.${system}.default
              ]; # Include build inputs from packages in
              # this list
              packages = [
                pkgs.tinymist # This is a typst lsp
              ]; # Extra packages to go in the shell
            }
        );
      };
}
