{ pkgs
, ghcVersion
, packageName
, ...
}:
let
  crossMingw32 =
    pkgs.pkgsCross.mingw32.haskell.packages.${ghcVersion}.callCabal2nix packageName ./.. {};

  crossMingw64 =
    pkgs.pkgsCross.mingwW64.haskell.packages.${ghcVersion}.callCabal2nix packageName ./.. {};
in
{
  inherit crossMingw32 crossMingw64;
}
