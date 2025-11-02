{pkgs,interface, ...}:
{
  services.dnsmasq = {
    package = pkgs.dnsmasq;
    enable = true;
    alwaysKeepRunning = true;
    settings = {
      inherit interface;
      bind-interfaces=true;
      dhcp-range="192.168.1.50,192.168.1.150,12h";
      dhcp-boot="pxelinux.0";
      enable-tftp=true;
      tftp-root="/srv/tftp"; # TODO: Some proper nix way of configuring this
      log-dhcp=true;
      log-queries=true;
    };
  };
}
