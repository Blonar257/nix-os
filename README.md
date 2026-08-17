# nixos-config

Meine NixOS-Konfiguration — ein einziges Repository fuer alle meine Geraete.
Systemkonfiguration UND App-Konfiguration (via Home Manager) sind hier deklarativ
festgehalten und per `flake.lock` exakt versioniert.

## Auf diesem Geraet anwenden

    sudo nixos-rebuild switch --flake ~/nixos-config#nixos

(Das `#nixos` bezieht sich auf den Eintrag `nixosConfigurations.nixos` in
`flake.nix`.)

## Auf ein NEUES Geraet mitnehmen

1. NixOS installieren (nur die Basis, ohne weitere Konfiguration).
2. Dieses Repo klonen:
       git clone <url> ~/nixos-config
3. Neuen Host anlegen:
   - `hosts/<name>/` erstellen
   - `hardware-configuration.nix` auf dem Geraet mit
     `sudo nixos-generate-config --show-hardware-config` erzeugen und hineinkopieren
   - `configuration.nix` anpassen (Hostname, Bootloader, Hardware-Spezifisches)
   - in `flake.nix` einen Eintrag `nixosConfigurations.<name> = ...` ergaenzen
4. Anwenden:
       sudo nixos-rebuild switch --flake ~/nixos-config#<name>

Gemeinsame Einstellungen (die auf ALLEN Geraeten gleich sein sollen) kann man
spaeter in einen `modules/`-Ordner auslagern und von jedem Host importieren.

## Struktur

    flake.nix                  Inputs + welche Geraete es gibt
    flake.lock                 eingefrorene Versionen (immer mit einchecken!)
    hosts/nixos/               dieser Rechner
      configuration.nix        Systemkonfiguration
      hardware-configuration.nix  maschinenspezifisch (nicht kopieren!)
      home.nix                 Home-Manager: App-Konfigurationen

## Geheimnisse

Passwoerter, SSH-Keys und Tokens gehoeren NICHT hier rein. Dafuer spaeter
`agenix` oder `sops-nix` verwenden (verschluesselt, trotzdem eincheckbar).
