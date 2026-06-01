# Polaxory Context Audit — 2026-06-01

Purpose: answer Blake's question: which markdown/context artifacts are real GitHub files versus loose assistant context?

## Verdict

The main Signal Run / automation / doctrine artifacts are real and committed in GitHub. They are not imaginary.

Repo commit baseline checked: `abec2a5a112e872a6807d7085a962abf69602b9a` on `main`.

## Confirmed committed handoff locations

### Claude relay files

```txt
.claude/POLAXORY_RELAY.md
.claude/POLAXORY_SIGNAL_RUN_RELAY.md
.claude/CURRENT_CLAUDE_CODE_TASK.md
```

### Project workspace files

```txt
projects/polaxory/action-tasks.md
projects/polaxory/automation_blockchain_knolling_contract.md
projects/polaxory/automation_creation_contract.md
projects/polaxory/automation_heavy_hitter_doctrine.md
projects/polaxory/command_room.json
projects/polaxory/specs/signal_run_v0.md
projects/polaxory/tasks/build_signal_run_playable_v0.json
projects/polaxory/tasks/current_angel_signal.md
projects/polaxory/tasks/revenue_model_agent_economy_v0.md
projects/polaxory/tasks/signal_run_v0_build_spec.md
projects/polaxory/tasks/signal_run_v0_implementation_queue.md
projects/polaxory/tasks/signal_run_v0_playtest_checklist.md
```

Additional `projects/polaxory/tasks/*.json` files are also present for earlier Roblox/data/reward-loop task slices.

### Docs workspace files

`docs/polaxory/` exists and contains multiple committed docs, including active context, command-room/governance/research artifacts, and the Signal Run claim/replay gate. Claude should inspect this folder, but should not treat every doc as equal priority.

Current priority is the executable Slice-0 receipt, not expanding docs.

## What was not confirmed

I did not find exact repo hits for standalone markdowns literally named or phrased as:

```txt
admin
server structure
```

There may be admin-like or server-related ideas inside broader docs, but Claude should not assume a dedicated admin/server-structure spec exists unless it finds a committed file by that name/path.

## Current priority filter

The repo now has enough planning material. New work should pass this gate:

```txt
Does this help emit the receipt?
round_started -> round_completed -> reward_granted -> reward_claimed -> next_round_started
```

If no, defer it.

## Immediate Claude Code instruction

Read `.claude/CURRENT_CLAUDE_CODE_TASK.md`, then implement the smallest server-authoritative reward claim and run-again path.

Do not chase stale assistant context. Do not add a new planning lane. Produce code or a deterministic harness receipt.
