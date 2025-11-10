{
  lib,
  stdenv,
  ...
}: stdenv.mkDerivation (finalAttrs: {
  pname = "konduit-landing";
  version = "0.1.0";

  src = lib.sourceByRegex ../. [
    "^index\\.html$"
    "^background\\.png$"
  ];

  installPhase = ''
    cp -r $src $out/
  '';

  meta = {
    description = "Konduit landing page. Konduit is a Cardano to Bitcoin Lightning Network pipe.";
  };
})
