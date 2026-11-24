import TauLeanTutorial.Ch01_StateMachines

/-!
# Chapter 2: Shift register (Days 3–6)

A chain of registers. On every clock edge, stage 0 latches the input and
stage `i` copies stage `i - 1`. We model an unbounded chain and *read* tap
`N - 1` to get an `N`-stage shift register. This keeps the definitions
simple and makes the theorems hold for every `N` at once.

Before you prove anything: run the `#eval`, then predict on paper which
input shows up at stage 2 on cycle 5.
-/

namespace TauLeanTutorial.ShiftRegister

/-- Register contents: stage index ↦ value. -/
abbrev Regs := Nat → Int

def step (s : Regs) (x : Int) : Regs :=
  fun i => if i = 0 then x else s (i - 1)

def reset : Regs := fun _ => 0

def regsAt (inp : Nat → Int) (t : Nat) : Regs := run step reset inp t

/-- Inputs 10, 20, 30, … on cycles 0, 1, 2, … -/
def demoInput (t : Nat) : Int := 10 * ((t : Int) + 1)

-- Row `t` lists stages 0, 1, 2 on cycle `t`.
#eval (List.range 6).map fun t => (List.range 3).map fun i => regsAt demoInput t i

/-! ## Exercises

The first one is the real work. The others follow from it.

Hint for 2.1: the statement says `∀ t k`, so after `induction t` the
hypothesis is still about *every* `k`. That matters, because the succ case
needs it at `k - 1`. In the succ case, `simp only [regsAt, run_succ, step]`
exposes the `if`. Then use `split` (or `by_cases k = 0`) and finish with
`ih`, `congr 1` and `omega`. -/

/-- Exercise 2.1: stage `k` holds the input from `k + 1` cycles ago. -/
theorem stage_delay (inp : Nat → Int) :
    ∀ t k, k < t → regsAt inp t k = inp (t - 1 - k) := by
  sorry

/-- Exercise 2.2: before the data arrives, a stage still holds its reset value. -/
theorem stage_reset (inp : Nat → Int) :
    ∀ t k, t ≤ k → regsAt inp t k = 0 := by
  sorry

/-- Exercise 2.3 (the shift-delay theorem): for `t ≥ N`, the output of an
`N`-stage shift register is the input from `N` cycles ago.
Hint: `have h := stage_delay inp t (N - 1) (by omega)`. -/
theorem shift_delay (inp : Nat → Int) (N t : Nat) (hN : 0 < N) (ht : N ≤ t) :
    regsAt inp t (N - 1) = inp (t - N) := by
  sorry

end TauLeanTutorial.ShiftRegister
