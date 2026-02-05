#!/bin/bash
# Sync refactor templates from umlspec-kit to local specify installation
# Usage: ./sync-local-templates.sh [target-project-path]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SPECIFY_HOME="${SPECIFY_HOME:-.specify}"
TARGET_PROJECT="${1:-.}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Sync Local Refactor Templates - Specify v2.0.0+          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Step 1: Verify files exist in umlspec-kit
echo -e "${YELLOW}Step 1: Verify source templates${NC}"
REFACTOR_TEMPLATES=(
    "templates/spec-template.refactor.md"
    "templates/plan-template.refactor.md"
    "templates/commands/spec.refactor.md"
    "templates/commands/plan.refactor.md"
)

for template in "${REFACTOR_TEMPLATES[@]}"; do
    if [ ! -f "$REPO_ROOT/$template" ]; then
        echo -e "${RED}✗ Missing: $template${NC}"
        exit 1
    fi
done
echo -e "${GREEN}✓ All refactor templates found in $REPO_ROOT${NC}"
echo ""

# Step 2: Navigate to target project
echo -e "${YELLOW}Step 2: Check target project${NC}"
if [ ! -d "$TARGET_PROJECT" ]; then
    echo -e "${RED}✗ Target project not found: $TARGET_PROJECT${NC}"
    exit 1
fi
cd "$TARGET_PROJECT"
echo -e "${GREEN}✓ Working in: $(pwd)${NC}"
echo ""

# Step 3: Create .specify directory structure if needed
echo -e "${YELLOW}Step 3: Setup .specify directory${NC}"
if [ ! -d "$SPECIFY_HOME" ]; then
    mkdir -p "$SPECIFY_HOME/templates/commands"
    echo -e "${GREEN}✓ Created: $SPECIFY_HOME${NC}"
else
    echo -e "${GREEN}✓ Found existing: $SPECIFY_HOME${NC}"
fi
echo ""

# Step 4: Copy refactor templates
echo -e "${YELLOW}Step 4: Copy refactor templates${NC}"
cp "$REPO_ROOT/templates/spec-template.refactor.md" "$SPECIFY_HOME/templates/"
cp "$REPO_ROOT/templates/plan-template.refactor.md" "$SPECIFY_HOME/templates/"
cp "$REPO_ROOT/templates/commands/spec.refactor.md" "$SPECIFY_HOME/templates/commands/"
cp "$REPO_ROOT/templates/commands/plan.refactor.md" "$SPECIFY_HOME/templates/commands/"
echo -e "${GREEN}✓ Synced 4 template files${NC}"
echo ""

# Step 5: Show summary
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  ✅ Sync Complete                                          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Templates synced to:${NC}"
echo "  📂 $SPECIFY_HOME/templates/"
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "  1️⃣  Create spec: specify spec refactor \"[description]\""
echo "  2️⃣  Create plan: specify plan refactor"
echo "  3️⃣  Create tasks: specify tasks refactor"
echo ""
echo -e "${GREEN}Documentation:${NC}"
echo "  📖 Setup Guide: $REPO_ROOT/docs/LOCAL_SETUP_GUIDE.md"
echo "  📖 Validation: $REPO_ROOT/docs/refactor-template-validation-report.md"
echo ""
echo -e "${YELLOW}AC-1~AC-4 Framework:${NC}"
echo "  • AC-1: User Behavior Consistency (E2E Parity)"
echo "  • AC-2: Performance Consistency (No Regression)"
echo "  • AC-3: SLA Consistency (No Degradation)"
echo "  • AC-4: Lossless Release (MTTR ≤ target)"
echo ""
