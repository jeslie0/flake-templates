{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in
        {

          packages.hello = pkgs.hello;

          defaultPackage = self.packages.${system}.hello;

          devShell = pkgs.mkShell {
            inputsFrom = [ ]; # Include build inputs from packages in
            # this list
            packages = [ ]; # Extra packages to go in the shell
          };
      }
    );

}
