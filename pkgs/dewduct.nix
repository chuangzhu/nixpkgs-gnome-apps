{ lib
, rustPlatform
, fetchFromGitHub
, gtk4
, libadwaita
, openssl
, pkg-config
, wrapGAppsHook4
, glib
, nix-update-script
}:

rustPlatform.buildRustPackage rec {
  pname = "dewduct";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "DaKnig";
    repo = "DewDuct";
    rev = "v${version}";
    hash = "sha256-XNHq5tuogJkdTGq37/mCZVXzrmjE1tKLa3rGOpg6T3Y=";
  };

  cargoHash = "sha256-MBPmlUNI2YNLTS0S+iSKnuPwelf7rS4LQ0GW+kFJQ1Q=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    glib
  ];
  buildInputs = [
    gtk4
    libadwaita
    openssl
  ];

  passthru.updateScript = nix-update-script { attrPath = pname; };

  meta = with lib; {
    description = "Youtube player for Linux on desktop and mobile";
    homepage = "https://github.com/DaKnig/DewDuct";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
