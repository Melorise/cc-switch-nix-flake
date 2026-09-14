{
  description = "CC Switch 3.20.3 repackaged from the upstream x86_64 Debian release";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    cc-switch-x86_64 = {
      url = "file+https://github.com/farion1231/cc-switch/releases/download/v3.20.3/CC-Switch-v3.20.3-Linux-x86_64.deb";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      cc-switch-x86_64,
    }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      packages.x86_64-linux = {
        cc-switch = pkgs.stdenv.mkDerivation {
          pname = "cc-switch";
          version = "3.20.3";
          src = cc-switch-x86_64;

          nativeBuildInputs = with pkgs; [
            autoPatchelfHook
            libarchive
          ];

          buildInputs = with pkgs; [
            cairo
            gdk-pixbuf
            glib
            gtk3
            libsoup_3
            openssl
            webkitgtk_4_1
            xz
          ];

          unpackPhase = ''
            bsdtar --extract --to-stdout --file "$src" data.tar.gz \
              | bsdtar --extract --file - --no-same-owner
          '';

          installPhase = ''
            runHook preInstall

            install -Dm755 usr/bin/cc-switch "$out/bin/cc-switch"
            install -Dm644 "usr/share/applications/CC Switch.desktop" "$out/share/applications/cc-switch.desktop"
            cp -r usr/share/icons "$out/share/icons"

            runHook postInstall
          '';

          meta = with pkgs.lib; {
            description = "All-in-one assistant for Claude Code, Codex, and Gemini CLI";
            homepage = "https://github.com/farion1231/cc-switch";
            license = licenses.mit;
            mainProgram = "cc-switch";
            platforms = [ "x86_64-linux" ];
          };
        };

        default = self.packages.x86_64-linux.cc-switch;
      };

      apps.x86_64-linux.default = {
        type = "app";
        program = "${self.packages.x86_64-linux.default}/bin/cc-switch";
        meta.description = "CC Switch";
      };
    };
}
