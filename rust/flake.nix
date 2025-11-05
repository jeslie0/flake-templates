{
  description =
    "A very basic flake providing a rust dev shell.";

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

      cargoFile = builtins.fromTOML "./Cargo.toml";
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
              default = pkgs.rustPlatform.buildRustPackage (finalAttrs: {
                pname = cargoFile.package.name;
                version = cargoFile.package.version;
                src = ./.;
                cargoHash = "";
              });
            }
        );

        devShell = forAllSystems (system:
          let pkgs = nixpkgsFor.${system};
          in
            pkgs.mkShell {
              inputsFrom = [ ]; # Include build inputs from packages in
              # this list
              packages = [
                pkgs.cargo
                pkgs.rustc
                pkgs.rust-analyzer
              ]; # Extra packages to go in the shell
            }
        );
      };
}
