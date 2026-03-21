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
# Frontmatter definitions
# ---------------------------------------------------------------------------

# Kiro Power steering frontmatter (title only — inclusion is managed by POWER.md)
power_frontmatter() {
  local title="$1"
  printf -- '---\ntitle: "%s"\n---\n' "$title"
}

# Kiro CLI steering frontmatter
cli_frontmatter() {
  local title="$1"
  local inclusion="${2:-manual}"
  local priority="${3:-medium}"
  printf -- '---\ntitle: "%s"\ninclusion: %s\npriority: %s\n---\n' "$title" "$inclusion" "$priority"
}

# ---------------------------------------------------------------------------
# Helper: prepend frontmatter and copy
# ---------------------------------------------------------------------------
copy_with_frontmatter() {
  local src="$1"       # source file path
  local dest="$2"      # destination file path
  local frontmatter="$3"  # frontmatter string (empty = no frontmatter)

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

  copy_with_frontmatter "$COMMON_DIR/complexity-rubric.md"     "$dest_dir/complexity-rubric.md"     "$(power_frontmatter 'AI-DLC Complexity Rubric')"
  copy_with_frontmatter "$COMMON_DIR/state-machine.md"         "$dest_dir/state-machine.md"         "$(power_frontmatter 'AI-DLC State Machine')"
  copy_with_frontmatter "$COMMON_DIR/resume-protocol.md"       "$dest_dir/resume-protocol.md"       "$(power_frontmatter 'AI-DLC Resume Protocol')"
  copy_with_frontmatter "$COMMON_DIR/unit-format.md"           "$dest_dir/unit-format.md"           "$(power_frontmatter 'AI-DLC Unit Format')"
  copy_with_frontmatter "$COMMON_DIR/team-topology.md"         "$dest_dir/team-topology.md"         "$(power_frontmatter 'AI-DLC Team Topology')"
  copy_with_frontmatter "$COMMON_DIR/decomposer.md"            "$dest_dir/decomposer.md"            "$(power_frontmatter 'AI-DLC Decomposer')"
  copy_with_frontmatter "$COMMON_DIR/plan-generator.md"        "$dest_dir/plan-generator.md"        "$(power_frontmatter 'AI-DLC Plan Generator')"
  copy_with_frontmatter "$COMMON_DIR/validator.md"             "$dest_dir/validator.md"             "$(power_frontmatter 'AI-DLC Validator')"
  copy_with_frontmatter "$COMMON_DIR/spec-handoff.md"          "$dest_dir/spec-handoff.md"          "$(power_frontmatter 'AI-DLC Spec Handoff')"
  copy_with_frontmatter "$COMMON_DIR/requirements-validation.md" "$dest_dir/requirements-validation.md" "$(power_frontmatter 'AI-DLC Requirements Validation')"

  # Templates — used during onboarding when the agent creates workspace files
  copy_with_frontmatter "$COMMON_DIR/templates/unit-template.md"            "$templates_dir/unit-template.md"            ""
  copy_with_frontmatter "$COMMON_DIR/templates/elaboration-log-template.md" "$templates_dir/elaboration-log-template.md" ""
  copy_with_frontmatter "$COMMON_DIR/templates/status-template.md"          "$templates_dir/status-template.md"          ""
  copy_with_frontmatter "$COMMON_DIR/templates/plan-template.md"            "$templates_dir/plan-template.md"            ""

  echo "  ✓ Power steering and template files updated"
}

# ---------------------------------------------------------------------------
# Skill
# ---------------------------------------------------------------------------
copy_skill() {
  local dest_dir="AgentDevAidlcSkill/aidlc-mob-elaboration/references"
  local assets_dir="AgentDevAidlcSkill/aidlc-mob-elaboration/assets"
  echo "→ Copying to Skill ($dest_dir)"

  # References — no frontmatter for generic skill
  copy_with_frontmatter "$COMMON_DIR/complexity-rubric.md"       "$dest_dir/complexity-rubric.md"       ""
  copy_with_frontmatter "$COMMON_DIR/state-machine.md"           "$dest_dir/state-machine.md"           ""
  copy_with_frontmatter "$COMMON_DIR/resume-protocol.md"         "$dest_dir/resume-protocol.md"         ""
  copy_with_frontmatter "$COMMON_DIR/unit-format.md"             "$dest_dir/unit-format.md"             ""
  copy_with_frontmatter "$COMMON_DIR/team-topology.md"           "$dest_dir/team-topology.md"           ""
  copy_with_frontmatter "$COMMON_DIR/decomposer.md"              "$dest_dir/decomposer.md"              ""
  copy_with_frontmatter "$COMMON_DIR/plan-generator.md"          "$dest_dir/plan-generator.md"          ""
  copy_with_frontmatter "$COMMON_DIR/validator.md"               "$dest_dir/validator.md"               ""
  copy_with_frontmatter "$COMMON_DIR/spec-handoff.md"            "$dest_dir/spec-handoff.md"            ""
  copy_with_frontmatter "$COMMON_DIR/requirements-validation.md" "$dest_dir/requirements-validation.md" ""

  # Templates → assets
  copy_with_frontmatter "$COMMON_DIR/templates/unit-template.md"           "$assets_dir/unit-template.md"           ""
  copy_with_frontmatter "$COMMON_DIR/templates/elaboration-log-template.md" "$assets_dir/elaboration-log-template.md" ""
  copy_with_frontmatter "$COMMON_DIR/templates/status-template.md"         "$assets_dir/status-template.md"         ""
  copy_with_frontmatter "$COMMON_DIR/templates/plan-template.md"           "$assets_dir/plan-template.md"           ""

  echo "  ✓ Skill reference and asset files updated"
}

# ---------------------------------------------------------------------------
# CLI
# ---------------------------------------------------------------------------
copy_cli() {
  local dest_dir="AgentDevAidlcCLI/.kiro/steering"
  local templates_dir="AgentDevAidlcCLI/.kiro/templates"
  echo "→ Copying to CLI ($dest_dir)"

  copy_with_frontmatter "$COMMON_DIR/complexity-rubric.md"       "$dest_dir/aidlc-complexity-rubric.md"       "$(cli_frontmatter 'AI-DLC Complexity Rubric')"
  copy_with_frontmatter "$COMMON_DIR/state-machine.md"           "$dest_dir/aidlc-state-machine.md"           "$(cli_frontmatter 'AI-DLC State Machine')"
  copy_with_frontmatter "$COMMON_DIR/resume-protocol.md"         "$dest_dir/aidlc-resume-protocol.md"         "$(cli_frontmatter 'AI-DLC Resume Protocol')"
  copy_with_frontmatter "$COMMON_DIR/unit-format.md"             "$dest_dir/aidlc-unit-format.md"             "$(cli_frontmatter 'AI-DLC Unit Format')"
  copy_with_frontmatter "$COMMON_DIR/team-topology.md"           "$dest_dir/aidlc-team-topology.md"           "$(cli_frontmatter 'AI-DLC Team Topology')"
  copy_with_frontmatter "$COMMON_DIR/decomposer.md"              "$dest_dir/aidlc-decomposer.md"              "$(cli_frontmatter 'AI-DLC Decomposer')"
  copy_with_frontmatter "$COMMON_DIR/plan-generator.md"          "$dest_dir/aidlc-plan-generator.md"          "$(cli_frontmatter 'AI-DLC Plan Generator')"
  copy_with_frontmatter "$COMMON_DIR/validator.md"               "$dest_dir/aidlc-validator.md"               "$(cli_frontmatter 'AI-DLC Validator')"
  copy_with_frontmatter "$COMMON_DIR/spec-handoff.md"            "$dest_dir/aidlc-spec-handoff.md"            "$(cli_frontmatter 'AI-DLC Spec Handoff')"
  copy_with_frontmatter "$COMMON_DIR/requirements-validation.md" "$dest_dir/aidlc-requirements-validation.md" "$(cli_frontmatter 'AI-DLC Requirements Validation')"

  # Templates
  copy_with_frontmatter "$COMMON_DIR/templates/unit-template.md"           "$templates_dir/unit-template.md"           ""
  copy_with_frontmatter "$COMMON_DIR/templates/elaboration-log-template.md" "$templates_dir/elaboration-log-template.md" ""
  copy_with_frontmatter "$COMMON_DIR/templates/status-template.md"         "$templates_dir/status-template.md"         ""
  copy_with_frontmatter "$COMMON_DIR/templates/plan-template.md"           "$templates_dir/plan-template.md"           ""

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