{pkgs, ...}:
let
  kernel = pkgs.callPackage ./kernel.nix {
    inherit pkgs; 
    {
      options = [

      ];
    };
  };
in
{
  server.serving-root="/srv";
}
