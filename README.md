# Lean for Circuit & Architecture Specs

A three-week, hands-on tutorial for **computer-architecture people** who
want to write precise, machine-checked specifications of hardware in
[Lean 4](https://lean-lang.org). No prior proof-assistant experience is
needed. If you can read a waveform and write a little code, you can start.

Simulation shows what a circuit did on the inputs you tried. A Lean proof
says what it does on **every** input, and Lean checks the proof for you.
Every chapter uses the same circuit model, an executable `step` function,
both ways: `#eval` runs it as a cycle-accurate simulator, and theorems
prove things about it.

The whole tutorial comes back to three questions:

1. **Does it compute the right value?**
2. **On which cycle is the result valid?**
3. **Whose value did it read?** A value can arrive on time and still come
   from the wrong producer.

## Who this is for, and where it leads

Statically scheduled accelerators (static VLIW / streaming designs) have
no caches, no out-of-order execution and no dynamic arbitration. The
compiler decides every hardware action on every cycle. That makes them a
very clean target for formal verification. They are clocked state machines
with no hidden nondeterminism. This tutorial builds the skills you need for
that kind of work: modeling a datapath cycle by cycle, proving correctness
and timing for *all* problem sizes, catching resource conflicts and
wrong-producer bugs, and writing a schedule checker that comes with a
soundness proof.

## Setup (Day 1, about 1 hour)

```bash
# Install elan (the Lean version manager): https://lean-lang.org/install
curl https://elan.lean-lang.org/elan-init.sh -sSf | sh
git clone <this repo> && cd <this repo>
lake build          # first build downloads the pinned Lean toolchain
```

Use VS Code with the **lean4** extension. Open any `.lean` file and keep
the *Lean Infoview* panel open: it shows the current proof goal.

A successful `lake build` prints `declaration uses 'sorry'` warnings. That
is expected: each `sorry` is an exercise for you.

## Layout

| File | Days | Topic |
|---|---|---|
| `Ch00_Warmup.lean` | 1–2 | `def`, `#eval`, first induction, `omega`, `grind` |
| `Ch01_StateMachines.lean` | 3 | `State` / `step` / `run`; cycle conventions |
| `Ch02_ShiftRegister.lean` | 3–6 | Induction on time; generalizing the hypothesis |
| `Ch03_MAC.lean` | 4–7 | Spec vs. implementation: `acc` vs. `dot` |
| `Ch04_Systolic1D.lean` | 8–14 | Input skewing, invariants over time and PE index, top-level correctness |
| `Ch05_Traces.lean` | 12–14 | Trace semantics, the invariant rule (Hoare logic for circuits) |
| `Ch06_Adder.lean` | 15 | `BitVec 8`, wraparound, `bv_decide`, valid bits |
| `Ch07_Provenance.lean` | 16 | Tagged values: right cycle, valid, wrong producer |
| `Ch08_Banks.lean` | 17 | Bank-port conflicts, proved for every tile count |
| `Ch09_Checker.lean` | 18 | A schedule checker, its soundness proof, conflict witnesses |
| `Ch10_Capstone.lean` | 19–21 | `out = a + b` on a toy streaming machine |
| `scripts/systolic_trace.py` | 8 | Python reference trace for chapter 4 |
| `docs/schedule.md` | — | Day-by-day plan (8 h/day) and deliverables |
| `docs/reading.md` | — | Reading list and how it maps to the chapters |

## Schedule at a glance

| Week | Theme | Deliverable |
|---|---|---|
| 1 (Days 1–7) | Lean basics; shift register and MAC as state machines; induction on time | `Ch02` + `Ch03` with no `sorry`, plus half a page on your 3 most common errors or places you got stuck |
| 2 (Days 8–14) | 1D systolic array: invariant on paper, then in Lean; traces and invariants | `Ch04` + `Ch05` with no `sorry`, plus a 10-minute whiteboard talk on the invariant and the boundary cases |
| 3 (Days 15–21) | Bit widths, provenance, resource conflicts, verified checkers, capstone | `Ch06`–`Ch09` with no `sorry`, the capstone, and a 10-minute talk |

Details: [`docs/schedule.md`](docs/schedule.md).

## Ground rules

* **Write the spec separately from the implementation.** A spec that just
  restates `step` proves nothing.
* **Run it before you prove it.** Use `#eval` to check a concrete trace
  against your hand calculation or the Python reference first.
* **Fix one cycle convention and keep it.** Here, cycle 0 is the reset
  state, and `inp t` is sampled on the edge from cycle `t` to `t + 1`.
* **Stuck for more than 30 minutes?** Write down the goal from the infoview
  and ask. The half-page write-up each week is where these moments go.

## Contributing

Issues and PRs are welcome, especially new chapters or clearer hints.
CI runs `lake build` and the Python reference trace on every push.
