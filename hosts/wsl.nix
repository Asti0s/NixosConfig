{
  ...
}:

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

  wsl = {
    enable = true;
    defaultUser = "asti0s";
  };
}
