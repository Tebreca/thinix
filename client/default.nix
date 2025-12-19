{pkgs, lib, config, ...}:
let
cfg = config.client;
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
    overrides = {
      kernelPatches = cfg.kernel.patches;
      config = (readConfig ./.config) // cfg.kernel.config;
    };
  };
};
initRD = pkgs.callPackage ./initRD.nix {
  inherit pkgs;
  opts = {
    inherit (cfg) username hostname packages;
  };
};
tftp-root = pkgs.stdenv.mkDerivation {

  name="thinix-tftp-root";

  unpackPhase = ''
  cp ${kernel}/bzImage ./
  cp ${initRD}/init.cpio ./
  '';

  installPhase = ''
  mkdir -p $out
  cp ./* $out/
  '';
};
inherit (lib) mkOption;
in
{
  options.client = {
    kernel = {
      patches = mkOption {
        default = [];
      };
      config = mkOption {
        default = with lib.kernel; {
            
        };
      };
    };
    packages = mkOption {
      default = with pkgs; [
        busybox
      ];
    };
    username = mkOption {
      default = "thinix-user";
    };
    hostname = mkOption {
      default = "thinix-client";
    };
  };

  config = {
    server.serving-root="${tftp-root}";
  };

}
