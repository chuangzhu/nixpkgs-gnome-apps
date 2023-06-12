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
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "iman-salmani";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HnW0Y0TG5L9fx9Vlv7C4PLevzjd7FdvHk+7GBeG8XKs=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-VnQAQ4JtjGq6YRwFchA9Jl9GVT1/ME82nPT8fcsn5L8=";
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
