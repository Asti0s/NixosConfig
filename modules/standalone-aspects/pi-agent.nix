{
  flake.aspects.pi-agent = {
    nixos = {
      lib,
      config,
      pkgs,
      ...
    }: {
      options.pi-agent = {
        openrouterApiKeyFile = lib.mkOption {
          type = lib.types.path;
          default = "/run/secrets/OPENROUTER_API_KEY";
          description = "A path to a file containing your openrouter api key";
        };
        tinyfishApiKeyFile = lib.mkOption {
          type = lib.types.path;
          default = "/run/secrets/TINYFISH_API_KEY";
          description = "A path to a file containing your tinyfish api key";
        };
        exaApiKeyFile = lib.mkOption {
          type = lib.types.path;
          default = "/run/secrets/EXA_API_KEY";
          description = "A path to a file containing your exa api key";
        };
      };

      config = let
        cfg = config.pi-agent;

        pi-bolt = pkgs.stdenvNoCC.mkDerivation {
          pname = "pi-bolt";
          version = "1.3.0";

          src = pkgs.fetchurl {
            url = "https://github.com/opensec-git/Pi-Bolt/releases/download/bolt-v1.3.0/pi-bolt-linux-x64.tar.xz";
            hash = "sha256:6d15e573d7eeebfecf10c1e1bab288deb0ffd773d9315b682c0c32fedb3aea58";
          };

          nativeBuildInputs = [pkgs.autoPatchelfHook];
          buildInputs = [pkgs.stdenv.cc.cc.lib];
          autoPatchelfIgnoreMissingDeps = ["libxcb.so.1"];

          installPhase = ''
            runHook preInstall
            mkdir -p $out/bin $out/share/pi-bolt
            cp -a . $out/share/pi-bolt/
            ln -s $out/share/pi-bolt/pi $out/bin/pi
            ln -s $out/share/pi-bolt/pi $out/bin/pi-bolt
            runHook postInstall
          '';

          dontStrip = true;

          meta = {
            description = "Pi coding agent, compiled to native code";
            homepage = "https://github.com/opensec-git/Pi-Bolt";
            license = lib.licenses.mit;
            platforms = lib.platforms.linux;
            mainProgram = "pi";
            sourceProvenance = [lib.sourceTypes.binaryNativeCode];
          };
        };

        configFiles = {
          settingsJson = pkgs.writeText "settings.json" (builtins.toJSON {
            "$schema" = "https://pi.dev/schemas/settings.schema.json";
            enableInstallTelemetry = false;
            enableAnalytics = false;
            markdown.codeBlockIndent = "";
            terminal.showTerminalProgress = true;
            outputPad = 0;
            showCacheMissNotices = true;
            steeringMode = "all";
            defaultProvider = "openrouter";
            defaultModel = "meta/muse-ember";
            defaultThinkingLevel = "medium";
            compaction.enabled = false;
            "observational-memory" = {
              compactAfterTokens = 100000;
              compactAfterTokensMode = "calibrated";
              model = {
                id = "tencent/hy4-flash";
                thinking = "off";
              };
            };
            defaultProjectTrust = "always";
            packages = [
              "npm:pi-web-access"
              "npm:pi-observational-memory"
            ];
            extensions = [
              "-builtin:codemode"
              "-builtin:tool-search"
              "-builtin:llama.cpp"
              "-builtin:mcp"
            ];
          });

          modelsJson = pkgs.writeText "models.json" (builtins.toJSON {
            "$schema" = "https://pi.dev/schemas/models.schema.json";
            providers.openrouter = {
              apiKey = "!${pkgs.coreutils}/bin/cat ${cfg.openrouterApiKeyFile}";
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

          websearchJson = pkgs.writeText "web-search.json" (builtins.toJSON {
            tinyfishApiKey = "!${pkgs.coreutils}/bin/cat ${cfg.tinyfishApiKeyFile}";
            exaApiKey = "!${pkgs.coreutils}/bin/cat ${cfg.exaApiKeyFile}";
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

          appendSystemMd = pkgs.writeText "APPEND_SYSTEM.md" ''
            **web_search.** Use these defaults on every call; override only when the user explicitly asks or the task clearly demands it:
            - `numResults: 6`; raise to ~10 only for multi-source comparisons or literature sweeps.
            - `domainFilter` SEO-farm exclusions: `["-geeksforgeeks.org", "-w3schools.com", "-tutorialspoint.com", "-javatpoint.com", "-medium.com"]`.
            - Avoid `includeContent: true`; fetch the specific sources instead.
            - If results are poor, rephrase the queries rather than escalating parameters.
          '';
        };

        pi-wrapped = pkgs.writeShellScriptBin "pi" ''
          agentDir="$HOME/.pi/agent"
          mkdir -p "$agentDir"
          ln -sf ${configFiles.settingsJson} "$agentDir/settings.json"
          ln -sf ${configFiles.modelsJson} "$agentDir/models.json"
          ln -sf ${configFiles.websearchJson} "$agentDir/web-search.json"
          ln -sf ${configFiles.appendSystemMd} "$agentDir/APPEND_SYSTEM.md"
          export PI_SKIP_VERSION_CHECK=1
          export PIBOLT_NO_AUTO_UPDATE=1
          exec ${pi-bolt}/bin/pi "$@"
        '';
      in {
        environment.systemPackages = [
          pi-wrapped
        ];
      };
    };
  };
}
