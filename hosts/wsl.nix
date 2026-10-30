{
  ...
}:

{
  system.stateVersion = "26.05";
  networking.hostName = "asti0s-tty-wsl";

  wsl = {
    enable = true;
    defaultUser = "asti0s";
  };
}
