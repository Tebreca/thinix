{
  pkgs,
  crossPkgs,
    opts ? {
        packages = [];
        username = "thinix-user";
        hostname ="thinix-client";
      }
}:
let
inherit (pkgs) lib;
inherit (opts) packages username hostname;
inittab = builtins.toFile "inittab" ''
tty1::respawn:/bin/login -f ${username}
::sysinit:/bin/hostname -F etc/hostname
::sysinit:mount -a
::sysinit:/bin/chown ${username} home/${username}
'';
fstab = builtins.toFile "fstab" ''
devtmpfs /dev devtmpfs mode=0755,nosuid 0 0
'';
path = builtins.toFile "environment" "PATH=/bin";
group = builtins.toFile "group" ''
root:x:0:
tty:x:5:${username}
${username}:x:1030:
'';
passwd = builtins.toFile "passwd" ''
root:x:0.0:root:/root:/bin/sh
${username}:x:1030:1030:/home/${username}:/bin/sh
'';
shadow = builtins.toFile "shadow" ''
${username}::20005::::::
root::20005::::::
'';
host = builtins.toFile "hostname" "${hostname}";
shellprofile = builtins.toFile ".profile" ''
PS1='[\[\e[32m\]\u@\h \W\[\e[0m\]]\$ '

alias ls="ls --color=auto"
alias l="ls -l -A"
'';
busybox = pkgs.callPackage ../busybox {inherit pkgs crossPkgs;};

init = builtins.toFile "init" ''
#!/bin/sh
chmod +s su
/bin/init
'';
base = ./devices.cpio;
in
pkgs.stdenv.mkDerivation {
  name="ramdisk";

  buildInputs = with pkgs; [
    cpio
  ];
# for now a simple setup, configurable later
  unpackPhase = ''
    mkdir -p etc dev root bin home/${username}
    cd bin
    cp ${busybox}/busybox ./busybox
    ./busybox --list | xargs -n1 ln -s ./busybox
    cd ..
    cp ${host} ./etc/hostname
    cp ${inittab} ./etc/inittab
    cp ${fstab} ./etc/fstab
    cp ${path} ./etc/environment
    cp ${passwd} ./etc/passwd
    cp ${shadow} ./etc/shadow
    cp ${shellprofile} ./home/${username}/.profile
    cp ${init} ./init
    chmod +x init;
    cp ${base} ./init.cpio
    '';
  
  buildPhase = ''
    find . | cpio -o -A -H newc --owner=+0:+0 -F ./init.cpio
    '';

  installPhase = ''
    mkdir -p $out
    cp ./init.cpio $out/
  '';
}
