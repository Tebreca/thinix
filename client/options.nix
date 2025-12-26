{pkgs, kernel}:
let
lib = pkgs.lib;
inherit (lib) mkOption;
in
{
  kernel = {
    patches = mkOption {
      default = [];
    };
    config = mkOption {
      default = with lib.kernel; {

      };
    };
    source = mkOption {
      default = kernel;
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
  arch = {
    system = mkOption {
      default = "x86_64-linux";
    };
  };
}
