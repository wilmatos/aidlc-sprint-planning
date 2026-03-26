#!/usr/bin/env bash
# copy-common.sh — assembles distribution packages in dist/ by combining
# source files with generated copies of common/ content.
#
# Nothing is written to the source directories (AgentDevAidlcPower/,
# AgentDevAidlcSkill/, AgentDevAidlcCLI/). All output goes to dist/.
#
# Usage:
#   ./scripts/copy-common.sh [target]
#
# Targets: power, skill, cli, all (default: all)
#
# Output:
#   dist/power/   — assembled Power package  → dist/aidlc-mob-elaboration-power.zip
#   dist/skill/   — assembled Skill package  → dist/aidlc-mob-elaboration-skill.zip
#   dist/cli/     — assembled CLI package    → dist/aidlc-mob-elaboration-cli.zip

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
COMMON_DIR="$ROOT_DIR/common"
DIST_DIR="$ROOT_DIR/dist"

# ---------------------------------------------------------------------------
# Title derivation: kebab-case filename → Title Case display name
# e.g. "complexity-rubric.md" → "AI-DLC Complexity Rubric"
# ---------------------------------------------------------------------------
derive_title() {
  local stem="${1%.md}"
  local words
  words=$(echo "$stem" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}')
  echo "AI-DLC $words"
}

# ---------------------------------------------------------------------------
# Frontmatter builders
# ---------------------------------------------------------------------------

power_frontmatter() {
  local title
  title=$(derive_title "$1")
  printf -- '---\ntitle: "%s"\n---\n' "$title"
}

cli_frontmatter() {
  local filename="$1"
  local title
  title=$(derive_title "$filename")
  local inclusion="manual"
  local priority="medium"
  case "$filename" in
    workflow.md) inclusion="always"; priority="high" ;;
  esac
  printf -- '---\ntitle: "%s"\ninclusion: %s\npriority: %s\n---\n' "$title" "$inclusion" "$priority"
}

# ---------------------------------------------------------------------------
# Helper: write file with optional frontmatter prepended
# ---------------------------------------------------------------------------
write_file() {
  local src="$1"
  local dest="$2"
  local frontmatter="$3"

  mkdir -p "$(dirname "$dest")"

  if [[ -n "$frontmatter" ]]; then
    { printf '%s\n\n' "$frontmatter"; cat "$src"; } > "$dest"
  else
    cp "$src" "$dest"
  fi
}

# ---------------------------------------------------------------------------
# Power — assembles into dist/power/
# ---------------------------------------------------------------------------
build_power() {
  local stage="$DIST_DIR/power"
  local src_dir="$ROOT_DIR/AgentDevAidlcPower"
  echo "→ Building Power → $stage"

  rm -rf "$stage"
  mkdir -p "$stage/steering" "$stage/templates"

  # POWER.md (source file — no modification)
  cp "$src_dir/POWER.md" "$stage/POWER.md"
  echo "  ✓ POWER.md"

  # steering/ — common files with Power frontmatter
  for src in "$COMMON_DIR"/*.md; do
    local filename
    filename=$(basename "$src")
    write_file "$src" "$stage/steering/$filename" "$(power_frontmatter "$filename")"
    echo "  ✓ steering/$filename"
  done

  # templates/ — straight copies from common/templates/
  for src in "$COMMON_DIR"/templates/*.md; do
    local filename
    filename=$(basename "$src")
    write_file "$src" "$stage/templates/$filename" ""
    echo "  ✓ templates/$filename"
  done

  # Zip
  (cd "$stage" && find . -not -name ".DS_Store" | zip -q "$DIST_DIR/aidlc-mob-elaboration-power.zip" -@)
  echo "  ✓ → dist/aidlc-mob-elaboration-power.zip ($(du -sh "$DIST_DIR/aidlc-mob-elaboration-power.zip" | cut -f1))"
}

# ---------------------------------------------------------------------------
# Skill — assembles into dist/skill/
# ---------------------------------------------------------------------------
build_skill() {
  local stage="$DIST_DIR/skill"
  local src_dir="$ROOT_DIR/AgentDevAidlcSkill/aidlc-mob-elaboration"
  echo "→ Building Skill → $stage"

  rm -rf "$stage"
  mkdir -p "$stage/aidlc-mob-elaboration/references" "$stage/aidlc-mob-elaboration/assets"

  # SKILL.md (source file — no modification)
  cp "$src_dir/SKILL.md" "$stage/aidlc-mob-elaboration/SKILL.md"
  echo "  ✓ SKILL.md"

  # references/ — straight copies from common/ (no frontmatter for generic skill)
  for src in "$COMMON_DIR"/*.md; do
    local filename
    filename=$(basename "$src")
    write_file "$src" "$stage/aidlc-mob-elaboration/references/$filename" ""
    echo "  ✓ references/$filename"
  done

  # assets/ — straight copies from common/templates/
  for src in "$COMMON_DIR"/templates/*.md; do
    local filename
    filename=$(basename "$src")
    write_file "$src" "$stage/aidlc-mob-elaboration/assets/$filename" ""
    echo "  ✓ assets/$filename"
  done

  # Zip
  (cd "$stage" && find . -not -name ".DS_Store" | zip -q "$DIST_DIR/aidlc-mob-elaboration-skill.zip" -@)
  echo "  ✓ → dist/aidlc-mob-elaboration-skill.zip ($(du -sh "$DIST_DIR/aidlc-mob-elaboration-skill.zip" | cut -f1))"
}

# ---------------------------------------------------------------------------
# CLI — assembles into dist/cli/
# ---------------------------------------------------------------------------
build_cli() {
  local stage="$DIST_DIR/cli"
  local src_dir="$ROOT_DIR/AgentDevAidlcCLI"
  echo "→ Building CLI → $stage"

  rm -rf "$stage"
  mkdir -p "$stage/.kiro/steering" "$stage/.kiro/templates" "$stage/.kiro/agents"

  # README.md (source file — no modification)
  cp "$src_dir/README.md" "$stage/README.md"
  echo "  ✓ README.md"

  # CLI-specific steering files (source files — no modification)
  cp "$src_dir/.kiro/steering/aidlc-mob-elaboration.md" "$stage/.kiro/steering/aidlc-mob-elaboration.md"
  cp "$src_dir/.kiro/steering/aidlc-terminal-format.md" "$stage/.kiro/steering/aidlc-terminal-format.md"
  echo "  ✓ steering/aidlc-mob-elaboration.md"
  echo "  ✓ steering/aidlc-terminal-format.md"

  # steering/ — common files with CLI frontmatter and aidlc- prefix
  for src in "$COMMON_DIR"/*.md; do
    local filename
    filename=$(basename "$src")
    write_file "$src" "$stage/.kiro/steering/aidlc-$filename" "$(cli_frontmatter "$filename")"
    echo "  ✓ steering/aidlc-$filename"
  done

  # templates/ — straight copies from common/templates/
  for src in "$COMMON_DIR"/templates/*.md; do
    local filename
    filename=$(basename "$src")
    write_file "$src" "$stage/.kiro/templates/$filename" ""
    echo "  ✓ templates/$filename"
  done

  # agents/ — source JSON files (no modification)
  for src in "$src_dir/.kiro/agents"/*.json; do
    local filename
    filename=$(basename "$src")
    cp "$src" "$stage/.kiro/agents/$filename"
    echo "  ✓ agents/$filename"
  done

  # Zip
  (cd "$stage" && find . -not -name ".DS_Store" | zip -q "$DIST_DIR/aidlc-mob-elaboration-cli.zip" -@)
  echo "  ✓ → dist/aidlc-mob-elaboration-cli.zip ($(du -sh "$DIST_DIR/aidlc-mob-elaboration-cli.zip" | cut -f1))"
}

# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------
mkdir -p "$DIST_DIR"

TARGET="${1:-all}"

case "$TARGET" in
  power) build_power ;;
  skill) build_skill ;;
  cli)   build_cli ;;
  all)
    build_power
    build_skill
    build_cli
    ;;
  *)
    echo "Unknown target: $TARGET. Use: power | skill | cli | all"
    exit 1
    ;;
esac

echo ""
echo "✅ Done"
