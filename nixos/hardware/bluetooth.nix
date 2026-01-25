# ----------------------------------------------------------------------------
# Bluetooth Configuration
#
# This file configures the system's Bluetooth stack, services, and audio codecs.
# ----------------------------------------------------------------------------
{ pkgs, ... }:
{
  # Configure the core BlueZ Bluetooth stack.
  hardware.bluetooth = {
    enable = true;
    # Disable Bluetooth on boot to save power; it can be enabled manually.
    powerOnBoot = false;
    settings = {
      General = {
        # Enable experimental BlueZ features, which may include better support
        # for newer devices or features like battery level reporting.
        Experimental = true;
        KernelExperimental = true;
        # Prioritize faster connection speeds over energy efficiency.
        FastConnectable = true;
        # Allow a device to use multiple profiles simultaneously (e.g., headset and keyboard).
        MultiProfile = "multiple";
        # Ensure that devices using the "Just Works" pairing method can re-pair
        # automatically after disconnection, improving convenience.
        JustWorksRepairing = "always";
      };
    };
  };

  # Configure WirePlumber to enable high-quality Bluetooth audio codecs.
  # This improves the audio experience with compatible Bluetooth headphones.
  environment.etc = {
    "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
      bluez_monitor.properties = {
        -- Enable SBC-XQ (eXtreme Quality), a high-bitrate version of the SBC codec.
        ["bluez5.enable-sbc-xq"] = true,
        -- Enable mSBC (modified SBC), used for wide-band speech in HFP.
        ["bluez5.enable-msbc"] = true,
        -- Allow hardware volume control, syncing the device volume with the system volume.
        ["bluez5.enable-hw-volume"] = true,
        -- Define supported headset roles for compatibility.
        ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
      }
    '';
  };

  # Install command-line tools for managing and debugging Bluetooth.
  environment.systemPackages = with pkgs; [ bluez-tools ];
}
