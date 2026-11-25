{
  flake.aspects.pi-bolt-overlay = {
    nixos = {lib, ...}: {
      nixpkgs.overlays = [
        (final: _: {
          pi-bolt = final.stdenvNoCC.mkDerivation {
            pname = "pi-bolt";
            version = "1.2.1";

            src = final.fetchurl {
              url = "https://github.com/opensec-git/Pi-Bolt/releases/download/bolt-v1.3.0/pi-bolt-linux-x64.tar.xz";
              hash = "sha256:6d15e573d7eeebfecf10c1e1bab288deb0ffd773d9315b682c0c32fedb3aea58";
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
    };
  };
}
