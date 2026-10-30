{
  ...
}:

{
  nixpkgs.config.allowUnfree = true;
  time.timeZone = "Europe/Paris";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  programs.nix-ld.enable = true;
}
