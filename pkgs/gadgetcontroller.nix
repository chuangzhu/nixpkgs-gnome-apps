{ lib
, python3
, fetchFromGitHub
, gtk3
, libhandy
, gobject-introspection
, wrapGAppsHook
, gnome
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gadgetcontroller";
  version = "unstable-2022-03-06";

  format = "other";

  src = fetchFromGitHub {
    owner = "Beaerlin";
    repo = pname;
    rev = "ff7d638543c8a866f207f2a4d4e4fae64003e9da"; # main
    sha256 = "sha256-3YQduEjZEQwE1u85kL5ZSAzQE51If+uhZ7MEg4X4Q0I=";
  };

  postPatch = ''
    sed '/^#/! s|/usr/bin/||' \
      src/usr/lib/systemd/system/gadgetcontroller.service \
      src/usr/share/applications/gadgetcontroller.desktop \
      src/usr/bin/gadgetcontroller-service.py
    sed -i 's|/usr/share/icons/Adwaita/\(.*\).png|${gnome.adwaita-icon-theme}/share/icons/Adwaita/\1.png|' \
      src/usr/share/applications/gadgetcontroller.desktop \
      src/usr/bin/gadgetcontroller.py
  '';

  nativeBuildInputs = [
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    gtk3
    libhandy
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pygobject3
    pydbus
  ];

  installPhase = ''
    runHook preInstall
    install -Dm444 src/usr/share/applications/gadgetcontroller.desktop $out/share/applications/gadgetcontroller.desktop
    install -Dm555 src/usr/bin/gadgetcontroller.py $out/bin/gadgetcontroller.py
    install -Dm444 src/usr/lib/systemd/system/gadgetcontroller.service $out/lib/systemd/system/gadgetcontroller.service
    install -Dm444 src/etc/dbus-1/system.d/de.beaerlin.GadgetController.conf $out/share/dbus-1/system.d/de.beaerlin.GadgetController.conf
    install -Dm555 src/usr/bin/gadgetcontroller-service.py $out/bin/gadgetcontroller-service.py
    runHook postInstall
  '';

  meta = with lib; {
    description = "D-Bus service and GTK app for creating USB gadgets in ConfigFS";
    homepage = "https://github.com/Beaerlin/gadgetcontroller";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.linux;
  };
}
