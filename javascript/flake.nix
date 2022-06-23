{
  description = "A javascript development shell";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in
        {

        devShell = with pkgs; mkShell {
          inputsFrom = [];
          buildInputs = [ nodePackages.npm
                          nodejs
                          nodePackages.typescript-language-server
                          nodePackages.typescript
                        ];
          };
        }
    );
}
