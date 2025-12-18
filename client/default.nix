{pkgs, lib, config, ...}:
let
cfg = config.client;
kernel = pkgs.callPackage ./kernel.nix {
  pkgs,
  {
    overrides = {
      kernelPatches = cfg.kernel.patches;
    };
  }
};
initRD = pkgs.callPackage ./intitRD.nix {
  pkgs,
  {
    include = cfg.packages;
  }
};
tftp-root = pkgs.stdEnv.mkDerivation {
  buildPhase = ''
  cp ${kernel}/bzImage ./
  cp ${initRD}/initramfs ./
  '';
};
inherit (lib) mkOption;
in
{
  options = {
    server.serving-root="${tftp-root}";
  };

  config.client = {
    kernel = {
      patches = mkOption {
        default = [];
      }
    };
    packages = mkOption {
        default = with pkgs; [
        busybox
        ];
    }
  };
}
