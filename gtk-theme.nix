{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  name = "gtk-theme";
  src = pkgs.fetchFromGitHub {
    owner = "TheGreatMcPain";
    repo = "gruvbox-material-gtk";
    rev = "808959bcfe8b9409b49a7f92052198f0882ae8bc";
    sha256 = "sha256-NHjE/HI/BJyjrRfoH9gOKIU8HsUIBPV9vyvuW12D01M=";
  };
  propagatedUserEnvPkgs = [ pkgs.gtk-engine-murrine ];

  installPhase = ''
    		runHook preInstall
    		mkdir -p $out/share/themes/gruvbox-material-dark
        rm -rf README.md LICENSE icons themes/Gruvbox-Material-Dark-HIDPI
        cp -r themes/Gruvbox-Material-Dark/* $out/share/themes/gruvbox-material-dark
    		runHook preInstall
  '';
}
