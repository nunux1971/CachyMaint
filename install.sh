#!/usr/bin/env bash
# Installation de Cachy Maint (interface graphique)
set -e
cd "$(dirname "$0")"
[[ $EUID -eq 0 ]] && { echo "Lance install.sh en utilisateur normal (sudo sera demandé)."; exit 1; }

echo "➜ Dépendances (PySide6, pacman-contrib, smartmontools)…"
sudo pacman -S --needed pyside6 pacman-contrib smartmontools

echo "➜ Module administrateur et règle polkit…"
sudo install -Dm755 -o root -g root cachy-maint-helper /usr/local/libexec/cachy-maint-helper
sudo install -Dm644 -o root -g root io.github.cachymaint.policy \
     /usr/share/polkit-1/actions/io.github.cachymaint.policy

echo "➜ Application…"
install -Dm755 cachy-maint-gui "$HOME/.local/bin/cachy-maint-gui"
install -Dm644 cachy-maint.desktop "$HOME/.local/share/applications/cachy-maint.desktop"
sed -i "s|^Exec=.*|Exec=$HOME/.local/bin/cachy-maint-gui|" "$HOME/.local/share/applications/cachy-maint.desktop"
update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true

echo
echo "✔ Cachy Maint est installé : cherche « Cachy Maint » dans le menu des applications."
command -v fwupdmgr >/dev/null || echo "  (optionnel) Pour les micrologiciels : sudo pacman -S fwupd"
command -v meld >/dev/null     || echo "  (optionnel) Pour fusionner les .pacnew en graphique : sudo pacman -S meld"
