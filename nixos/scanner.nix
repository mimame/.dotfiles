{ ... }: {

  services.saned.enable = true;
  hardware.sane = {
    enable = true;
    openFirewall = true;
    brscan5 = {
      enable = true;
      netDevices = {
        narnia = {
          model = "MFC-L2710DW";
          ip = "192.168.1.39";
        };
      };
    };
  };

}
