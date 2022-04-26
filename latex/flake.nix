{
  description = "A LuaTex project flake template";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.james-fonts.url = "github:jeslie0/my-fonts-flake";
  inputs.texmf.url = "github:jeslie0/texmf";

  outputs = { self, nixpkgs, flake-utils, james-fonts, texmf }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        myfonts = james-fonts.defaultPackage.${system};
        tex = pkgs.texlive.combine { # Put the packages that we want texlive to use when compiling the PDF in here.
          inherit (pkgs.texlive)
            # scheme-minimal
            # scheme-basic
            # scheme-small
            # scheme-medium
            scheme-full
            latex-bin
            fontspec
            latexmk;
        };
        buildInputs = [ pkgs.coreutils tex myfonts texmf];
        packageName = "test";
      in
        {
          packages.${packageName} = pkgs.stdenvNoCC.mkDerivation {
            pname = packageName;
            version = "0.0.1";
            buildInputs = buildInputs;
            src = ./src;
            phases = [ "unpackPhase" "buildPhase" "installPhase" ];
            buildPhase = ''
                       export PATH="${pkgs.lib.makeBinPath buildInputs}";
                       mkdir -p .cache/texmf-var
                       env TEXMFHOME=${texmf} \
                           TEXMFVAR=.cache/texmf-var \
                           OSFONTDIR=${myfonts}/share/fonts \
                           SOURCE_DATE_EPOCH=${toString self.lastModified} \
                             latexmk -interaction=nonstopmode -pdf -lualatex -bibtex\
                             $src/main.tex
                         '';
            installPhase = ''
                           mkdir -p $out
                           cp main.pdf $out/${packageName}.pdf
                           '';
          };

          defaultPackage = self.packages.${system}.${packageName};

          devShell = pkgs.mkShell {
            packages = with pkgs; [ texlab ];
            inputsFrom = [ self.packages.${system}.${packageName} ];

          };
        }
    );
}
