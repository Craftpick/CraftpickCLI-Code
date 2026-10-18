#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/Craftpick/CraftpickCLI-Code.git"
INSTALL_ROOT="${CRAFTPICK_INSTALL_DIR:-$HOME/.local/share/craftpick-code}"
BIN_DIR="${CRAFTPICK_BIN_DIR:-$HOME/.local/bin}"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo
echo "  CraftpickAI Code — installation"
echo "  --------------------------------"

command -v git >/dev/null 2>&1 || { echo "Erreur : Git est requis." >&2; exit 1; }
command -v node >/dev/null 2>&1 || { echo "Erreur : Node.js 20+ est requis." >&2; exit 1; }
command -v npm >/dev/null 2>&1 || { echo "Erreur : npm est introuvable." >&2; exit 1; }
node -e "process.exit(Number(process.versions.node.split('.')[0]) >= 20 ? 0 : 1)" || { echo "Erreur : Node.js 20+ est requis." >&2; exit 1; }

if [[ "${1:-}" == "--local" ]]; then
  INSTALL_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
  APP_DIR="$INSTALL_ROOT/Code"
  [[ -f "$APP_DIR/package.json" ]] || { echo "Erreur : sources locales introuvables : $APP_DIR" >&2; exit 1; }
  echo "[1/4] Sources locales utilisées"
else
  echo "[1/4] Récupération de CraftpickAI Code"
  if [[ -d "$INSTALL_ROOT/.git" ]]; then
    git -C "$INSTALL_ROOT" pull --ff-only
  elif [[ -e "$INSTALL_ROOT" ]]; then
    echo "Erreur : $INSTALL_ROOT existe mais n’est pas un dépôt Git. Supprimez-le ou choisissez CRAFTPICK_INSTALL_DIR." >&2
    exit 1
  else
    git clone --depth 1 "$REPO_URL" "$INSTALL_ROOT"
  fi
  APP_DIR="$INSTALL_ROOT/Code"
  [[ -f "$INSTALL_ROOT/CLI/Code/package.json" ]] && APP_DIR="$INSTALL_ROOT/CLI/Code"
  [[ -f "$INSTALL_ROOT/package.json" ]] && APP_DIR="$INSTALL_ROOT"
fi

[[ -f "$APP_DIR/package.json" ]] || { echo "Erreur : package.json introuvable dans le dépôt." >&2; exit 1; }
echo "[2/4] Installation des dépendances Node.js"
if [[ -f "$APP_DIR/package-lock.json" ]]; then
  npm ci --omit=dev --prefix "$APP_DIR"
else
  npm install --omit=dev --prefix "$APP_DIR"
fi

echo "[3/4] Création de la commande craftpick-code"
mkdir -p "$BIN_DIR"
cat > "$BIN_DIR/craftpick-code" <<EOF
#!/usr/bin/env bash
exec node "$APP_DIR/bin/craftpick-code.mjs" "\$@"
EOF
chmod +x "$BIN_DIR/craftpick-code"

echo "[4/4] Vérification du PATH"
echo
echo "  Installation terminée."
case ":$PATH:" in
  *":$BIN_DIR:"*) echo "  Lancez : craftpick-code" ;;
  *)
    echo "  Ajoutez ceci à votre profil shell puis ouvrez un nouveau terminal :"
    echo "  export PATH=\"$BIN_DIR:\$PATH\""
    echo "  Ensuite lancez : craftpick-code"
    ;;
esac
