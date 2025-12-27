{pkgs}:
let
inherit (pkgs) stdenv;
src = fetchTarball {
  url="https://git.busybox.net/busybox/snapshot/busybox-1_37_0.tar.bz2";
  sha256="13vzf3y60p4rf63ckal9d8bi4iwsv5dgkzm0ga30q2jjbs55lpid";
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
  cd $out/bin
  chmod +x *
  '';

};
in
stdenv.mkDerivation {
  name="busybox-thinix";
  inherit src;
  
  buildInputs = 
   (with pkgs; [
    stdenv.cc.libc.static
    glibc
  ]) ++ (with pkgs.pkgsCross.gnu32; [
    gnumake
    gcc
    flex
    bison
    gawk
    bc
    elfutils
    pkg-config
  ]);

  configurePhase = ''
    make defconfig
  '';
}
