{
  pkgs, 
  opts,
  initRD
}:
let
 inherit (pkgs) stdenv;
 configFile = ./.config;
in
stdenv.mkDerivation {
  name = "thinix-linux-kernel-custom";
  src = opts.source;
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
    stdenv.cc.libc.static
  ];
  
  configurePhase = ''
    cp ${configFile} ./.config
    cp ${initRD}/init.cpio ./init.cpio
  '';

  buildPhase = ''
    make V=1
  '';

  installPhase = ''
    mkdir -p $out
    cp ./arch/x86/boot/bzImage $out/
  '';
}
