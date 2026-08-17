{
  description = "NixOS-Konfiguration (portabel) - ein Repo fuer alle meine Geraete";

  inputs = {
    # NixOS 26.05 (stabiler Release-Zweig)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    # Home Manager verwaltet die Konfiguration deiner Apps (Dotfiles & Co.).
    # "follows" sorgt dafuer, dass Home Manager exakt dieselbe nixpkgs-Version
    # nutzt wie das System -> keine Versionskonflikte.
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
  in {
    # Ein Eintrag pro Geraet.
    # Fuer ein zweites Geraet hier z.B. "nixosConfigurations.laptop = ..." ergaenzen
    # (mit eigenem hosts/laptop/-Ordner und eigener hardware-configuration.nix).
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./hosts/nixos/configuration.nix
        home-manager.nixosModules.default
      ];
    };
  };
}
