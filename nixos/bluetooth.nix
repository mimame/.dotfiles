{ pkgs, ... }:
{

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings = {
      General = {
        # Enable experimental features like battery level
        Experimental = true;
        KernelExperimental = true;
        # Prioritize faster connection speeds over energy efficiency.
        FastConnectable = true;
        # Allows multiple profiles to be used simultaneously (e.g., audio and keyboard)
        MultiProfile = "multiple";
        # Ensures that devices using the "Just Works" pairing method can re-pair automatically, even after disconnection or reboot
        JustWorksRepairing = "always";
      };
    };
  };
  services.blueman.enable = true;
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        ["bluez5.enable-sbc-xq"] = true,
        ["bluez5.enable-msbc"] = true,
        ["bluez5.enable-hw-volume"] = true,
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };

  environment.systemPackages = with pkgs; [

    bluez-tools
  ];
}
