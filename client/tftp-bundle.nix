{lib, pkgs, cfg, crossPkgs, ...}:
let
kernel = pkgs.callPackage ./kernel {
  inherit pkgs;
  opts = {
    source = cfg.kernel.source;
    configFile = (cfg.kernel.configFile or ./.config);
  };
  initRD = pkgs.callPackage ./initRD {
    inherit pkgs crossPkgs;
    opts = {
      inherit (cfg) username hostname packages;
    };
  };
};
in
pkgs.stdenv.mkDerivation {

  name="thinix-tftp-root";

  unpackPhase = ''
    cp ${kernel}/bzImage ./
    '';

  installPhase = ''
    mkdir -p $out
    cp ./* $out/
           '';
}
