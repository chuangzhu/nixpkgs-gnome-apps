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
  pname = "pipeline";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "Tubefeeder";
    repo = "Pipeline";
    rev = "v${version}";
    sha256 = "sha256-+ZnKi/nHnqp4zoCGbfozWT4Ge63aXG4sEd59d54qaqY=";
  };

  postPatch = ''
    substituteInPlace data/de.schmidhuberj.tubefeeder.desktop --replace "/app/bin/tubefeeder" "tubefeeder"
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = "sha256-4pq6fX6nxLGWbRPkg600IdddQ7SuS9axgKr3cuse1wk=";
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
    openssl
  ];

  passthru.updateScript = nix-update-script { attrPath = pname; };

  meta = with lib; {
    description = "Youtube, Lbry and Peertube client made for the Pinephone";
    homepage = "https://www.tubefeeder.de";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
