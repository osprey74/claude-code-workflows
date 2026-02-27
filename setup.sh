#!/bin/bash
# =============================================================================
# claude-code-workflows setup.sh
# 共通 Skills を対象プロジェクトにインストールするスクリプト
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_SRC="$SCRIPT_DIR/skills"

# 引数チェック: 対象プロジェクトのパスを受け取る
if [ $# -eq 0 ]; then
    TARGET_DIR="."
else
    TARGET_DIR="$1"
fi

# 対象ディレクトリの存在確認
if [ ! -d "$TARGET_DIR" ]; then
    echo "❌ Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

TARGET_SKILLS="$TARGET_DIR/.claude/skills"

echo "📦 Installing claude-code-workflows skills..."
echo "   Source:  $SKILLS_SRC"
echo "   Target:  $TARGET_SKILLS"
echo ""

# .claude/skills ディレクトリ作成
mkdir -p "$TARGET_SKILLS"

# 各 Skill をコピー
INSTALLED=0
SKIPPED=0

for skill_dir in "$SKILLS_SRC"/*/; do
    skill_name=$(basename "$skill_dir")

    if [ -d "$TARGET_SKILLS/$skill_name" ]; then
        echo "⏭️  Already exists: $skill_name"
        SKIPPED=$((SKIPPED + 1))
    else
        cp -r "$skill_dir" "$TARGET_SKILLS/$skill_name"
        echo "✅ Installed:      $skill_name"
        INSTALLED=$((INSTALLED + 1))
    fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Setup complete!"
echo "   Installed: $INSTALLED skill(s)"
echo "   Skipped:   $SKIPPED skill(s)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# CLAUDE.md の確認
if [ ! -f "$TARGET_DIR/CLAUDE.md" ]; then
    echo ""
    echo "⚠️  CLAUDE.md not found in '$TARGET_DIR'."
    echo "   Skills reference project-specific settings from CLAUDE.md."
    echo "   See templates/ directory for CLAUDE.md examples."
    echo ""
    echo "   Template options:"
    echo "     - templates/CLAUDE_tauri.md    (Tauri + React + TypeScript projects)"
    echo "     - templates/CLAUDE_docs.md     (Documentation-only projects)"
    echo "     - templates/CLAUDE_bot.md      (Bot / backend service projects)"
fi
