{interface, ...}:
{
  networking.interfaces."${interface}" = {
    useDHCP = false;
    ipv4 = {
      adresses = [
        {
          adress = "192.168.1.1";
          prefixLength = 24;
        }
      ];
    };
  };
}
