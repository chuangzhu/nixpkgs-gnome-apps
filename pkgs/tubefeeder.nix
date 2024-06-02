{ lib
, stdenv
, rustPlatform
, cargo
, rustc
, fetchFromGitLab
, gtk4
, libadwaita
, openssl
, meson
, ninja
, pkg-config
, wrapGAppsHook4
, glib
, appstream-glib
, desktop-file-utils
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pipeline";
  version = "1.15.0";

  src = fetchFromGitLab {
    owner = "schmiddi-on-mobile";
    repo = "pipeline";
    rev = "v${finalAttrs.version}";
    hash = "sha256-tZyAQz7mhd+YXaO6+XYpUxza5ViVELE3J0Zeu11fr/U=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = finalAttrs.src + /Cargo.lock;
    outputHashes = {
      "piped-openapi-sdk-1.0.0" = "sha256-UFzMYYqCzO6KyJvjvK/hBJtz3FOuSC2gWjKp72WFEGk=";
      "tf_core-0.1.4" = "sha256-IW5d0mn/olgm9ydN45ZaDd5AQSGj2kM7QvCHgZSnd8w=";
    };
  };

  nativeBuildInputs = [
    meson
    ninja
    cargo
    rustPlatform.cargoSetupHook
    rustc
    pkg-config
    wrapGAppsHook4
    glib
    appstream-glib
    desktop-file-utils
  ];
  buildInputs = [
    gtk4
    libadwaita
    openssl
  ];

  passthru.updateScript = nix-update-script { attrPath = finalAttrs.pname; };

  meta = with lib; {
    description = "Watch YouTube and PeerTube videos in one place";
    homepage = "https://mobile.schmidhuberj.de/pipeline";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
})
