{config, ...}: {
  sops = {
    age.keyFile = "${config.home.homeDirectory}/.sops/key";
    defaultSopsFile = ../../../secrets/users.json;
    defaultSopsFormat = "json";
    secrets.OPENROUTER_API_KEY = {};
  };

  home.sessionVariables.OPENROUTER_API_KEY = "$(cat $HOME/.config/sops-nix/secrets/OPENROUTER_API_KEY)";
}
