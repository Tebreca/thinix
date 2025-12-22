# DO NOT MODIFY, instead configure in ./client.nix
{pkgs, lib, config, pkgs-src, ...}:
let
cfg = config.client;

# Some clients have custom needs, for example i586 processors or specific package substitutions
cpkgs = import pkgs-src {
  inherit (cfg.arch) system overlays;
};

# Generate the root to be served under tftp. We use our client packages to generate this; we compile custom packages where nescessary
tftp-root = pkgs.callPackage ./tftp-bundle {
    pkgs = cpkgs;
    inherit cfg;
};
in
{
# Options extracted to keep file clean
  options.client = import ./options.nix {inherit pkgs;};

  config = {

# Pass the serving root generated in this module to the server. This is the module's output
    server.serving-root="${tftp-root}";

# The configuration file for the client.
    client = import ./client.nix {inherit lib cpkgs;};

  };
}
