{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, libhighscore
, SDL2
, libpcap
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-gearsystem";
  version = "0-unstable-2024-11-16";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "gearsystem";
    rev = "3a32a7c4e14871c2c79bcbb45182cb870d5d9836";
    hash = "sha256-U/pTC84AzFixSJB4AfPlrliMQLmtzvjPMAaR40FiCrY=";
  };

  sourceRoot = "source/platforms/highscore";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libhighscore
  ];

  passthru.updateScript = unstableGitUpdater { url = finalAttrs.src.gitRepoUrl; };

  meta = {
    description = "Port of Gearsystem to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})
