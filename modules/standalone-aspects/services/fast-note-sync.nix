{lib, ...}: {
  flake.aspects.fast-note-sync-service = {
    nixos = {config, ...}: {
      options.fast-note-sync-service = {
        ports = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = ["127.0.0.1:9000"];
          description = "Host bindings (hostIp:hostPort) to expose the service on";
          example = [
            "192.168.1.28:9000"
            "100.72.163.111:9000"
          ];
        };
      };

      config = let
        cfg = config.fast-note-sync-service;
      in {
        virtualisation.oci-containers.containers.fast-note-sync = {
          image = "docker.io/haierkeys/fast-note-sync-service:3.6.1";
          autoStart = true;
          ports = map (hostPort: "${hostPort}:9000") cfg.ports;
          volumes = [
            "/var/lib/fast-note-sync/config:/fast-note-sync/config"
            "/var/lib/fast-note-sync/storage:/fast-note-sync/storage"
          ];
        };

        systemd.tmpfiles.rules = [
          "d /var/lib/fast-note-sync/config 0750 root root -"
          "d /var/lib/fast-note-sync/storage 0750 root root -"
        ];
      };
    };
  };
}
