{ pkgs
, ghcVersion
, packageName
, ...
}:
let
  crossAarch64 =
    pkgs.pkgsCross.aarch64-multiplatform.haskel.packages.${ghcVersion}.callCabal2nix (packageName) ./.. {};

  crossAarch64Musl =
    pkgs.pkgsCross.aarch64-multiplatform.pkgsMusl.haskel.packages.${ghcVersion}.callCabal2nix (packageName) ./.. {};

  crossAarch64Static =
    pkgs.pkgsCross.aarch64-multiplatform.pkgsStatic.haskel.packages.${ghcVersion}.callCabal2nix (packageName) ./.. {};
in
{
  inherit crossAarch64 crossAarch64Musl crossAarch64Static;
}
