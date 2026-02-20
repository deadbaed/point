{ config, lib, pkgs, ... }:
{
  boot.kernelParams = [ "ip=dhcp" ];

  boot.initrd = {
    availableKernelModules = [ "r8169" ];
    network = {
      enable = true;
      ssh = {
        enable = true;
        port = 2222;
        authorizedKeys = config.users.users.phil.openssh.authorizedKeys.keys;
        hostKeys = [ "/etc/secrets/initrd/ssh_host_ed25519_key" ];
      };
    };
    systemd.users.root.shell = "/bin/systemd-tty-ask-password-agent";
  };
}
