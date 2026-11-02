{
  system.stateVersion = "26.05";
  nixpkgs = {
    hostPlatform = "x86_64-linux";
    config.allowUnfree = true;
  };

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/Paris";
  console.keyMap = "fr";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.vmVariant = {
    virtualisation = {
      qemu.options = [
        "-vga virtio"
        "-display gtk,full-screen=on,grab-on-hover=on"
      ];
      memorySize = 4096;
      cores = 4;
      sharedDirectories.share = {
        source = "/home/asti0s/NixosConfig";
        target = "/home/asti0s/NixosConfig";
      };
    };
    services.getty.autologinUser = "asti0s";

    home-manager.users.asti0s.wayland.windowManager.sway.config.output."Virtual-1" = {
      mode = "--custom 2256x1504@59.93Hz";
      scale = "1.25";
    };
  };
}
