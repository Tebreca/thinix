{lib, cpkgs}:
{
  kernel = {

  };
  
  arch = {

    system = "i686-linux";
    overlays = [
      (self: super: {
        gss = super.gcc.overrideAttrs (old: {
            configureFlags = old.configureFlags ++ ["--with-arch=i586"];
            CFLAGS = "-march=i568 -m32 " + (old.CFLAGS or "");
          });

      })
    ];
  };
}
