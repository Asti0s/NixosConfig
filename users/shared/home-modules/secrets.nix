{config, ...}: {
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.sops/key";
    defaultSopsFile = ../../../secrets/users.json;
    defaultSopsFormat = "json";
    secrets = {
      OPENROUTER_API_KEY = {};
      PROTON_PASS_PERSONAL_ACCESS_TOKEN = {};
    };
  };

  home.sessionVariables = {
    PROTON_PASS_PERSONAL_ACCESS_TOKEN = "$(cat $HOME/.config/sops-nix/secrets/PROTON_PASS_PERSONAL_ACCESS_TOKEN)";
    OPENROUTER_API_KEY = "$(cat $HOME/.config/sops-nix/secrets/OPENROUTER_API_KEY)";
    SOPS_AGE_KEY_FILE = "$HOME/.sops/key";
  };
}
