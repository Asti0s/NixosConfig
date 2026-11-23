{lib, pkgs, ...}: {
  nixpkgs.overlays = [
    (final: _: {
      pi-bolt = final.stdenvNoCC.mkDerivation {
        pname = "pi-bolt";
        version = "1.2.1";

        src = final.fetchurl {
          url = "https://github.com/opensec-git/Pi-Bolt/releases/download/bolt-v1.2.1/pi-bolt-linux-x64-baseline.tar.xz";
          hash = "sha256-sloVrhZPFp1gMWN5thl9REv39StGwFbtS9nhLQzdx5o=";
        };

        nativeBuildInputs = [final.autoPatchelfHook];
        buildInputs = [final.stdenv.cc.cc.lib];
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
    })
  ];
}
