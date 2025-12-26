{
  pkgs,
    opts ? {
        packages = [];
        username = "thinix-user";
        hostname ="thinix-client";
      }
}:
let
inherit (pkgs) lib;
packages = opts.packages;
username = opts.username;
host = opts.hostname;
inittab = builtins.toFile "inittab" ''
tty1::respawn:/bin/login -f ${username}
::sysinit:/bin/hostname ${host}
::sysinit:mount -a
::sysinit:/bin/chown c /home/c
'';
fstab = builtins.toFile "fstab" ''
devtmpfs /dev devtmpfs mode=0755,nosuid 0 0
'';
path = builtins.toFile "path" "PATH=/bin";
group = builtins.toFile "group" ''
root:x:0:
tty:x:5:${username}
${username}::1030:
'';
shellprofile = builtins.toFile ".profile" ''
PS1='[\[\e[32m\]\u@\h \W\[\e[0m\]]\$ '

alias ls="ls --color=auto"
alias l="ls -l -A"
'';
busybox = pkgs.callPackage ./busybox.nix {
  inherit (pkgs) stdenv;
};
in
pkgs.stdenv.mkDerivation {
  name="ramdisk";

  buildInputs = with pkgs; [
    cpio
  ];
# for now a simple setup, configurable later
  unpackPhase = ''
    mkdir -p etc dev root home/${username}
    cp -r ${pkgs.crossPkgs.i686-embedded.busybox}/bin ./
    cp ${inittab} ./etc/inittab
    cp ${fstab} ./etc/fstab
    cp ${path} ./etc/path
    cp ${shellprofile} ./home/${username}/.profile
    '';
  
  buildPhase = ''
    find . | cpio -o -H newc --owner=+0:+0 > ./init.cpio
    '';

  installPhase = ''
    mkdir -p $out
    cp ./init.cpio $out/
  '';
}
