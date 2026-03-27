{ config, lib, pkgs, ... }:
{
  boot.kernelParams = [
    # allow more retries
    "rd.luks.options=tries=5"
  ];

  boot.initrd.systemd.settings.Manager = {
    # remove default 90 seconds timeout
    DefaultDeviceTimeoutSec = "infinity";
  };
}
