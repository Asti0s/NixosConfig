{
  flake.aspects.user-admin = {
    nixos = {
      users.users.admin = {
        isNormalUser = true;
        uid = 1001;
        extraGroups = ["wheel"];
        hashedPassword = "$y$j9T$RZT7anTOhICo/0B0cwaeO.$YZO3E.8EdW7XpT3Wfh.eEPIvzVEY4FNf/UdyjkHM7m6";
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEjBEog3bjL+9Fj1ytvkDL/bZc8uFoPM0cfV0EQNUn8A admin@homelab"
        ];
      };
      security.sudo.wheelNeedsPassword = true;
    };
  };
}
