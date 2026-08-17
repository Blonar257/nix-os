# Home-Manager-Konfiguration fuer den Benutzer "blonar".
# Hier kommt ALLES rein, was deine installierten Apps KONFIGURIERT:
# Editor, Shell, Git, Terminal, Desktop-Apps, Dotfiles, etc.
# Das ist der Teil, der dein Setup auf einem anderen Geraet identisch macht.

{ config, pkgs, ... }:

{
  home.username = "blonar";
  home.homeDirectory = "/home/blonar";
  home.stateVersion = "26.05";

  # Home Manager verwaltet und installiert sich selbst.
  programs.home-manager.enable = true;

  # Beispiel: Git-Konfiguration
  programs.git = {
    enable = true;
    settings = {
      user.name = "Stefan Schrage";
      user.email = "deine@email.de"; # <- hier deine E-Mail eintragen
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # Beispiel: Shell-Aliase (bash). Auskommentieren und anpassen, wenn gewuenscht.
  # programs.bash = {
  #   enable = true;
  #   shellAliases = {
  #     ll = "ls -lah";
  #     hm = "home-manager switch --flake ~/nixos-config";
  #     nrs = "sudo nixos-rebuild switch --flake ~/nixos-config";
  #   };
  # };

  # Weitere Ideen (spaeter):
  #   programs.starship.enable = true;         # schoener Shell-Prompt
  #   programs.neovim.enable = true;           # Editor + dessen Config
  #   programs.alacritty.enable = true;        # Terminal
  #   programs.vscode.enable = true;           # VS Code mit Extensions
  #   dconf.settings = { ... };                # GNOME-Einstellungen
  #   home.file."...".source = ...;            # eigene Dotfiles einbinden
}
