#!/usr/bin/env bash
# Installe cachy-maint pour l'utilisateur courant (aucun droit root requis)
set -e
SRC="$(cd "$(dirname "$0")" && pwd)"
BIN="$HOME/.local/bin"
APPS="$HOME/.local/share/applications"
mkdir -p "$BIN" "$APPS"

install -m755 "$SRC/cachy-maint" "$BIN/cachy-maint"

# Choix du terminal pour le raccourci du menu
TERM_CMD="konsole -e"
for t in konsole kitty alacritty gnome-terminal xfce4-terminal foot; do
  if command -v "$t" >/dev/null; then
    case $t in
      gnome-terminal) TERM_CMD="gnome-terminal --" ;;
      *)              TERM_CMD="$t -e" ;;
    esac
    break
  fi
done

cat >"$APPS/cachy-maint.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=Maintenance CachyOS
Comment=Mettre à jour, nettoyer et vérifier le système
Exec=$TERM_CMD $BIN/cachy-maint
Icon=system-software-update
Terminal=false
Categories=System;Settings;
Keywords=update;maintenance;pacman;cachyos;nettoyage;
EOF

update-desktop-database "$APPS" 2>/dev/null || true

echo "✔ cachy-maint installé dans $BIN"
echo "✔ Raccourci « Maintenance CachyOS » ajouté au menu des applications"

# Outils optionnels recommandés
missing=()
for p in pacman-contrib:paccache smartmontools:smartctl fwupd:fwupdmgr; do
  command -v "${p#*:}" >/dev/null || missing+=("${p%%:*}")
done
if ((${#missing[@]})); then
  echo
  echo "Paquets conseillés non installés : ${missing[*]}"
  echo "  sudo pacman -S ${missing[*]}"
fi

case ":$PATH:" in *":$BIN:"*) ;; *)
  echo; echo "⚠ $BIN n'est pas dans ton PATH : ouvre un nouveau terminal ou ajoute-le." ;;
esac
