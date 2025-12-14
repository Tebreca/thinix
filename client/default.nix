{pkgs, ...}:
{
  imports = [
    ./kernel.nix
  ];

  client = {
    programs = with pkgs; [
      busybox
    ];
  };
}
