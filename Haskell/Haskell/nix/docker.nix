{ pkgs
, packageName
, system
, ...
}:
raspExe: {
  dockerImage = pkgs.dockerTools.buildImage {
    name =
      packageName;

    tag =
      "latest";

    architecture =
      "arm";

    config = {
      Cmd =
        [ "${raspExe}/bin/XCompile"];
    };
  };
}
