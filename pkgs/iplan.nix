{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
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

stdenv.mkDerivation rec {
  pname = "iplan";
  version = "1.9.2";

  src = fetchFromGitHub {
    owner = "iman-salmani";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-BIoxaE8c3HmvPjgj4wcZK9YFTZ0wr9338AIdYEoAiqs=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-p8ETWWvjtP9f/lc347ORPqTai5p/TWQCCMRe+c0FyFk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    rustPlatform.rust.cargo
    rustPlatform.cargoSetupHook
    rustPlatform.rust.rustc
    pkg-config
    wrapGAppsHook4
    glib
    appstream-glib
    desktop-file-utils
  ];
  buildInputs = [
    gtk4
    libadwaita
  ];

  passthru.updateScript = nix-update-script { attrPath = pname; };

  meta = with lib; {
    description = "Your plan for improving personal life and workflow";
    homepage = "https://github.com/iman-salmani/iplan";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
