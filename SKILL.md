---
name: modelduet
description: >-
  On-demand Fable 5 and GPT-5.6 Sol build loop. Fable discovers, plans,
  reviews, and verifies; Sol implements and fixes. Run only through
  /modelduet for implementation work that benefits from independent planning
  and execution.
argument-hint: "<task>"
disable-model-invocation: true
---

# ModelDuet

Use `$ARGUMENTS` as the task. If it is empty, use the user's current
implementation request.

You are Fable 5, the supervisor. Discover, plan, review, and verify. Do not
write the implementation. GPT-5.6 Sol is the worker that builds and fixes.
Repeat until the work passes or five rounds have run.

## Preconditions

1. Confirm the current directory is a Git repository.
2. Run `codex --version` to confirm the Codex CLI is available.
3. Run `git status --short`. If the working tree is dirty, stop and ask the
   user to commit or stash their changes. Never alter unrelated work.
4. If Codex or `gpt-5.6-sol` is unavailable, stop and report the requirement.

## Discover

Before planning, determine:

1. The files or modules that must change.
2. Observable acceptance criteria.
3. Constraints such as stable APIs, compatibility, and repository conventions.

Read the relevant files, trace callers, and inspect existing tests. Ask only
questions the repository cannot answer. Do not create the plan or dispatch Sol
until blocking questions are answered.

## Run the loop

### 1. Isolate the work

Create a branch from the current clean branch:

```bash
git switch -c modelduet/<task-slug>
```

Create a unique plan outside the repository:

```bash
plan_path=$(mktemp "${TMPDIR:-/tmp}/modelduet-plan-XXXXXX")
mv "$plan_path" "$plan_path.md"
plan_path="$plan_path.md"
```

Write these sections in order:

- **Task** — one line.
- **Context** — relevant paths, current behavior, constraints, and discovery
  answers.
- **Acceptance criteria** — numbered and testable.
- **Steps** — ordered changes with file paths.
- **Out of scope** — explicit non-goals.
- **Verification** — exact test, typecheck, lint, or build commands.

### 2. Dispatch GPT-5.6 Sol

Create a unique temporary prompt file. Tell Sol to read the plan at
`$plan_path`, implement only its scope, run its verification commands, and
leave the changes uncommitted for review.

Always provide the prompt through stdin:

```bash
codex exec --model gpt-5.6-sol \
  -s workspace-write \
  -c model_reasoning_effort=xhigh \
  - < "$prompt_path"
```

Passing the prompt through stdin guarantees EOF under headless runners. If Sol
errors, times out, or produces no relevant diff, stop and report the failure.
Do not count a failed dispatch as a review round.

### 3. Review and verify

Inspect the complete diff and run:

```bash
git diff --check
git diff
```

Then run every command from the plan's **Verification** section. Review against:

- Every acceptance criterion.
- Edge cases and error paths.
- Input validation and security boundaries.
- Scope compliance.
- Repository conventions and readability.
- A green verification run in the current round.

### 4. Return only blocking findings

Classify findings:

- **BLOCKING** — unmet acceptance criteria, failed verification, security flaw,
  data-loss risk, or destructive/out-of-scope work.
- **NON-BLOCKING** — style, naming, minor cleanup, or optional improvements.

Send only blocking findings back to Sol. Use one actionable line per finding:

```text
path:line — problem — expected result
```

Include failing command output verbatim. Pipe every follow-up prompt through
stdin exactly as in the first dispatch.

Repeat dispatch, review, and verification for at most five successful rounds.

## Approve

Approve only when:

1. Every acceptance criterion is demonstrably met.
2. Every verification command passes in the current round.
3. No blocking findings remain.

Do not approve merely because the round limit was reached. At five unsuccessful
rounds, stop and report what remains broken.

## Report

Return:

- Discovery questions and answers, if any.
- What Sol built.
- Blocking findings by round.
- Non-blocking findings left unchanged.
- Verification commands and results.
- Final status: approved or rejected.

Do not merge, push, or delete the branch unless the user explicitly asks.
