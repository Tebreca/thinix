{}:
let
pkgs = import <nixpkgs> {
  crossSystem = {
    config = "i686-unknown-linux-gnu";
  };
};
inherit (pkgs) stdenv;

src = fetchTarball {
  url="https://git.busybox.net/busybox/snapshot/busybox-1_37_0.tar.bz2";
  sha256="13vzf3y60p4rf63ckal9d8bi4iwsv5dgkzm0ga30q2jjbs55lpid";
};
config = ./.config;
in
stdenv.mkDerivation {
  name="busybox-thinix";
  inherit src;

  buildInputs = with pkgs; 
  [
    stdenv.cc.libc.static
    glibc
  ];

  configurePhase = ''
    cp ${config} ./.config
  '';

  buildPhase = ''
    export CROSS_COMPILE= ''${CC%gcc}
    LD_FLAGS="--static" make
  '';
  installPhase = ''
    mkdir -p $out
    chmod +x busybox
    cp ./busybox $out
  '';

}
