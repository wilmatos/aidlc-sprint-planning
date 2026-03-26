#!/usr/bin/env bash
# copy-common.sh — copies common/ files into each implementation package,
# prepending the appropriate frontmatter for the target.
#
# Usage:
#   ./scripts/copy-common.sh <target>
#
# Targets: power, skill, cli, all

set -euo pipefail

COMMON_DIR="$(cd "$(dirname "$0")/../common" && pwd)"

# ---------------------------------------------------------------------------
# Title derivation: kebab-case filename → Title Case display name
# e.g. "complexity-rubric" → "AI-DLC Complexity Rubric"
# ---------------------------------------------------------------------------
derive_title() {
  local stem="${1%.md}"          # strip .md
  local words
  # Replace hyphens with spaces, title-case each word
  words=$(echo "$stem" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}')
  echo "AI-DLC $words"
}

# ---------------------------------------------------------------------------
# Frontmatter builders
# ---------------------------------------------------------------------------

# Power: title only (inclusion managed by POWER.md)
power_frontmatter() {
  local title
  title=$(derive_title "$1")
  printf -- '---\ntitle: "%s"\n---\n' "$title"
}

# CLI: title + inclusion + priority
# Defaults: inclusion=manual, priority=medium
# Override specific files as needed
cli_frontmatter() {
  local filename="$1"
  local title
  title=$(derive_title "$filename")
  local inclusion="manual"
  local priority="medium"
  case "$filename" in
    workflow.md)
      inclusion="always"; priority="high" ;;
  esac
  printf -- '---\ntitle: "%s"\ninclusion: %s\npriority: %s\n---\n' "$title" "$inclusion" "$priority"
}

# ---------------------------------------------------------------------------
# Helper: prepend frontmatter and copy
# ---------------------------------------------------------------------------
copy_with_frontmatter() {
  local src="$1"
  local dest="$2"
  local frontmatter="$3"

  mkdir -p "$(dirname "$dest")"

  if [[ -n "$frontmatter" ]]; then
    { printf '%s\n\n' "$frontmatter"; cat "$src"; } > "$dest"
  else
    cp "$src" "$dest"
  fi

  echo "  ✓ $(basename "$src") → $dest"
}

# ---------------------------------------------------------------------------
# Power
# ---------------------------------------------------------------------------
copy_power() {
  local dest_dir="AgentDevAidlcPower/steering"
  local templates_dir="AgentDevAidlcPower/templates"
  echo "→ Copying to Power ($dest_dir)"

  for src in "$COMMON_DIR"/*.md; do
    local filename
    filename=$(basename "$src")
    copy_with_frontmatter "$src" "$dest_dir/$filename" "$(power_frontmatter "$filename")"
  done

  for src in "$COMMON_DIR"/templates/*.md; do
    local filename
    filename=$(basename "$src")
    copy_with_frontmatter "$src" "$templates_dir/$filename" ""
  done

  echo "  ✓ Power steering and template files updated"
}

# ---------------------------------------------------------------------------
# Skill
# ---------------------------------------------------------------------------
copy_skill() {
  local dest_dir="AgentDevAidlcSkill/aidlc-mob-elaboration/references"
  local assets_dir="AgentDevAidlcSkill/aidlc-mob-elaboration/assets"
  echo "→ Copying to Skill ($dest_dir)"

  for src in "$COMMON_DIR"/*.md; do
    local filename
    filename=$(basename "$src")
    copy_with_frontmatter "$src" "$dest_dir/$filename" ""
  done

  for src in "$COMMON_DIR"/templates/*.md; do
    local filename
    filename=$(basename "$src")
    copy_with_frontmatter "$src" "$assets_dir/$filename" ""
  done

  echo "  ✓ Skill reference and asset files updated"
}

# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------
copy_cli() {
  local dest_dir="AgentDevAidlcCLI/.kiro/steering"
  local templates_dir="AgentDevAidlcCLI/.kiro/templates"
  echo "→ Copying to CLI ($dest_dir)"

  for src in "$COMMON_DIR"/*.md; do
    local filename
    filename=$(basename "$src")
    copy_with_frontmatter "$src" "$dest_dir/aidlc-$filename" "$(cli_frontmatter "$filename")"
  done

  for src in "$COMMON_DIR"/templates/*.md; do
    local filename
    filename=$(basename "$src")
    copy_with_frontmatter "$src" "$templates_dir/$filename" ""
  done

  echo "  ✓ CLI steering and template files updated"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
TARGET="${1:-all}"

case "$TARGET" in
  power) copy_power ;;
  skill) copy_skill ;;
  cli)   copy_cli ;;
  all)
    copy_power
    copy_skill
    copy_cli
    ;;
  *)
    echo "Unknown target: $TARGET. Use: power | skill | cli | all"
    exit 1
    ;;
esac

echo ""
echo "✅ Done"
