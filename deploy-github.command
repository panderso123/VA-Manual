#!/bin/bash
# ============================================================
#  Publish the VA Operations Manual to GitHub Pages (public).
#  HOW TO RUN: double-click this file in Finder.
#  Requires the GitHub CLI (gh). If you don't have it:
#     brew install gh   then   gh auth login
#  Result: a public link like https://panderso123.github.io/va-manual/
# ============================================================
set -e
cd "$(dirname "$0")"

REPO="va-manual"          # change this if you want a different URL slug
USER="panderso123"        # your GitHub username

echo "→ Checking GitHub CLI..."
if ! command -v gh >/dev/null 2>&1; then
  echo "❌ GitHub CLI (gh) not found."
  echo "   Install it with:  brew install gh"
  echo "   Then run:         gh auth login"
  echo "   ...and double-click this file again."
  read -p "Press enter to close."
  exit 1
fi

echo "→ Preparing files..."
git init -q 2>/dev/null || true
git add index.html VA_Operations_Manual.html
git commit -q -m "VA Operations Manual" || echo "  (nothing new to commit)"
git branch -M main

echo "→ Creating public repo and pushing..."
gh repo create "$USER/$REPO" --public --source=. --remote=origin --push 2>/dev/null \
  || { git remote add origin "https://github.com/$USER/$REPO.git" 2>/dev/null || true; git push -u origin main; }

echo "→ Turning on GitHub Pages..."
gh api -X POST "repos/$USER/$REPO/pages" -f "source[branch]=main" -f "source[path]=/" >/dev/null 2>&1 \
  || echo "  (Pages may already be on, or enable it manually in repo Settings → Pages)"

echo ""
echo "✅ Done. Your public link (give Pages ~1 minute to go live):"
echo "   https://$USER.github.io/$REPO/"
echo ""
read -p "Press enter to close."
