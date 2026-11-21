{
  flake.aspects.user-deploy = {
    nixos = {
      users.users.deploy = {
        isNormalUser = true;
        uid = 1000;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMNCpW934xEI0b9si/tiEjBUrRg45HVE+vic8IXpaDV deploy@homelab"
        ];
      };
      nix.settings.trusted-users = ["deploy"];
      security.sudo.extraRules = [
        {
          users = ["deploy"];
          commands =
            map
            (goal: {
              command = "/nix/store/*/bin/switch-to-configuration ${goal}";
              options = ["NOPASSWD"];
            })
            ["boot" "switch" "test" "dry-activate"]
            ++ [
              {
                command = "/run/current-system/sw/bin/nix-env --profile /nix/var/nix/profiles/system --set /nix/store/*";
                options = ["NOPASSWD"];
              }
            ];
        }
      ];
    };
  };
}
