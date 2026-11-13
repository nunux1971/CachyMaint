# Cachy Maint

Application graphique de maintenance pour **CachyOS** (et Arch Linux), écrite en Python avec PySide6 (Qt 6), pour s'intégrer naturellement à KDE Plasma.

## Fonctionnalités

| Page | Contenu |
|---|---|
| **Tableau de bord** | État du système en un coup d'œil : mises à jour, paquets orphelins, services en échec, erreurs du journal, fichiers `.pacnew`, taille du cache, redémarrage nécessaire, date de la dernière maintenance, remplissage des disques. Bouton **Maintenance complète**. |
| **Mises à jour** | Liste des mises à jour (dépôts, AUR, Flatpak), mise à jour en un clic, AUR dans un terminal, classement des miroirs, micrologiciels (fwupd). |
| **Nettoyage** | Cache pacman (`paccache`), orphelins, journaux systemd, miniatures, cache personnel ancien, cache de compilation AUR, Flatpak inutilisés. |
| **Diagnostic** | Services en échec, erreurs depuis le démarrage, santé SMART, état Btrfs, intégrité des paquets, fusion des `.pacnew` (`pacdiff`), plus gros paquets, déverrouillage de pacman. |
| **Matériel** | Inventaire façon `inxi` : système et ordonnanceur (sched-ext), carte mère et BIOS, Secure Boot, processeur (cœurs, cache, pilote de fréquence, **niveau x86-64-v3/v4** pour les dépôts optimisés CachyOS), mémoire et zram, cartes graphiques (pilote, VRAM, OpenGL, Mesa), écrans, audio, réseau, disques et partitions, batterie, USB. **Températures et ventilateurs en direct.** Rapport copiable ou enregistrable en texte, détails des barrettes mémoire, rapport `inxi` complet si installé. |
| **Sécurité** | Instantanés snapper / Timeshift, vérification Btrfs (scrub), accès à Btrfs Assistant. |
| **Historique** | Journal de toutes les opérations (`~/.local/state/cachy-maint/maintenance.log`). |

La **maintenance complète** enchaîne : instantané de sécurité → mise à jour des dépôts → suppression des orphelins → nettoyage du cache → réduction des journaux → mise à jour des Flatpak, puis propose la mise à jour AUR et signale si un redémarrage est nécessaire.

## Installation

```bash
git clone https://github.com/nunux1971/CachyMaint.git
cd CachyMaint
./install.sh
```

Puis lance **Cachy Maint** depuis le menu des applications (ou `cachy-maint-gui` dans un terminal).

L'installateur ajoute les dépendances (`pyside6`, `pacman-contrib`, `smartmontools`, `pciutils`, `usbutils`, `dmidecode`), le module administrateur et la règle polkit. Optionnel : `fwupd` (micrologiciels), `meld` (fusion graphique des `.pacnew`).

Désinstallation : `./uninstall.sh`

## Mise à jour

```bash
git pull && ./install.sh
```

Relancer `install.sh` est nécessaire quand le module administrateur évolue (c'est le cas en 2.1 pour les barrettes mémoire).

## Sécurité et droits administrateur

L'interface tourne en utilisateur normal. Les opérations qui exigent les droits root passent par `pkexec` et un petit programme, `cachy-maint-helper`, installé dans `/usr/local/libexec` (propriété de root) :

- il n'accepte qu'une **liste fermée d'actions**, sans argument libre ;
- la règle polkit `io.github.cachymaint.policy` garde l'autorisation quelques minutes (`auth_admin_keep`) pour éviter de retaper le mot de passe à chaque étape.

## Version terminal

Le dossier [`terminal/`](terminal/) contient une version en ligne de commande avec menu, sans dépendance :

```bash
cd terminal && ./install.sh
cachy-maint            # menu
cachy-maint --check    # bilan sans modification
cachy-maint --auto     # maintenance complète
```

## Structure

```
cachy-maint-gui              application graphique (Python / PySide6)
cachy-maint-helper           actions administrateur (appelé via pkexec)
io.github.cachymaint.policy  règle polkit
cachy-maint.desktop          entrée du menu des applications
install.sh / uninstall.sh    installation / désinstallation
terminal/                    version terminal (Bash)
```
