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
    loader.efi.efiSysMountPoint = "/boot";

    initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" ];
    initrd.kernelModules = [ ];

    kernelModules = [ "kvm-intel" ];

    kernelParams = [ "nfs.nfs4_disable_idmapping=0" "nfsd.nfs4_disable_idmapping=0" ];
  };

  users.groups.builder = { };

  users.users.rodrigo.extraGroups = [ "builder" ];

  networking.firewall.allowedTCPPorts = [ 2049 ];

  system.activationScripts.srv =
    ''
      mkdir -p /srv/nfs/yocto/download-cache
      mkdir -p /srv/nfs/yocto/sstate-cache
      chmod -R g+s /srv/nfs/yocto/*
      chown -R root:builder /srv/nfs/yocto/*
      chmod -R 775 /srv/nfs/yocto/*
      ${pkgs.acl}/bin/setfacl -m d:u::rwX,d:g::rwX,d:o::rX /srv/nfs/yocto/*
    '';

  services.nfs.server = {
    enable = true;
    createMountPoints = true;
    exports = ''
      /srv/nfs/yocto/download-cache 10.5.3.0/24(rw,sync,nohide,insecure,no_subtree_check) 10.5.4.0/24(rw,sync,nohide,insecure,no_subtree_check)
      /srv/nfs/yocto/sstate-cache   10.5.3.0/24(rw,sync,nohide,insecure,no_subtree_check) 10.5.4.0/24(rw,sync,nohide,insecure,no_subtree_check)
    '';
  };
}
