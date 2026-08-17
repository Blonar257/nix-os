# Home-Manager-Konfiguration fuer den Benutzer "blonar".
# Hier kommt ALLES rein, was deine installierten Apps KONFIGURIERT:
# Editor, Shell, Git, Terminal, Desktop-Apps, Dotfiles, etc.
# Das ist der Teil, der dein Setup auf einem anderen Geraet identisch macht.

{ config, pkgs, lazyvim, ... }:

{
  home.username = "blonar";
  home.homeDirectory = "/home/blonar";
  home.stateVersion = "26.05";

  # Home Manager verwaltet und installiert sich selbst.
  programs.home-manager.enable = true;

  # ===== Persoenliche Pakete (User-Ebene) =====
  home.packages = with pkgs; [
    zed-editor   # Zed-Editor
    ghostty      # Terminal-Emulator
    go           # Go-Toolchain
    rustup       # Rust-Toolchain-Manager (Hinweis zu NixOS siehe unten)
    gcc          # C-Compiler (fuer Neovim/Treesitter, Go-cgo, Rust-Linker)
    gnumake      # Build-Tool (gehoert zum C-Compiler-Setup)
    fd           # Schnelle Datei-Suche (Alternative zu find)
    fzf          # Fuzzy-Finder (interaktive Suche, auch in Neovim/LazyVim nutzbar)
    gnugrep      # Klassische Textsuche (im NixOS-Basissystem ohnehin enthalten)
    ripgrep      # Blitzschnelle Regex-Textsuche (rg, Alternative zu grep)
    pkgs."gnome-extension-manager"  # GNOME-App zum Installieren/Verwalten von Shell-Extensions (nixpkgs-Name, frueher "extension-manager")
  ];

  # Hinweis zu rustup auf NixOS: rustup selbst laeuft problemlos, aber die von
  # rustup heruntergeladenen Toolchains sind glibc-gelinkt und finden auf NixOS
  # den dynamischen Linker evtl. nicht. Falls `rustc`/`cargo` nach
  # `rustup toolchain install` nicht starten, einfach Bescheid geben - dann
  # aktivieren wir nix-ld oder nutzen die Nix-native Variante (pkgs.cargo/rustc
  # bzw. fenix). Der Eintrag bleibt trotzdem, weil rustup der gewuenschte
  # Standard-Weg fuer die Toolchain-Verwaltung ist.

  # ===== Git =====
  programs.git = {
    enable = true;
    settings = {
      user.name = "Stefan Schrage";
      user.email = "stefan.schrage@googlemail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # ===== GitHub CLI =====
  programs.gh = {
    enable = true;
    # Optional: gh als Credential-Helper fuer git einrichten
    # gitCredentialHelper.enable = true;
  };

  # ===== Neovim + LazyVim =====
  programs.neovim = {
    enable = true;
    defaultEditor = true;  # $EDITOR zeigt auf nvim
    vimAlias = true;       # "vim" oeffnet nvim
  };

  # LazyVim-Starter als ~/.config/nvim einbinden.
  # lazy.nvim verwaltet die Plugins zur Laufzeit (das ist LazyVims Arbeitsweise);
  # die Konfiguration selbst ist damit deklarativ im Repo verankert.
  xdg.configFile."nvim".source = lazyvim;

  # ===== VS Code (Open-Source-Build "Code - OSS" aus nixpkgs) =====
  # Das Microsoft-gebrandete VS Code ist in nixpkgs nicht enthalten (Lizenz).
  # pkgs.vscode ist der Open-Source-Build, funktional identisch.
  programs.vscode = {
    enable = true;
    # Erweiterungen deklarativ ergaenzen (spaeter):
    # profiles.default.extensions = with pkgs.vscode-extensions; [
    #   golang.go
    #   rust-lang.rust-analyzer
    # ];
    profiles.default.userSettings = {
      "editor.fontSize" = 14;
      "editor.minimap.enabled" = true;
      "telemetry.telemetryLevel" = "off";
    };
  };

  # ===== Lazygit =====
  programs.lazygit.enable = true;

  # ===== Shell-Aliase =====
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -lah";
      hm = "home-manager switch --flake ~/nixos-config";
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-config";
    };
  };

  # Weitere Ideen (spaeter):
  #   programs.starship.enable = true;      # schoener Shell-Prompt
  #   programs.ghostty = { ... };           # Ghostty-Konfiguration
  #   programs.zed-editor = { ... };        # Zed-Konfiguration
  #   dconf.settings = { ... };             # GNOME-Einstellungen
  #   home.file."...".source = ...;         # eigene Dotfiles einbinden
}
