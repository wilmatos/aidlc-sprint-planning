#!/usr/bin/env bash
# copy-common.sh — assembles distribution packages in dist/ by combining
# source files with generated copies of common/ content.
#
# Nothing is written to the source directories (AIDLC-Sprint-Planning-Power/,
# AIDLC-Sprint-Planning-Skill/, AIDLC-Sprint-Planning-CLI/). All output goes to dist/.
#
# Usage:
#   ./scripts/copy-common.sh [target]
#
# Targets: power, skill, cli, all (default: all)
#
# Output:
#   dist/aidlc-sprint-planning-power/   — staging → dist/aidlc-sprint-planning-power.zip
#   dist/aidlc-sprint-planning-skill/   — staging → dist/aidlc-sprint-planning-skill.zip
#   dist/aidlc-sprint-planning-cli/     — staging → dist/aidlc-sprint-planning-cli.zip
#
# Template path mapping (agent instructions reference templates by name only):
#   Power:  common/templates/*.md → steering/template-*.md  (Kiro only serves steering/)
#   Skill:  common/templates/*.md → assets/*.md
#   CLI:    common/templates/*.md → .kiro/templates/*.md

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
COMMON_DIR="$ROOT_DIR/common"
DIST_DIR="$ROOT_DIR/dist"

# ---------------------------------------------------------------------------
# Validate required source files exist before building
# ---------------------------------------------------------------------------
validate_sources() {
  local errors=0

  # Common logic files
  for f in workflow.md state-machine.md complexity-rubric.md team-topology.md \
           decomposer.md validator.md plan-generator.md spec-handoff.md \
           resume-protocol.md unit-format.md requirements-validation.md; do
    if [[ ! -f "$COMMON_DIR/$f" ]]; then
      echo "ERROR: Missing common file: common/$f"
      errors=$((errors + 1))
    fi
  done

  # Template files
  for f in elaboration-log-template.md status-template.md unit-template.md plan-template.md; do
    if [[ ! -f "$COMMON_DIR/templates/$f" ]]; then
      echo "ERROR: Missing template: common/templates/$f"
      errors=$((errors + 1))
    fi
  done

  if [[ $errors -gt 0 ]]; then
    echo "FATAL: $errors missing source file(s). Aborting."
    exit 1
  fi
}

validate_sources

# ---------------------------------------------------------------------------
# Title derivation: kebab-case filename → Title Case display name
# e.g. "complexity-rubric.md" → "AIDLC Complexity Rubric"
# ---------------------------------------------------------------------------
derive_title() {
  local stem="${1%.md}"
  local words
  words=$(echo "$stem" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}')
  echo "AIDLC $words"
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
# Power — assembles into dist/aidlc-sprint-planning-power/
# ---------------------------------------------------------------------------
build_power() {
  local folder="aidlc-sprint-planning-power"
  local stage="$DIST_DIR/$folder"
  local src_dir="$ROOT_DIR/AIDLC-Sprint-Planning-Power"
  echo "→ Building Power → $stage"

  rm -rf "$stage"
  mkdir -p "$stage/steering"

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

  # steering/template-* — templates as steering files so the agent can read them
  for src in "$COMMON_DIR"/templates/*.md; do
    local filename
    filename=$(basename "$src")
    write_file "$src" "$stage/steering/template-$filename" "$(power_frontmatter "template-$filename")"
    echo "  ✓ steering/template-$filename"
  done

  # Zip with top-level folder name preserved
  (cd "$DIST_DIR" && find "$folder" -not -name ".DS_Store" | zip -q "aidlc-sprint-planning-power.zip" -@)
  echo "  ✓ → dist/aidlc-sprint-planning-power.zip ($(du -sh "$DIST_DIR/aidlc-sprint-planning-power.zip" | cut -f1))"
}

# ---------------------------------------------------------------------------
# Skill — assembles into dist/aidlc-sprint-planning-skill/
# ---------------------------------------------------------------------------
build_skill() {
  local folder="aidlc-sprint-planning-skill"
  local stage="$DIST_DIR/$folder"
  local src_dir="$ROOT_DIR/AIDLC-Sprint-Planning-Skill/aidlc-sprint-planning"
  echo "→ Building Skill → $stage"

  rm -rf "$stage"
  mkdir -p "$stage/aidlc-sprint-planning/references" "$stage/aidlc-sprint-planning/assets"

  # SKILL.md (source file — no modification)
  cp "$src_dir/SKILL.md" "$stage/aidlc-sprint-planning/SKILL.md"
  echo "  ✓ SKILL.md"

  # references/ — straight copies from common/ (no frontmatter for generic skill)
  for src in "$COMMON_DIR"/*.md; do
    local filename
    filename=$(basename "$src")
    write_file "$src" "$stage/aidlc-sprint-planning/references/$filename" ""
    echo "  ✓ references/$filename"
  done

  # assets/ — straight copies from common/templates/
  for src in "$COMMON_DIR"/templates/*.md; do
    local filename
    filename=$(basename "$src")
    write_file "$src" "$stage/aidlc-sprint-planning/assets/$filename" ""
    echo "  ✓ assets/$filename"
  done

  # Zip with top-level folder name preserved
  (cd "$DIST_DIR" && find "$folder" -not -name ".DS_Store" | zip -q "aidlc-sprint-planning-skill.zip" -@)
  echo "  ✓ → dist/aidlc-sprint-planning-skill.zip ($(du -sh "$DIST_DIR/aidlc-sprint-planning-skill.zip" | cut -f1))"
}

# ---------------------------------------------------------------------------
# CLI — assembles into dist/aidlc-sprint-planning-cli/
# ---------------------------------------------------------------------------
build_cli() {
  local folder="aidlc-sprint-planning-cli"
  local stage="$DIST_DIR/$folder"
  local src_dir="$ROOT_DIR/AIDLC-Sprint-Planning-CLI"
  echo "→ Building CLI → $stage"

  rm -rf "$stage"
  mkdir -p "$stage/.kiro/steering" "$stage/.kiro/templates" "$stage/.kiro/agents"

  # README.md (source file — no modification)
  cp "$src_dir/README.md" "$stage/README.md"
  echo "  ✓ README.md"

  # CLI-specific steering files (source files — no modification)
  cp "$src_dir/.kiro/steering/aidlc-sprint-planning.md" "$stage/.kiro/steering/aidlc-sprint-planning.md"
  cp "$src_dir/.kiro/steering/aidlc-terminal-format.md" "$stage/.kiro/steering/aidlc-terminal-format.md"
  echo "  ✓ steering/aidlc-sprint-planning.md"
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

  # Zip with top-level folder name preserved
  (cd "$DIST_DIR" && find "$folder" -not -name ".DS_Store" | zip -q "aidlc-sprint-planning-cli.zip" -@)
  echo "  ✓ → dist/aidlc-sprint-planning-cli.zip ($(du -sh "$DIST_DIR/aidlc-sprint-planning-cli.zip" | cut -f1))"
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
