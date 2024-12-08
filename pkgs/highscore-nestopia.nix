{ lib
, stdenv
, fetchFromGitLab
, meson
, ninja
, pkg-config
, libhighscore
, unstableGitUpdater
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-nestopia";
  version = "0-unstable-2024-11-16";

  src = fetchFromGitLab {
    owner = "alice-m";
    repo = "nestopia";
    rev = "36c1f37b06bf533d45ba5186e22bb297f3597dd1";
    hash = "sha256-tQV6amwt05qEQjzHqgXtaYt1D4wQ3lG3xlasjQRggSA=";
  };

  sourceRoot = "source/highscore";

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libhighscore
  ];

  passthru.updateScript = unstableGitUpdater { url = finalAttrs.src.meta.homepage; };

  meta = {
    description = "Port of Nestopia to Highscore";
    homepage = "https://gitlab.com/alice-m/nestopia";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})

