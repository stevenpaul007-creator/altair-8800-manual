#!/usr/bin/env bash
#
# Build the Altair 8800 operator's manual (Chinese translation) as HTML and PDF.
#
# Usage:
#   ./build.sh            # build both HTML and PDF
#   ./build.sh html        # build only HTML
#   ./build.sh pdf         # build only PDF (simplepdf / WeasyPrint)
#
# Requirements:
#   - Python virtual environment at ./.venv (created with python -m venv .venv
#     and pip install -r Altair8800-zh/requirements.txt).
#   - The simplepdf PDF builder uses WeasyPrint (no LaTeX toolchain required).
#
set -euo pipefail

# Resolve the directory that contains this script (repo root).
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV="$ROOT/.venv"
DOCS="$ROOT/Altair8800-zh"

# Prefer the project virtual environment if it exists.
if [ -d "$VENV" ]; then
    export PATH="$VENV/bin:$PATH"
fi

if ! command -v sphinx-build >/dev/null 2>&1; then
    echo "Error: sphinx-build not found. Activate the venv or install Sphinx." >&2
    exit 1
fi

TARGET="${1:-all}"

build_html() {
    echo ">> Building HTML..."
    sphinx-build -M html "$DOCS/source" "$DOCS/build"
}

build_pdf() {
    echo ">> Building PDF (simplepdf / WeasyPrint)..."
    sphinx-build -M simplepdf "$DOCS/source" "$DOCS/build"
}

case "$TARGET" in
    html) build_html ;;
    pdf)  build_pdf ;;
    all)  build_html; build_pdf ;;
    *) echo "Unknown target: $TARGET (use html|pdf|all)" >&2; exit 1 ;;
esac

echo "Done. Output:"
echo "  HTML : $DOCS/build/html/index.html"
echo "  PDF  : $DOCS/build/simplepdf/"
