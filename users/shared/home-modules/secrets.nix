{config, ...}: {
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.sops/key";
    defaultSopsFile = ../../../secrets/users.json;
    defaultSopsFormat = "json";
    secrets = {
      PROTON_PASS_PERSONAL_ACCESS_TOKEN = {};
      OPENROUTER_API_KEY = {};
      TINYFISH_API_KEY = {};
      EXA_API_KEY = {};
    };
  };

  home.sessionVariables = {
    SOPS_AGE_KEY_FILE = "$HOME/.sops/key";
    PROTON_PASS_PERSONAL_ACCESS_TOKEN = "$(cat $HOME/.config/sops-nix/secrets/PROTON_PASS_PERSONAL_ACCESS_TOKEN)";
    OPENROUTER_API_KEY = "$(cat $HOME/.config/sops-nix/secrets/OPENROUTER_API_KEY)";
    TINYFISH_API_KEY = "$(cat $HOME/.config/sops-nix/secrets/TINYFISH_API_KEY)";
    EXA_API_KEY = "$(cat $HOME/.config/sops-nix/secrets/EXA_API_KEY)";
  };
}
