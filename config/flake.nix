{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland-qtutils.url = "github:hyprwm/hyprland-qtutils";
    hyprswitch.url = "github:h3rmt/hyprswitch";
  };

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [./configuration.nix];
    };
  };
}
