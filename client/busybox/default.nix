{pkgs, crossPkgs}:
let
inherit (crossPkgs) stdenv;
src = fetchTarball {
  url="https://git.busybox.net/busybox/snapshot/busybox-1_37_0.tar.bz2";
  sha256="13vzf3y60p4rf63ckal9d8bi4iwsv5dgkzm0ga30q2jjbs55lpid";
};
config = ./.config;
in
stdenv.mkDerivation {
  name="busybox-thinix";
  inherit src;

# We are building the linux kernel against the normal libc.static and glibc
  buildInputs = with pkgs; 
  [
    stdenv.cc.libc.static
    glibc
  ];

  nativeBuildInputs = with pkgs;
  [
    gcc
  ];

  configurePhase = ''
    cp ${config} ./.config
  '';

  buildPhase = ''
    LD_FLAGS="--static" make V=1 CROSS_COMPILE="''${CC%gcc}"
  '';
  installPhase = ''
    mkdir -p $out
    chmod +x busybox
    cp ./busybox $out
  '';

}
