{ lib
, python3
, fetchFromGitHub
, gtk4
, libadwaita
, gobject-introspection
, meson
, pkg-config
, ninja
, desktop-file-utils
, wrapGAppsHook4
}:

python3.pkgs.buildPythonApplication {
  pname = "avvie";
  version = "unstable-2023-01-27";

  format = "other";

  src = fetchFromGitHub {
    owner = "Taiko2k";
    repo = "Avvie";
    rev = "0b71c2ab4eb6d3af2c5456ab433e94ea0820d3a5"; # master
    sha256 = "sha256-8CBbTCe56lMh4uGJUml2LizNWVCPeRfaFFDTOmEOVFU=";
  };

  postPatch = ''
    patchShebangs build-aux/meson
  '';

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    desktop-file-utils
    wrapGAppsHook4
    gobject-introspection
  ];

  buildInputs = [
    gtk4
    libadwaita
    gobject-introspection
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    piexif
    pycairo
    pillow
  ];

  # Prevent double wrapping.
  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
    )
  '';

  meta = with lib; {
    description = "GTK app for quick image cropping";
    homepage = "https://github.com/Taiko2k/Avvie";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
  };
}
