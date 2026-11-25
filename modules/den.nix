{inputs, ...}: {
  imports = [inputs.den.flakeModule];

  den = {
    default.nixos.system.stateVersion = "26.11";
    hosts.x86_64-linux.vm.users.asti0s = {};
    aspects.vm = {};
    aspects.asti0s = {
      user = {
        extraGroups = ["wheel" "networkmanager"];
        initialPassword = "changeme";
        isNormalUser = true;
      };
    };
  };
}
