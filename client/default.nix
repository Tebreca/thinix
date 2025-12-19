{pkgs, lib, config, ...}:
let
cfg = config.client;
kernel = pkgs.callPackage ./kernel.nix {
  inherit pkgs;
  opts = {
    overrides = {
      kernelPatches = cfg.kernel.patches;
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
  name="tftp-root";
  buildPhase = ''
  cp ${kernel}/bzImage ./
  cp ${initRD}/init.cpio ./
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
