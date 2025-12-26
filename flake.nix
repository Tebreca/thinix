{
  description = "A server for serving flakes to thin clients";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    kernel = {
      type="github";
      owner = "torvalds";
      repo="linux";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, kernel, ... }@inputs:
    let
    username="admin";
  system="x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config = {
      allowUnfree=true;
    };
  };
  lib = nixpkgs.lib;
  in
  {
    nixosConfigurations = {
      server = lib.nixosSystem {
        inherit system;
        modules = [
          ./server
          ./core
          ./client
          ./hardware-configuration.nix
        ];
        specialArgs = {
          host="server";
          interface ="enp2s0";
          inherit self inputs lib username system kernel;
        };
      };
    };
  };
}
