{
  inputs,
  config,
  ...
}: {
  flake.aspects.installer = {
    nixos = {
      nixpkgs.hostPlatform = "x86_64-linux";
      console.keyMap = "fr";
      users.users.nixos.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIEPIzhrZcsQ9K3WY+/Y7Tv0ovDLXyCDrTuJoUYagClb perso@infra"
      ];
    };
  };

  flake.nixosConfigurations.installer = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
      config.flake.modules.nixos.installer
    ];
  };
}
