{
  pkgs, 
    opts ? {} 
}:
let
 inherit pkgs.lib;
in
pkgs.linuxPackages_custom_tinyconfig_kernel.override {
  structuredExtraConfig = with lib.kernel; {
    64BIT = yes; # let's test this
  };
} // (opts.overrides or {});
