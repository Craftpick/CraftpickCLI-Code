# Installateurs CraftpickAI Code

Ces scripts clonent `https://github.com/Craftpick/CraftpickCLI-Code`, installent les dépendances de production du dossier `Code/`, puis créent la commande `craftpick-code`.

- Linux/macOS : `bash install.sh`, puis lancez `craftpick-code` (ajoutez `~/.local/bin` au `PATH` si nécessaire).
- Windows : `install.bat`, puis rouvrez PowerShell et lancez `craftpick-code`.

Pour tester le code présent dans ce dossier avant de le publier sur GitHub : `install.bat --local` (Windows) ou `bash install.sh --local` (Linux/macOS).

Prérequis : Git et Node.js 20+.
