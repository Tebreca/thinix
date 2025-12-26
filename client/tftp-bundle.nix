{lib, pkgs, cfg, ...}:
let
readConfig =
  configfile:
  let
    matchLine =
      line:
      let
        match = lib.match "(CONFIG_[^=]+)=([ym])" line;
      in
      lib.optional (match != null) {
        name = lib.elemAt match 0;
        value = lib.elemAt match 1;
      };
  in
  lib.listToAttrs (lib.concatMap matchLine (lib.splitString "\n" (builtins.readFile configfile)));
kernel = pkgs.callPackage ./kernel.nix {
  inherit pkgs;
  opts = {
    source = cfg.kernel.source;
     configFile = (cfg.kernel.configFile or ./.config);
  };
};

initRD = pkgs.callPackage ./initRD.nix {
  inherit pkgs;
  opts = {
    inherit (cfg) username hostname packages;
  };
};


in
pkgs.stdenv.mkDerivation {

  name="thinix-tftp-root";

  unpackPhase = ''
    cp ${kernel}/bzImage ./
    cp ${initRD}/init.cpio ./
    '';

  installPhase = ''
    mkdir -p $out
    cp ./* $out/
          '';
}
