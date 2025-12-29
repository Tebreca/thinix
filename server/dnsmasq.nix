{pkgs,interface, config, lib, ...}:
let
  inherit (lib) mkOption;
  cfg = config.server;
in
{
  config = {
    services.dnsmasq = {
      package = pkgs.dnsmasq;
      enable = true;
      alwaysKeepRunning = true;
      settings = {
        inherit interface;
        bind-interfaces=true;
        dhcp-range="192.168.1.50,192.168.1.150,12h";
        dhcp-boot="bootscript.ipxe";
        enable-tftp=true;
        server=[
          "1.1.1.1"
            "8.8.8.8"
        ];
        tftp-root="${cfg.serving-root}"; 
          log-dhcp=true;
        log-queries=true;
      };
    };
  };

  options = {
    server.serving-root = mkOption {
      description= ''
        The root for the TFTP image host to host from
      '';
      default = "/srv/tftp/";
    };
  };
}
