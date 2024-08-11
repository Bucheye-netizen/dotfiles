{ pkgs, ... }:

let colors = import ../util/colors.nix;
in {
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };

    settings = {
      global = {
        notification_limit = 5;
        width = 300;
        height = 300;
        offset = "30x50";
        origin = "top-right";
        transparency = 10;
        frame_color = "${colors.gruv.light4}";
        frame_width = 1;
        background = "${colors.gruv.dark1}";
        corner_radius = 3;
      };
    };
  };
}
