{
  pkgs, 
    opts ? {
      overrides = {};
      } 
}:
let
 inherit (pkgs) lib;
in
pkgs.linuxPackages_custom_tinyconfig_kernel.override (opts.overrides)
