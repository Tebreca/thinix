{interface, ...}:
{
  networking.interfaces."${interface}" = {
    useDHCP = false;
    ipv4 = {
      addresses = [
        {
          address = "192.168.1.1";
          prefixLength = 24;
        }
      ];
    };
  };
}
