{den, ...}: {
  den.aspects.asti0s = {
    includes = [den.aspects.pi-agent];

    user = {
      extraGroups = ["wheel" "networkmanager"];
      initialPassword = "changeme";
      isNormalUser = true;
    };
  };
}
