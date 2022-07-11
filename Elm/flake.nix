{
  description = "My Elm Project";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        elmPackages = pkgs.elmPackages;
        packageName = throw "Enter Package Name Here";
      in
        {
          packages.${packageName} = (import ./default.nix) { nixpkgs = pkgs; config = {}; };

          defaultPackage = self.packages.${system}.${packageName};

          devShell = pkgs.mkShell {
            packages = with pkgs; with pkgs.elmPackages;
              [ elm-language-server
                elm-format
                elm2nix
              ];
            inputsFrom = [ self.packages.${system}.${packageName} ];
          };
        }
    );
}
