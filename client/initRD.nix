{
  pkgs,
    opts ? {}
}:
let
inherit pkgs.lib;
packages = opts.packages ? with pkgs;[

];
username = opts.username ? "user";
host = opts.hostname = "thinix-client";
inittab = builtins.toFile ''
tty1::respawn:/bin/login -f ${username}
::sysinit:/bin/hostname ${host}
::sysinit:mount -a
::sysinit:/bin/chown c /home/c
'';
fstab = builtins.toFile ''
devtmpfs /dev devtmpfs mode=0755,nosuid 0 0
'';
path = builtins.toFile "PATH=/bin";
group = builtins.toFile ''
root:x:0:
tty:x:5:${username}
${username}::1030:
'';
shellprofile = ''
PS1='[\[\e[32m\]\u@\h \W\[\e[0m\]]\$ '

alias ls="ls --color=auto"
alias l="ls -l -A"
'';
in
pkgs.stdenv.mkDerivation {
  name="ramdisk";

# for now a simple setup, configurable later
  setupPhase = ''
    mkdir etc dev root home/${username}
    cp  ${pkgs.busybox}/bin ./
    cp ${inittab} ./etc/inittab
    cp ${fstab} ./etc/fstab
    cp ${path} ./etc/path
    cp ${shellprofile} ./home/${username}/.profile
    '';
  
  buildPhase = ''
    cd initfiles
    find . | cpio -o -H newc --owner=+0:+0 > ../init.cpio
    '';
}
