# ----------------------------------------------------------------------------
# Bluetooth Configuration
#
# Configures BlueZ Bluetooth stack with high-quality audio codec support.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false; # Disabled to save power; enable manually when needed
    settings.General = {
      # Enable experimental BlueZ features for better device support,
      # including battery level reporting for newer devices
      Experimental = true;
      KernelExperimental = true;

      # Prioritize connection speed over energy efficiency
      FastConnectable = true;

      # Allow devices to use multiple profiles simultaneously
      # (e.g., headset audio + keyboard input)
      MultiProfile = "multiple";

      # Auto-repair "Just Works" paired devices after disconnection
      # Improves convenience by avoiding manual re-pairing
      JustWorksRepairing = "always";
    };
  };

  # WirePlumber: Enable high-quality Bluetooth audio codecs
  # Improves audio experience with compatible Bluetooth headphones/speakers
  environment.etc."wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
    bluez_monitor.properties = {
      -- SBC-XQ (eXtreme Quality): High-bitrate version of SBC codec
      ["bluez5.enable-sbc-xq"] = true,
      -- mSBC (modified SBC): Wide-band speech for HFP headset profile
      ["bluez5.enable-msbc"] = true,
      -- Hardware volume control: Sync device volume with system volume
      ["bluez5.enable-hw-volume"] = true,
      -- Supported headset roles for compatibility
      ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
    }
  '';

  environment.systemPackages = with pkgs; [ bluez-tools ];
}
