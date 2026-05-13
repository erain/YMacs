#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "setup-macos.sh is only for macOS" >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  cat >&2 <<'EOF'
Homebrew is required. Install it first:
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
EOF
  exit 1
fi

echo "==> Installing Homebrew dependencies"
brew bundle --file "$repo_dir/Brewfile"
hash -r

echo "==> Installing Grip preview helper"
if pipx list --short 2>/dev/null | awk '{print $1}' | grep -Fxq grip; then
  echo "grip already installed with pipx"
else
  # Force public PyPI because some machines have a private pip index configured.
  pipx install --backend pip --index-url https://pypi.org/simple grip
fi

echo "==> Installing Hunspell dictionaries"
mkdir -p "$HOME/Library/Spelling"
base_url="https://raw.githubusercontent.com/LibreOffice/dictionaries/master/en"
for dict in en_CA en_US; do
  aff="$HOME/Library/Spelling/$dict.aff"
  dic="$HOME/Library/Spelling/$dict.dic"
  [[ -f "$aff" ]] || curl -fsSL "$base_url/$dict.aff" -o "$aff"
  [[ -f "$dic" ]] || curl -fsSL "$base_url/$dict.dic" -o "$dic"
done

echo "==> Installing emacs-service helper"
mkdir -p "$HOME/bin"
ln -sf "$repo_dir/bin/emacs-service" "$HOME/bin/emacs-service"

if [[ ! -f "$HOME/Library/LaunchAgents/com.yiyu.emacs-daemon.plist" ]]; then
  "$HOME/bin/emacs-service" install
else
  echo "LaunchAgent plist already exists: $HOME/Library/LaunchAgents/com.yiyu.emacs-daemon.plist"
fi

cat <<EOF

Done.

Next steps:
  1. Make sure ~/bin and ~/.local/bin are on PATH.
  2. Start Emacs daemon: emacs-service start
  3. Open GUI Emacs once and run: M-x nerd-icons-install-fonts
  4. For Go support: go install golang.org/x/tools/gopls@latest
                     go install golang.org/x/tools/cmd/goimports@latest
  5. For Python LSP: pip install -U 'python-lsp-server[all]'

EOF
