#!/usr/bin/env bash
# Désinstallation de Cachy Maint (l'historique ~/.local/state/cachy-maint est conservé)
sudo rm -f /usr/local/libexec/cachy-maint-helper /usr/share/polkit-1/actions/io.github.cachymaint.policy
rm -f "$HOME/.local/bin/cachy-maint-gui" "$HOME/.local/share/applications/cachy-maint.desktop"
echo "✔ Cachy Maint désinstallé."
