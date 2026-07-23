# ModelDuet demo

The README animation is a deterministic, illustrated walkthrough of the
ModelDuet workflow. It demonstrates the roles, review loop, blocking-finding
format, verification gate, and final handoff without presenting scripted text
as live provider output.

## Regenerate

Install [VHS](https://github.com/charmbracelet/vhs), then run:

```bash
vhs docs/demo.tape
```

The tape runs `docs/demo.sh` and writes `docs/demo.gif` at 880×520.

## Beats

1. Invoke `/modelduet` with an implementation task.
2. Fable 5 discovers the scope and writes testable acceptance criteria.
3. GPT-5.6 Sol implements the plan.
4. Fable finds a blocking issue during review.
5. Sol fixes it and reruns verification.
6. Fable approves after every criterion passes.
