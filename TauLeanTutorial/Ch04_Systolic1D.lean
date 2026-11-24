import TauLeanTutorial.Ch01_StateMachines

/-!
# Chapter 4: 1D systolic array (Days 8–14)

`N` processing elements (PEs) in a row. PE `i` holds a fixed weight `w i`.
Each PE has an input register `xreg` and a partial-sum register `psum`.
Partial sums flow left to right:

```
  feed ─▶ xreg[0]   feed ─▶ xreg[1]   feed ─▶ xreg[2]
             │                 │                 │
   0 ──▶ [ PE0: +w0·x ] ─▶ [ PE1: +w1·x ] ─▶ [ PE2: +w2·x ] ─▶ out
```

**Input skewing**: PE `i` must see row `r` exactly when row `r`'s partial
sum arrives from PE `i - 1`. So element `i` of row `r` is fed on cycle `r + i`.

Do Days 8–9 on paper first (see `docs/schedule.md`):
1. Run `python3 scripts/systolic_trace.py` and color one row in the table.
2. Write down, for any `t` and `i`, which row PE `i` holds on cycle `t`.
   That sentence is the invariant `psum_inv` below.
3. Check with your mentor that the invariant is strong enough to go from
   cycle `t` to cycle `t + 1`. This is the "decorated program" idea from
   SF *Hoare2*.
-/

namespace TauLeanTutorial.Systolic1D

structure PEs where
  xreg : Nat → Int
  psum : Nat → Int

def reset : PEs := ⟨fun _ => 0, fun _ => 0⟩

/-- Input skewing: on cycle `t`, PE `i` is fed element `i` of row `t - i`. -/
def feed (X : Nat → Nat → Int) (t : Nat) : Nat → Int :=
  fun i => if i ≤ t then X (t - i) i else 0

def step (w : Nat → Int) (s : PEs) (xin : Nat → Int) : PEs where
  xreg := xin
  psum := fun i => (if i = 0 then 0 else s.psum (i - 1)) + w i * s.xreg i

def stateAt (w : Nat → Int) (X : Nat → Nat → Int) (t : Nat) : PEs :=
  run (step w) reset (feed X) t

/-- Specification: dot product of the first `n` elements. -/
def dotRow (w x : Nat → Int) : Nat → Int
  | 0 => 0
  | n + 1 => dotRow w x n + w n * x n

/-! ## The running example (same numbers as `scripts/systolic_trace.py`) -/

def demoW (i : Nat) : Int := [2, 3, 5].getD i 0
def demoX (r i : Nat) : Int := ([[1, 2, 3], [4, 0, 1]].getD r []).getD i 0

-- psum of PE0, PE1, PE2 on cycles 0..6.
-- Row 0 goes 2 → 8 → 23 on cycles 2, 3, 4. Row 1 leaves PE2 on cycle 5 as 13.
#eval (List.range 7).map fun t => (List.range 3).map fun i => (stateAt demoW demoX t).psum i

/-! ## Theorems -/

/-- Worked: the input register holds last cycle's feed. -/
theorem xreg_next (w : Nat → Int) (X : Nat → Nat → Int) (t i : Nat) :
    (stateAt w X (t + 1)).xreg i = feed X t i := rfl

/-- Exercise 4.1 (the invariant). On cycle `t`, PE `i` holds the partial
sum of row `t - 2 - i` over elements `0..i`.

Hint: `intro t; induction t`. In the succ case, unfold one `step`. You need
`xreg_next` at `t - 1` (careful when `t = 0`) and `ih` at `i - 1`. -/
theorem psum_inv (w : Nat → Int) (X : Nat → Nat → Int) :
    ∀ t i, i + 2 ≤ t → (stateAt w X t).psum i = dotRow w (X (t - 2 - i)) (i + 1) := by
  sorry

/-- Exercise 4.2 (top-level correctness). Row `r` leaves the last PE on
cycle `r + N + 1`, and it equals the dot product. Rows never mix. -/
theorem systolic_correct (w : Nat → Int) (X : Nat → Nat → Int) (N r : Nat) (hN : 0 < N) :
    (stateAt w X (r + N + 1)).psum (N - 1) = dotRow w (X r) N := by
  sorry

end TauLeanTutorial.Systolic1D
