{lib, pkgs, cfg, ...}:
let
kernel = pkgs.callPackage ./kernel.nix {
  inherit pkgs;
  opts = {
    source = cfg.kernel.source;
    configFile = (cfg.kernel.configFile or ./.config);
  };
  initRD = pkgs.callPackage ./initRD.nix {
    inherit pkgs;
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
