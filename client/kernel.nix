{
  pkgs, 
  opts 
}:
let
 inherit (pkgs) stdenv;
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
    cp ${opts.configFile} ./.config
  '';

  installPhase = ''
    cp ./arch/x86/boot/bzImage $out
  '';
}
