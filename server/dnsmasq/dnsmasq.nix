{pkgs, ...}:
{
  services.dnsmasq = {
    package = pkgs.dnsmasq;
    enable = true;
    alwaysKeepRunning = true;
    configFile = ./config.conf;
  };
}
