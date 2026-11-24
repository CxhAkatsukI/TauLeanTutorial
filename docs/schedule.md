# Day-by-day schedule

Full-time, about 8 hours a day. Weeks 1–2 follow the mentor's original
roadmap. Items marked **[+]** were added: Software Foundations readings
paired with the day they explain, the trace-semantics bridge, and all of
week 3. Days 7, 14 and 21 are deliberately lighter. Use them to catch up,
clean up, and write up.

## Week 1: Lean basics and primitive circuits

| Day | Learn (≈3 h) | Build and prove (≈5 h) | Checkpoint |
|---|---|---|---|
| 1 | Natural Number Game: *Tutorial* + *Addition* (≈4 h). FPIL ch. 1 | Install Lean + VS Code; `lake build` this repo; run every `#eval` in `Ch00` | `lake build` succeeds locally |
| 2 | FPIL ch. 2 (`structure`, `inductive`, pattern matching). **[+]** SF *ProofObjects* (≈1.5 h, prose only) | `Ch00` exercises 0.1–0.2: your first induction proofs with `omega` and `grind` | `Ch00` has no `sorry` |
| 3 | Synchronous circuits as transition systems: `State`, `step`, `run`. Cycle conventions | `Ch01`: run the counter, prove 1.1. `Ch02`: model the shift register, predict on paper which input reaches stage 2 on cycle 5, then check with `#eval` | `#eval` matches your hand trace |
| 4 | **[+]** SF *Smallstep* (≈3 h): relate `step`/`run` to the step relation and `-->*` | `Ch03`: MAC model. Print 10 cycles and compare with hand calculation | Two working models with traces |
| 5 | Induction on `t`; keeping the hypothesis general (`∀ k` in the statement, `generalize`/`revert`); helper lemmas | `Ch02` exercise 2.1 `stage_delay` (the hard one) | 2.1 done |
| 6 | Reuse lemmas instead of redoing inductions | `Ch02` 2.2–2.3 (`shift_delay`); `Ch03` 3.1 `mac_correct` | Shift-delay and MAC theorems proved |
| 7 | (light) | `Ch03` 3.2; clean up proofs; write the half-page note | **Deliverable 1**: `Ch02` + `Ch03` with no `sorry`, plus half a page on the 3 most common errors or places you got stuck |

## Week 2: The 1D systolic array

| Day | Learn | Build and prove | Checkpoint |
|---|---|---|---|
| 8 | Run `scripts/systolic_trace.py`; understand the wavefront and input skewing. **[+]** SF *Hoare* (≈3 h) | **No Lean today.** On paper: the PE state (`xreg`, `psum`), the single-cycle `step`, and a guessed invariant: on cycle `t`, which row and which partial sum are in PE `i`? | Table colored by row; invariant written down |
| 9 | **[+]** SF *Hoare2* in the morning: decorated programs and finding invariants | Refine the paper invariant; check it carries from cycle `t` to `t + 1`, including the first and last PE and the cycles before the wavefront arrives | **15-min check-in with mentor**: is the invariant strong enough? |
| 10 | Two-index reasoning `(t, i)`; boundary cases | Read `Ch04` definitions; confirm the `#eval` matches the Python trace exactly | Zero mismatches |
| 11 | Splitting cases: `i = 0` vs. `i > 0`, `t < i + 2` | `Ch04` exercise 4.1 `psum_inv`: get the structure in place, with `sorry` for the sub-cases | Proof skeleton compiles |
| 12 | **[+]** `Ch05` intro: traces, `Always`, the invariant rule | Finish `psum_inv` | Invariant proved |
| 13 | Deriving the top-level theorem from the invariant | `Ch04` 4.2 `systolic_correct`. **[+]** `Ch05` 5.1–5.2 | Top-level theorem proved |
| 14 | (light) | Refactor; remove redundant steps; prepare the talk | **Deliverable 2**: `Ch04` + `Ch05` with no `sorry`, plus a 10-min whiteboard/code talk explaining the invariant and the boundary cases |

## Week 3 [+]: From circuits to architecture specs

This week moves from "the circuit computes the right thing" to what
verifying a compiled schedule for a statically scheduled accelerator needs.

| Day | Learn | Build and prove | Checkpoint |
|---|---|---|---|
| 15 | `BitVec`, wraparound, `bv_decide`; valid bits | `Ch06` 6.1–6.3: gate-level adder for all 2^16 inputs; registered adder timing | `Ch06` has no `sorry` |
| 16 | Provenance: tag values with their producer | `Ch07`: show the broken program is on time and valid, but reads from the wrong producer | Value-only check passes, provenance spec fails, both proved |
| 17 | Resource conflicts; parametric schedules (one proof for all tile counts) | `Ch08`: 8.2, then the ★ exercise 8.1 | Conflict-freedom proved for every `II ≥ 3` |
| 18 | Verified checkers: soundness, completeness, witnesses | `Ch09` 9.1–9.4 | `check_sound` proved |
| 19 | Capstone design: read `Ch10`, decide whether to keep or change the model | Task 1 (value) and task 2 (timing) | Good program proved for all `a b` |
| 20 | — | Task 3: broken program, provenance spec, and the stretch checker | Counterexample proved |
| 21 | (light) | Write-up and talk | **Deliverable 3**: `Ch06`–`Ch10` with no `sorry`, plus a 10-min talk: "three questions, one `step`" |
