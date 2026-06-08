#!/usr/bin/env bash
# Polaxory dev-sync — pre-flight + setup guide for the hand-built Studio file
# + Rojo-synced src/ workflow.
#
# Usage: ./scripts/dev-sync.sh
#
# What this does:
#   1. Confirms aftman + rojo are installed.
#   2. Runs `aftman install` so rojo/stylua/selene match aftman.toml.
#   3. Runs `rojo build` once as a sanity check that src/ compiles.
#   4. Prints the exact next steps to connect your local .rbxl to src/.
#
# What this does NOT do:
#   - Start a long-running Rojo server. Run `rojo serve` yourself when ready.
#   - Modify your .rbxl. Studio owns the world; src/ owns the scripts.

set -euo pipefail

cd "$(dirname "$0")/.."
REPO_ROOT="$(pwd)"

print_step() {
	echo
	echo "→ $1"
}

echo
echo "=============================================================="
echo " Polaxory dev-sync — pre-flight + setup guide"
echo " Repo: $REPO_ROOT"
echo "=============================================================="

print_step "Checking aftman..."
if ! command -v aftman >/dev/null 2>&1; then
	echo "ERROR: aftman not installed."
	echo "  Install via: brew install aftman"
	echo "  Or download: https://github.com/LPGhatguy/aftman/releases"
	exit 1
fi
echo "  $(aftman --version)"

print_step "Installing pinned tools (rojo, stylua, selene) from aftman.toml..."
aftman install --no-trust-check >/dev/null

# aftman installs to ~/.aftman/bin/. If that's not on PATH yet (common on a
# first-time setup), put it on PATH for this script and tell the user how to
# make it permanent.
AFTMAN_BIN="$HOME/.aftman/bin"
if ! command -v rojo >/dev/null 2>&1; then
	if [ -x "$AFTMAN_BIN/rojo" ]; then
		export PATH="$AFTMAN_BIN:$PATH"
		echo "  Note: added $AFTMAN_BIN to PATH for this script."
		echo "  To make it permanent, run:"
		echo "    echo 'export PATH=\"\$HOME/.aftman/bin:\$PATH\"' >> ~/.zshrc"
		echo "    source ~/.zshrc"
	else
		echo "ERROR: rojo missing at $AFTMAN_BIN/rojo after aftman install."
		echo "  Check aftman.toml and the install log above."
		exit 1
	fi
fi
echo "  $(rojo --version)"

print_step "Sanity-building project (verifies src/ compiles via Rojo)..."
mkdir -p build
rojo build default.project.json --output build/sanity.rbxl >/dev/null
echo "  Built: build/sanity.rbxl"

cat <<'EOF'

=============================================================
Next steps
=============================================================

1. Open your hand-built Studio file:
     ~/polaxory/roblox-game-backrooms-slice/Polaxory_Backrooms_Slice0.rbxl

2. Build the course geometry in Studio under a Folder named
     Workspace.PolaxoryBackroomsSlice0

   With at least two BaseParts inside it:
     - EnterTrigger  (thin floor plate near spawn)
     - ExitTrigger   (thin floor plate at the far end of the corridor)

   src/server/SignalRunCourse.server.luau finds them by name and wires:
     EnterTrigger.Touched -> RoundCompletionRewards.startRound(player)
     ExitTrigger.Touched  -> RoundCompletionRewards.completeRound(player)

   The script creates no geometry. You keep full Studio control of the
   corridor, walls, ceiling, lights, atmosphere.

3. Install the Rojo Studio plugin (one time):
     https://rojo.space/docs/getting-started/installation/

4. Start the Rojo dev server in a separate terminal:
     rojo serve default.project.json
   (default port 34872)

5. In Studio, open the Rojo plugin and Connect.

6. Press Play. Walk onto EnterTrigger then ExitTrigger.
   Watch the Output window for the receipt sequence:
     [PolaxoryTelemetry] RoundStarted
     [PolaxoryTelemetry] RoundCompleted
     [PolaxoryTelemetry] RewardGranted
   Click Claim on the reward panel, then Run Again:
     [PolaxoryTelemetry] RewardClaimed
     [PolaxoryTelemetry] NextRoundStarted

=============================================================
EOF
