import TauLeanTutorial.Ch01_StateMachines

/-!
# Chapter 3: Multiply-accumulate unit (Days 4–7)

One register `acc`. Each cycle it takes a pair `(a, w)` and computes
`acc' = acc + a * w`.

The **specification** `dot` is written separately, as plain math with no
clock. The theorem connects the two: after `k` cycles the hardware has
computed the first `k` terms of the dot product. Keeping the spec separate
from the implementation is the most important habit in this tutorial.
-/

namespace TauLeanTutorial.MAC

def step (acc : Int) (aw : Int × Int) : Int := acc + aw.1 * aw.2

/-- Specification: `∑_{i<k} a i * w i`. -/
def dot (a w : Nat → Int) : Nat → Int
  | 0 => 0
  | k + 1 => dot a w k + a k * w k

def accAt (a w : Nat → Int) (k : Nat) : Int := run step 0 (fun t => (a t, w t)) k

def demoA (t : Nat) : Int := [1, 2, 3].getD t 0
def demoW (t : Nat) : Int := [2, 3, 5].getD t 0

#eval (List.range 5).map (accAt demoA demoW) -- [0, 2, 8, 23, 23]
#eval dot demoA demoW 3                      -- 23

/-- Exercise 3.1 (MAC correctness). Hint: `induction k`, then
`simp [accAt, step, dot] at *`. If `simp` leaves something, `omega` will
not help with `*`. Look at what is left and use `ih` with `rw`. -/
theorem mac_correct (a w : Nat → Int) (k : Nat) : accAt a w k = dot a w k := by
  sorry

/-- Exercise 3.2: once the inputs are zero, the accumulator holds its value.
This is the "drain" behavior you will need again in chapter 4. -/
theorem mac_hold (a w : Nat → Int) (k : Nat) (h : ∀ t, k ≤ t → a t = 0) :
    ∀ j, accAt a w (k + j) = accAt a w k := by
  sorry

end TauLeanTutorial.MAC
