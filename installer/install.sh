#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/Craftpick/CraftpickCLI-Code.git"
INSTALL_ROOT="${CRAFTPICK_INSTALL_DIR:-$HOME/.local/share/craftpick-code}"
BIN_DIR="${CRAFTPICK_BIN_DIR:-$HOME/.local/bin}"

command -v git >/dev/null 2>&1 || { echo "Git est requis." >&2; exit 1; }
command -v node >/dev/null 2>&1 || { echo "Node.js 20 ou plus est requis." >&2; exit 1; }
node -e "process.exit(Number(process.versions.node.split('.')[0]) >= 20 ? 0 : 1)" || { echo "Node.js 20 ou plus est requis." >&2; exit 1; }

if [ -d "$INSTALL_ROOT/.git" ]; then
  git -C "$INSTALL_ROOT" pull --ff-only
else
  rm -rf "$INSTALL_ROOT"
  git clone --depth 1 "$REPO_URL" "$INSTALL_ROOT"
fi

APP_DIR="$INSTALL_ROOT/Code"
[ -f "$INSTALL_ROOT/CLI/Code/package.json" ] && APP_DIR="$INSTALL_ROOT/CLI/Code"
[ -f "$INSTALL_ROOT/package.json" ] && APP_DIR="$INSTALL_ROOT"
[ -f "$APP_DIR/package.json" ] || { echo "Le projet CraftpickAI Code est introuvable dans le dépôt." >&2; exit 1; }
npm install --omit=dev --prefix "$APP_DIR"
mkdir -p "$BIN_DIR"
cat > "$BIN_DIR/craftpick-code" <<EOF
#!/usr/bin/env bash
exec node "$APP_DIR/bin/craftpick-code.mjs" "\$@"
EOF
chmod +x "$BIN_DIR/craftpick-code"

echo "CraftpickAI Code installé."
echo "Lancez : craftpick-code"
case ":$PATH:" in *":$BIN_DIR:"*) ;; *) echo "Ajoutez $BIN_DIR à votre PATH si nécessaire.";; esac
