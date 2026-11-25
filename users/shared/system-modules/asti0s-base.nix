{
  pkgs,
  inputs,
  config,
  ...
}: {
  users.users.asti0s = {
    isNormalUser = true;
    initialPassword = "changeme";
    shell = pkgs.zsh;
    uid = 1000;
    extraGroups = [
      "wheel"
      "docker"
      "networkmanager"
    ];
  };

  imports = [
    inputs.dendritic.modules.nixos.pi-agent
    inputs.sops-nix.nixosModules.sops
  ];

  sops = {
    age.keyFile = "/var/lib/sops-nix/key";
    secrets = {
      OPENROUTER_API_KEY = {
        sopsFile = ../../../secrets/users.json;
        owner = "asti0s";
      };
      TINYFISH_API_KEY = {
        sopsFile = ../../../secrets/users.json;
        owner = "asti0s";
      };
      EXA_API_KEY = {
        sopsFile = ../../../secrets/users.json;
        owner = "asti0s";
      };
      PROTON_PASS_PERSONAL_ACCESS_TOKEN = {
        sopsFile = ../../../secrets/users.json;
        owner = "asti0s";
      };
    };
  };

  pi-agent = {
    openrouterApiKeyFile = config.sops.secrets.OPENROUTER_API_KEY.path;
    tinyfishApiKeyFile = config.sops.secrets.TINYFISH_API_KEY.path;
    exaApiKeyFile = config.sops.secrets.EXA_API_KEY.path;
  };

  fonts = {
    packages = with pkgs; [
      inter
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];

    fontconfig.defaultFonts = {
      sansSerif = ["Inter"];
      serif = ["Noto Serif"];
      monospace = ["JetBrainsMono Nerd Font"];
      emoji = ["Noto Color Emoji"];
    };
  };

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
}
