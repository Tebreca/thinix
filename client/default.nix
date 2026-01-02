# Configuration values and definitions, respectively in ./client.nix and ./options.nix
# moved out of file to keep a clean tree

{pkgs, lib, config, kernel, inputs, system, ...}:
let
cfg = config.client;
crossPkgs = import inputs.nixpkgs {
  inherit system;
  crossSystem = {
    config = "i686-unknown-linux-gnu";
  };
};
tftp-root = pkgs.callPackage ./tftp-bundle.nix {
  inherit lib cfg pkgs crossPkgs;
};
in
{

  options.client = import ./options.nix {inherit pkgs kernel;};

  config = {

# output of the client module -> evaluates to a custom Geode GX1/generic x86 kernel + initramfs
    server.serving-root="${tftp-root}";

    client = import ./client.nix {inherit lib pkgs kernel;};

  };
}
