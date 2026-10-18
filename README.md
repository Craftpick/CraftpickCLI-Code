# CraftpickAI Code CLI

Agent de développement local-first pour Windows, Linux et macOS, exécuté avec Node.js et votre serveur Ollama.

L’interface terminal plein écran adopte un style minimal : en-tête compact, journal conversationnel, prompt séparé et barre d’état. Tapez `/` pour ouvrir le sélecteur de commandes, utilisez ↑/↓ pour choisir, puis `Tab` ou Entrée pour compléter. Utilisez `?` pour les raccourcis, et `Esc` (ou `Ctrl+C`) pour interrompre une requête en cours.

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

Les alias `--model gemma4` et `/model gemma4` sélectionnent `gemma4:31b-cloud`. Les alias `gpt` et `gpt-oss` sélectionnent `gpt-oss:120b-cloud`.

La configuration se trouve dans `~/.craftpick-code/config.json` (Windows : `%USERPROFILE%\.craftpick-code\config.json`). Utilisez `CRAFTPICK_OLLAMA_URL` et `CRAFTPICK_MODEL` pour la surcharger au premier lancement.

## Commandes

- `/help` : aide
- `/skills`, `/skill <nom>` : voir ou activer/désactiver les skills
- `/agents <mission>` : lancer trois sous-agents d’analyse (architecture, implémentation, qualité)
- `/model <nom>` : sélectionner le modèle Ollama
- `/init` : créer `CRAFTPICK.md` dans le projet
- `/review <demande>` : revue de code
- `/config`, `/theme`, `/clear`, `/exit`

## Sécurité

Les lectures, écritures et commandes restent confinées au workspace démarré. Toute écriture de fichier ou commande shell demande une confirmation explicite. Les skills peuvent être ajoutés dans `.craftpick/skills/*.md` (projet) ou `~/.craftpick-code/skills/*.md` (utilisateur).

Les sous-agents sont des appels Ollama parallèles sans outils d’écriture ni terminal. Ils reçoivent la mission, le contexte récent et un aperçu local du projet ; leurs tokens comptent dans la limite quotidienne.
