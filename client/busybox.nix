{pkgs}:
let
inherit (pkgs) stdenv;
src = fetchTarball {
  url="https://git.busybox.net/busybox/snapshot/busybox-1_37_0.tar.bz2";
};
cc-chain = stdenv.mkDerivation {
  name = "i586-cc-chain";
  src = fetchGit {
    url = "https://github.com/dvdfreitag/I586-Cross.git";
    rev = "34fca92e31e1f8f5fc54fe53038ed48e15714fb6";
  };

  buildPhase = "";
  
  installPhase = ''
  mkdir -p $out;
  cp -r ./cross/* $out/
  '';

};
in
stdenv.mkDerivation {
  name="busybox-thinix";
  inherit src;
  
  buildInputs = [
    cc-chain
    pkgs.gnumake
  ];

  configurePhase = ''
    make defconfig
  '';

  buildPhase = ''
    make CROSS_COMPILE=i586-elf-
  '';
}
