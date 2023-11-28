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
  version = "1.14.1";

  src = fetchFromGitLab {
    owner = "schmiddi-on-mobile";
    repo = "pipeline";
    rev = "v${finalAttrs.version}";
    hash = "sha256-CQFxNA6gC5mUdyFbf/oMK5kLtzRhglXCDHnyb9XQOSg=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = finalAttrs.src + /Cargo.lock;
    outputHashes = {
      "tf_core-0.1.4" = "sha256-bWkF1ezdDZyuP2zo5EIvB/Br6HFpdmkDijpQii/4i68=";
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
