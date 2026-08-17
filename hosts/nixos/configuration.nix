# Systemkonfiguration fuer dieses Geraet.
# Hinweis: Geraete-spezifische Dinge (Festplatten, Treiber) stehen in
# hardware-configuration.nix und werden NICHT auf andere Geraete kopiert.

{ config, pkgs, lazyvim, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ===== Bootloader =====
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;
  # UUIDs statt blkid-Probing (erforderlich fuer btrfs-Subvolumes)
  boot.loader.grub.fsIdentifier = "provided";

  # Neuester Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ===== Netzwerk =====
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ===== Zeit & Sprache =====
  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "de_DE.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # ===== Desktop (GNOME, Wayland) =====
  # Hinweis: GNOME 50 laeuft immer auf Wayland; eine eigene Wayland-Option
  # (gdm.wayland) gibt es nicht mehr, sie ist wirkungslos geworden.
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };
  console.keyMap = "de";

  # Wayland: Electron-/Chromium-Apps (VS Code & Co.) nativ auf Wayland
  # statt per XWayland laufen lassen.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # ===== Drucker =====
  services.printing.enable = true;

  # ===== Flatpak =====
  # Aktiviert den Flatpak-D-Bus-Dienst; Apps installiert man danach mit
  # `flatpak install flathub <app>`. Die Flathub-Remote wird beim ersten
  # `flatpak remote-add` (siehe unten) eingerichtet.
  services.flatpak.enable = true;

  # ===== Sound (PipeWire) =====
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ===== Benutzer =====
  users.users."blonar" = {
    isNormalUser = true;
    description = "Stefan Schrage";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  # ===== Programme (systemweit) =====
  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    flatpak  # CLI zum Verwalten von Flatpak-Apps (der Dienst ist oben aktiviert)
  ];

  # ===== Home Manager =====
  # Hier wird die Konfiguration DEINER Apps (Dotfiles, Editor, Shell, ...)
  # angebunden. Die eigentliche Konfiguration liegt in ./home.nix.
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    # Reicht den lazyvim-Quellpfad aus flake.nix an die Home-Manager-Module weiter.
    extraSpecialArgs = { inherit lazyvim; };
    users.blonar = import ./home.nix;
  };

  # ===== Nix-Einstellungen =====
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
