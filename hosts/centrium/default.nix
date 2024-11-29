{ inputs, pkgs, ... }:

{
  imports = with inputs.nixos-hardware.nixosModules; [
    common-cpu-intel
    common-pc-ssd
  ] ++ [
    ../features/required
    ../features/zram-swap.nix
    ./partitioning.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    supportedFilesystems = [ "nfs" ];

    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "usbhid" ];
      #supportedFilesystems = [ "nfs" ];
      #kernelModules = [ "nfs" ];
    };

    kernelModules = [ "kvm-intel" ];

    kernelParams = [ "nfs.nfs4_disable_idmapping=0" "nfsd.nfs4_disable_idmapping=0" ];
  };

  users.groups.builder = { };

  users.users.rodrigo.extraGroups = [ "builder" ];
  users.users.otavio.extraGroups = [ "builder" ];

  system.activationScripts.srv =
    ''
      mkdir -p /srv/yocto/download-cache
      mkdir -p /srv/yocto/sstate-cache
    '';

  fileSystems."/srv/yocto/sstate-cache" = {
    device = "10.5.4.130:/srv/nfs/yocto/sstate-cache";
    fsType = "nfs";
    options = [ "auto" "rw" "defaults" "_netdev" "x-systemd.automount" ];
  };

  fileSystems."/srv/yocto/download-cache" = {
    device = "10.5.4.130:/srv/nfs/yocto/download-cache";
    fsType = "nfs";
    options = [ "auto" "rw" "defaults" "_netdev" "x-systemd.automount" ];
  };

  services.bitbake = {
    enable = true;
    versions = {
      "scarthgap" = {
        package = pkgs.bitbakePackages.bitbake_2_8_7;
        hashServPort = 8686;
        prServPort = 8685;
      };
      "styhead" = {
        package = pkgs.bitbakePackages.bitbake_2_10_2;
        hashServPort = 8786;
        prServPort = 8785;
      };
    };
  };
}
