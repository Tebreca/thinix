# DO NOT MODIFY, instead configure in ./client.nix
{pkgs, lib, config, kernel, ...}:
let
cfg = config.client;
tftp-root = pkgs.callPackage ./tftp-bundle.nix {
    inherit lib cfg pkgs;
};
in
{

  options.client = import ./options.nix {inherit pkgs kernel;};

  config = {

    server.serving-root="${tftp-root}";

    client = import ./client.nix {inherit lib pkgs kernel;};

  };
}
