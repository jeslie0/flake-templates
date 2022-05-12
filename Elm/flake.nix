{
  description = "An Elm project development shell flake.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        elmPackages = pkgs.elmPackages;
      in
        {
          devShell = pkgs.mkShell {
            packages = with pkgs; with pkgs.elmPackages;
              [ elm
                elm-language-server
                elm-format
                elm2nix
              ];
          };
        }
    );
}
