{
  description = "A very basic flake template";

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
              default = pkgs.cowsay;
            }
        );

        devShell = forAllSystems (system:
          let pkgs = nixpkgsFor.${system};
          in
            pkgs.mkShell {
              inputsFrom = [ ]; # Include build inputs from packages in
              # this list
              packages = [ ]; # Extra packages to go in the shell
            }
        );
      };
}
