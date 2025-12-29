{cfg ? {
  kernel = {
    path = "bzImage";
    opts = [];
  };
  initrd = {
    path = "init.cpio";
    opts = [];
  };
}
}:
let
kernel = cfg.kernel.path;
kernel-opts = builtins.toString (cfg.kernel.opts ++ [
"root=/dev/ram0"
]);
initrd = cfg.initrd.path;
initrd-opts = builtins.toString (cfg.initrd.opts ++ [

]);
in
builtins.toFile "bootscript.ipxe" ''
#!ipxe
  kernel ${kernel} ${kernel-opts}
  initrd ${initrd} ${initrd-opts}
  boot
''
