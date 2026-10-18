# CraftpickAI Code CLI

Agent de développement local-first pour Windows, Linux et macOS, exécuté avec Node.js et votre serveur Ollama.

## Installation

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/Craftpick/CraftpickCLI-Code/main/installer/install.sh | bash
```

Ou clonez le dépôt et exécutez `bash installer/install.sh`.

### Windows

```bat
git clone https://github.com/Craftpick/CraftpickCLI-Code.git
cd CraftpickCLI-Code
installer\install.bat
```

Prérequis : Git et Node.js 20+.

## Utilisation

```bash
craftpick-code
craftpick-code ./mon-projet
craftpick-code --model gpt-oss:120b-cloud
craftpick-code -p "analyse le projet et propose un plan"
```

La configuration se trouve dans `~/.craftpick-code/config.json` (Windows : `%USERPROFILE%\.craftpick-code\config.json`). Utilisez `CRAFTPICK_OLLAMA_URL` et `CRAFTPICK_MODEL` pour la surcharger au premier lancement.

## Commandes

- `/help` : aide
- `/skills`, `/skill <nom>` : voir ou activer/désactiver les skills
- `/model <nom>` : sélectionner le modèle Ollama
- `/init` : créer `CRAFTPICK.md` dans le projet
- `/review <demande>` : revue de code
- `/config`, `/theme`, `/clear`, `/exit`

## Sécurité

Les lectures, écritures et commandes restent confinées au workspace démarré. Toute écriture de fichier ou commande shell demande une confirmation explicite. Les skills peuvent être ajoutés dans `.craftpick/skills/*.md` (projet) ou `~/.craftpick-code/skills/*.md` (utilisateur).
