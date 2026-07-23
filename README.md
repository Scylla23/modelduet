# ModelDuet

> Two frontier models. Each doing what it does best.

ModelDuet is a manually invoked Claude Code skill that pairs **Fable 5** with
**GPT-5.6 Sol**:

- Fable discovers, plans, reviews, and verifies.
- Sol implements and fixes.
- The loop stops when the plan passes or the five-round cap is reached.

It is one `SKILL.md` file that coordinates the Claude Code and Codex CLIs. No
server, proxy, or application code required.

![ModelDuet workflow demo](docs/demo.gif)

## Why

A single model often plans, implements, and reviews its own assumptions.
ModelDuet separates those jobs. Fable defines the target and acts as the quality
gate; Sol stays focused on building.

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

Every run starts from a clean Git tree, creates an isolated `modelduet/<task>`
branch, caps the loop at five worker rounds, and never merges or pushes without
an explicit request.

## Requirements

- [Claude Code](https://code.claude.com/docs/en/overview) with access to Fable 5
- [Codex CLI](https://developers.openai.com/codex/cli/) with access to `gpt-5.6-sol`
- Git

Both CLIs must already be installed and authenticated.

## Install

```bash
git clone https://github.com/Scylla23/modelduet.git \
  ~/.claude/skills/modelduet
```

Restart the session once after installing if the top-level skills directory did
not exist when Claude Code started.

## Usage

Run from a clean Git repository:

```text
/modelduet Add rate limiting to the public authentication endpoints
```

ModelDuet is intentionally manual. Claude will not invoke it automatically.

## Safety

- Dirty working trees stop the run instead of being committed or stashed.
- Fable reads the full diff and runs the declared verification commands.
- Security flaws, failed checks, and unmet criteria block approval.
- The skill never merges, pushes, or deletes its task branch by itself.

## License

[MIT](LICENSE)

## Disclaimer

ModelDuet is an independent open-source project and is not affiliated with,
endorsed by, or sponsored by Anthropic or OpenAI. Product and model names
belong to their respective owners.
