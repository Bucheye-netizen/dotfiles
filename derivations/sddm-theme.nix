{ pkgs }:

let
  image = pkgs.fetchurl {
    url = "https://images3.alphacoders.com/367/36767.jpg";
    sha256 = "sha256-yO4w+RsMM4Xpcn4kG0htPJu5YHZMt/pxk2PUiHa+j/A=";
  };
in pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchFromGitHub {
		owner = "MarianArlt";
    repo = "sddm-sugar-dark";
    rev = "ceb2c455663429be03ba62d9f898c571650ef7fe";
    sha256 = "0153z1kylbhc9d12nxy9vpn0spxgrhgy36wy37pk6ysq7akaqlvy";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
    cd $out/
    rm Background.jpg
    cp -r ${image} $out/Background.jpg
  '';
}
