{
  config,
  lib,
  ...
}:
with lib;
let
  cfgBridge = config.networking.hostBridge;
in
{
  options.networking.hostBridge = {
    enable = mkEnableOption "a DHCP-configured network bridge";
    interface = mkOption {
      type = types.str;
      description = "Physical interface connected to the host bridge.";
    };
    name = mkOption {
      type = types.str;
      default = "br0";
      description = "Name of the host bridge.";
    };
  };

  config = {
    networking = mkIf cfgBridge.enable {
      bridges.${cfgBridge.name}.interfaces = [ cfgBridge.interface ];
      interfaces = {
        ${cfgBridge.interface}.useDHCP = false;
        ${cfgBridge.name}.useDHCP = true;
      };
    };
    boot.loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        consoleMode = "2";
        editor = false;
        enable = true;
      };
    };
  };
}
