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

    initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" ];
    initrd.kernelModules = [ ];

    kernelModules = [ "kvm-intel" ];
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
