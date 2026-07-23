# ModelDuet

> Two frontier models. Each doing what it does best.

ModelDuet is a manually invoked Claude Code skill that pairs **Fable 5** with
**GPT-5.6 Sol**:

- Fable discovers, plans, reviews, and verifies.
- Sol implements and fixes.
- The loop stops only when the plan passes or the five-round cap is reached.

No orchestration server, proxy, or application code is required. ModelDuet is
one `SKILL.md` file that coordinates the Claude Code and Codex CLIs.

## Why ModelDuet?

A single model often plans, implements, and reviews its own assumptions.
ModelDuet separates those jobs. The supervising model defines the target and
acts as the quality gate; the implementation model stays focused on building.

## Workflow

```text
User request
    ↓
Fable: discover → plan
    ↓
Sol: implement
    ↓
Fable: review → verify
    ├── blocking findings → Sol fixes → review again
    └── approved → final report
```

Every run:

- Starts from a clean Git working tree.
- Creates an isolated `modelduet/<task>` branch.
- Uses a testable plan stored outside the repository.
- Pipes prompts to Codex through stdin for reliable headless execution.
- Caps the loop at five successful worker rounds.
- Never merges or pushes without an explicit request.

## Requirements

- [Claude Code](https://code.claude.com/docs/en/overview)
- A Claude Code session with access to Fable 5
- [Codex CLI](https://developers.openai.com/codex/cli/)
- Codex access to `gpt-5.6-sol`
- Git

Both CLIs must already be installed and authenticated.

## Install

Install ModelDuet as a personal skill available in every project:

```bash
git clone https://github.com/Scylla23/modelduet.git \
  ~/.claude/skills/modelduet
```

Or install only the skill file:

```bash
mkdir -p ~/.claude/skills/modelduet
curl -fsSL \
  https://raw.githubusercontent.com/Scylla23/modelduet/main/SKILL.md \
  -o ~/.claude/skills/modelduet/SKILL.md
```

Claude Code watches personal skill directories for changes. If the top-level
skills directory did not exist when Claude Code started, restart the session
once after installation.

## Usage

Run ModelDuet from a clean Git repository:

```text
/modelduet Add rate limiting to the public authentication endpoints
```

Other examples:

```text
/modelduet Refactor the billing retry flow without changing its public API
```

```text
/modelduet Implement the accepted design in docs/search-v2.md
```

ModelDuet is intentionally manual. Claude will not invoke it automatically.

## What gets changed?

ModelDuet creates a task branch and lets Sol edit files inside the current
repository. The plan and worker prompts use unique temporary files outside the
repository. The skill itself adds no telemetry and sends data only through the
Claude Code and Codex tools you invoke.

Review each provider's data and privacy settings before using ModelDuet with
sensitive source code.

## Safety guarantees

- Dirty working trees stop the run instead of being committed or stashed.
- Sol receives an explicit scope and acceptance criteria.
- Fable reads the full diff and runs the declared verification commands.
- Security flaws, failed checks, and unmet criteria block approval.
- Non-blocking polish cannot consume another worker round.
- The skill never merges, pushes, or deletes its task branch by itself.

## Troubleshooting

### `codex: command not found`

Install the Codex CLI and confirm `codex --version` works in the same shell that
launches Claude Code.

### GPT-5.6 Sol is unavailable

Confirm the authenticated Codex account can use `gpt-5.6-sol`. ModelDuet does
not silently substitute another worker model.

### The working tree is dirty

Commit or stash your existing changes, then invoke `/modelduet` again. This
keeps the review diff limited to the worker's implementation.

### The loop reaches five rounds

ModelDuet stops and reports the remaining blockers. Refine the request or fix
the environmental failure before running it again.

## Repository structure

```text
modelduet/
├── SKILL.md     # Claude Code workflow
├── README.md    # User documentation
└── LICENSE      # MIT license
```

The landing page will be added after its design specification is finalized.

## Contributing

Issues and focused pull requests are welcome. Keep the skill self-contained,
manual, and model-role specific. Changes should preserve branch isolation,
independent review, real verification, and the five-round safety cap.

## License

[MIT](LICENSE)

## Disclaimer

ModelDuet is an independent open-source project and is not affiliated with,
endorsed by, or sponsored by Anthropic or OpenAI. Product and model names
belong to their respective owners.
