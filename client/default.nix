{lib, config, pkgs, ...}:
let 
  cfg = config.client;
  lnx = stdenv.mkDerivation {
    name = "linux-kernel";

    buildInputs = with pkgs; [
      gnumake
      ncurses
      flex
      bison
      gawk
      bc
      elfutils
      pkg-config
      glibc
      stenv.cc.libc.static
    ];

    src = cfg.linux;
    
    buildPhase = ''

    '';

    installPhase = ''
      

    '';
  }; 
in
{
  options.client = {
    programs = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      example = "with pkgs; [ curl git ];";
      description = "packages to install as programs on the RAM Filesystem";
    };
    linux = lib.mkOption {
      default = builtins.fetchGit {
        url = "https://github.com/torvalds/linux.git";
      };
      description = "The source for the linux kernel to build";
    }
  };

  

}
