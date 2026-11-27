{
  flake.aspects.swap = {
    nixos = {
      services.zram-generator = {
        enable = true;
        settings = {
          zram0 = {
            zram-size = "min(ram / 2, 16384)";
            compression-algorithm = "zstd";
            swap-priority = 100;
          };
        };
      };

      boot.kernel.sysctl = {
        "vm.swappiness" = 100;
        "vm.watermark_boost_factor" = 0;
        "vm.watermark_scale_factor" = 125;
        "vm.page-cluster" = 0;
      };

      systemd.oomd.enable = true;
    };
  };
}
