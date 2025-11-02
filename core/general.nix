# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, host, username, ... }:

{
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostName = host;
    networkmanager.enable = true; 
    firewall.enable = false;
  };
  
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

   users.users."${username}" = {
     isNormalUser = true;
     intialPassword = "admin";
     extraGroups = [ "wheel" ];
     packages = with pkgs; [
       tree
       git
     ];
   };

  environment.systemPackages = with pkgs; [
    vim 
    wget
  ];

 services.openssh.enable = true;
 
 system.stateVersion = "25.05"; # We're chilling

}

