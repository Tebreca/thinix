{cfg ? {
  kernel = {
    path = "bzImage";
    opts = [];
  };
  initrd = {
    path = "init.cpio";
    opts = [];
  }
}}:
let
kernel = cfg.kernel.path;
kernel-opts = builtins.toString (cfg.kernel.opts ++ [
"root=/dev/ram0"
]);
initrd = cfg.initrd.path;
initrd = builtins.toString (cfg.initrd.path)
in
builtins.mkFile "pxelinux.0" ''
  kernel ${kernel} ${kernel-opts}
  initrd ${initrd} ${initrd-opts}
'';
