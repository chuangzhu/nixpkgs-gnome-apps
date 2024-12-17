{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, libhighscore
, mupen64plus
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-mupen64plus";
  version = "0-unstable-2024-11-24";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "mupen64plus-highscore";
    rev = "21ba520e72198e797accc05bbc58254e2136eb91";
    hash = "sha256-DLkbILaTEKbBu3Amesw25ksm4ILCrD273CvG/3F9n38=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libhighscore
    mupen64plus
  ];

  passthru.updateScript = unstableGitUpdater { url = finalAttrs.src.gitRepoUrl; hardcodeZeroVersion = true; };

  meta = {
    description = "Port of Mupen64Plus to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
    inherit (mupen64plus.meta) platforms broken;
  };
})
