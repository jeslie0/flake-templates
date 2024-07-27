{ pkgs
, ghcVersion
, packageName
, ...
}:
let
  crossRaspberryPi =
    pkgs.pkgsCross.raspberryPi.haskell.packages.${ghcVersion}.callCabal2nix packageName ./.. {};

  crossRaspberryPiMusl =
    pkgs.pkgsCross.raspberryPi.pkgsMusl.haskell.packages.${ghcVersion}.callCabal2nix packageName ./.. {};

  crossRaspberryPiStatic =
    pkgs.pkgsCross.raspberryPi.pkgsStatic.haskell.packages.${ghcVersion}.callCabal2nix packageName ./.. {};
in
{
  inherit crossRaspberryPi crossRaspberryPiMusl crossRaspberryPiStatic;
}
