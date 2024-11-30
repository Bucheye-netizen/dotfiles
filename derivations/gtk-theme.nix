{ pkgs, ... }:

# TODO: Replace with https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme
pkgs.stdenv.mkDerivation {
  name = "gtk-theme";
  src = pkgs.fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Gruvbox-GTK-Theme";
    rev = "d064cd480a1e4802851b35bf051e48c808802c2a";
    sha256 = "";
  };
  buildInputs = with pkgs; [
    gtk-engine-murrine
    gnome.gnome-themes-extra
    sassc
  ];

  installPhase = ''
    		runHook preInstall
    		mkdir -p $out/share/themes/gruvbox-material-dark
        rm -rf README.md LICENSE icons themes/Gruvbox-Material-Dark-HIDPI
        cp -r themes/Gruvbox-Material-Dark/* $out/share/themes/gruvbox-material-dark
    		runHook preInstall
  '';
}
