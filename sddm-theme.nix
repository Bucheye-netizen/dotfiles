with import <nixpkgs> { };
let
  image = pkgs.fetchurl {
    url =
      "https://gruvbox-wallpapers.pages.dev/wallpapers/minimalistic/gruvbox_astro.jpg";
  };
in stdenv.mkDeriviation {
  name = "sddm-theme";
  src =
    fetchFromGithub { url = "https://github.com/MarianArlt/sddm-sugar-dark"; };

  dontUnpack = true;
  installPhase = ''
    mkdir -p $out
    ${unzip}/bin/unzip $src -d $out
  '';
}
