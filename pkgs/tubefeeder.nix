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
  version = "1.13.1";

  src = fetchFromGitLab {
    owner = "schmiddi-on-mobile";
    repo = "pipeline";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TuULs+6TWmNMZhF+BCL7aDieiaGIGOTMzAsS9624XHo=";
  };

  postPatch = ''
    substituteInPlace data/de.schmidhuberj.tubefeeder.desktop --replace "/app/bin/tubefeeder" "tubefeeder"
  '';

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = finalAttrs.src + /Cargo.lock;
    outputHashes = {
      "tf_core-0.1.4" = "sha256-nAqoI0/LaHDmdhm/3Z2WLkOMbjkvLU6VD2haEi/YFJc=";
      "tf_join-0.1.7" = "sha256-nAqoI0/LaHDmdhm/3Z2WLkOMbjkvLU6VD2haEi/YFJc=";
      "tf_filter-0.1.3" = "sha256-nAqoI0/LaHDmdhm/3Z2WLkOMbjkvLU6VD2haEi/YFJc=";
      "tf_observer-0.1.3" = "sha256-nAqoI0/LaHDmdhm/3Z2WLkOMbjkvLU6VD2haEi/YFJc=";
      "tf_playlist-0.1.4" = "sha256-nAqoI0/LaHDmdhm/3Z2WLkOMbjkvLU6VD2haEi/YFJc=";
      "tf_platform_youtube-0.1.7" = "sha256-nAqoI0/LaHDmdhm/3Z2WLkOMbjkvLU6VD2haEi/YFJc=";
      "tf_platform_peertube-0.1.5" = "sha256-nAqoI0/LaHDmdhm/3Z2WLkOMbjkvLU6VD2haEi/YFJc=";
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
