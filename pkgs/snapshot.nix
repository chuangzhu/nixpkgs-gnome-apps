{ lib
, stdenv
, fetchFromGitLab
, rustPlatform
, cargo
, rustc
, meson
, pkg-config
, desktop-file-utils
, ninja
, wrapGAppsHook_4_11
, gtk_4_11
, libadwaita_1_4
, gdk-pixbuf
, shared-mime-info
, pipewire
, gst_all_1
, clippy
, nix-update-script
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "snapshot";
  version = "44.2";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "snapshot";
    rev = finalAttrs.version;
    hash = "sha256-fJEs7GqL94NZiz8f7MJvcfOoufE7LnT/iBvo/2D0zHg=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) src;
    hash = "sha256-cMyS7LntMqRwUp3RJzE0ECiwWYaavHU8JaGE3oWl2Dc=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    desktop-file-utils # update-desktop-database
    ninja
    wrapGAppsHook_4_11
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];

  buildInputs = [
    gtk_4_11
    libadwaita_1_4
    gdk-pixbuf
    shared-mime-info
    pipewire # pipewiredeviceprovider
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base # gstreamer-video-1.0
    (gst-plugins-good.override { gtkSupport = true; })
    gst-plugins-bad # camerabin
  ]);

  checkInputs = [ clippy ];

  passthru.updateScript = nix-update-script { attrPath = finalAttrs.pname; };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/Incubator/snapshot/";
    description = "Take pictures and videos";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ chuangzhu ];
    platforms = platforms.unix;
    # ERROR aperture::viewfinder: Could not start camerabin: Element failed to change its state  
    # broken = true; 
  };
})
