{openrouterKeyFile}: {pkgs, ...}: {
  piAgent.files.models = pkgs.writeText "models.json" (builtins.toJSON {
    "$schema" = "https://pi.dev/schemas/models.schema.json";
    providers.openrouter = {
      apiKey = "!${pkgs.coreutils}/bin/cat ${openrouterKeyFile}";
      modelOverrides = {
        "meta/muse-ember" = {
          compat.openRouterRouting.only = ["google-vertex/global"];
        };
        "openai/gpt-oss-20b" = {
          compat.openRouterRouting.only = ["coreweave/fp4"];
        };
        "tencent/hy4-flash" = {
          compat.openRouterRouting.only = ["tencent/fp8"];
        };
        "z-ai/glm-5.3-flash" = {
          compat.openRouterRouting.only = ["z-ai/fp8"];
        };
      };
    };
  });
}
