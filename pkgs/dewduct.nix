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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "DaKnig";
    repo = "DewDuct";
    rev = "v${version}";
    hash = "sha256-PezCs4UxlapXqDOuVJ5QNjMQtQle/DE2eBnVpMYMu54=";
  };

  cargoHash = "sha256-HkmFjgF1j0tH01iUNjwTH2wTptHBoAY8Flh5rz/Kgmw=";

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
