{ pkgs
, ghcVersion
, packageName
, ...
}:
let
  crossArmv7l =
    pkgs.pkgsCross.armv7l-hf-multiplatform.haskell.packages.${ghcVersion}.callCabal2nix (packageName) ./.. {};

  crossArmv7lMusl =
    pkgs.pkgsCross.armv7l-hf-multiplatform.pkgsMusl.haskell.packages.${ghcVersion}.callCabal2nix (packageName) ./.. {};

  crossArmv7lStatic =
    pkgs.pkgsCross.armv7l-hf-multiplatform.pkgsStatic.haskell.packages.${ghcVersion}.callCabal2nix (packageName) ./.. {};
in
{
  inherit crossArmv7l crossArmv7lStatic crossArmv7lMusl;
}
