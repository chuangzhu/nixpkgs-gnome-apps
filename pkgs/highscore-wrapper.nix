{
  symlinkJoin,
  wrapGAppsHook4,
  gtk4,
  librsvg,
  feedbackd,
  highscore-unwrapped,
  highscore-blastem,
  highscore-bsnes,
  highscore-desmume,
  highscore-gearsystem,
  highscore-mednafen,
  highscore-mgba,
  highscore-mupen64plus,
  highscore-nestopia,
  highscore-prosystem,
  highscore-stella,

  cores ? builtins.filter (p: p.meta.available) [
    highscore-blastem
    highscore-bsnes
    highscore-desmume
    highscore-gearsystem
    highscore-mednafen
    highscore-mgba
    highscore-mupen64plus
    highscore-nestopia
    highscore-prosystem
    highscore-stella
  ],
}:

symlinkJoin {
  pname = "highscore";
  inherit (highscore-unwrapped) version meta;

  paths = [ highscore-unwrapped ] ++ cores;

  nativeBuildInputs = [
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    librsvg
    feedbackd
  ];

  dontWrapGApps = true;

  postBuild = ''
    rm $out/share/dbus-1/services/app.drey.Highscore.service
    sed "s|Exec=.*/highscore|Exec=$out/bin/highscore|" \
      ${highscore-unwrapped}/share/dbus-1/services/app.drey.Highscore.service \
      > $out/share/dbus-1/services/app.drey.Highscore.service

    gappsWrapperArgsHook

    makeWrapper ${highscore-unwrapped}/bin/highscore $out/bin/highscore \
      "''${gappsWrapperArgs[@]}" \
      --prefix XDG_DATA_DIRS : $out/share/gsettings-schemas/${highscore-unwrapped.name} \
      --set HIGHSCORE_CORES_DIR $out/lib/highscore/cores
  '';
}
