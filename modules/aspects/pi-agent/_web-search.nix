{
  tinyfishKeyFile,
  exaKeyFile,
}: {pkgs, ...}: {
  piAgent.files.webSearch = pkgs.writeText "web-search.json" (builtins.toJSON {
    tinyfishApiKey = "!${pkgs.coreutils}/bin/cat ${tinyfishKeyFile}";
    exaApiKey = "!${pkgs.coreutils}/bin/cat ${exaKeyFile}";
    workflow = "none";
    searchRouting = {
      providers = [
        "tinyfish"
        "exa"
      ];
      fallbackOn = [
        "transient"
        "quota"
        "network"
        "invalid-response"
      ];
    };
    fetchRouting = {
      providers = [
        "tinyfish"
        "exa"
      ];
      allowRemoteHostedProviders = true;
      fallbackOn = [
        "transient"
        "quota"
        "network"
        "invalid-response"
      ];
    };
  });
}
