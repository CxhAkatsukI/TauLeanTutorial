/-!
# Chapter 0: Warm-up (Days 1–2)

Goal: you can read the Lean infoview, run `#eval`, and write one proof by
induction. Do the Natural Number Game's *Tutorial* and *Addition* worlds first.

Put your cursor at the end of each line below and watch the infoview panel
on the right. Lean is both a programming language and a proof checker. This
file uses both sides.
-/

namespace TauLeanTutorial.Warmup

/-! ## Programs -/

/-- A tiny recursive function. Recursion on `n + 1` is how circuits will
"take one more clock step" later. -/
def double : Nat → Nat
  | 0 => 0
  | n + 1 => double n + 2

#eval double 21 -- 42

/-! ## Proofs -/

/-- Worked example: your first induction.

* `zero` case: `double 0 = 2 * 0` holds by computation (`rfl`).
* `succ` case: Lean gives you `ih : double k = 2 * k` and asks for the
  `k + 1` case. `show` unfolds one step of `double`. `omega` then finishes
  the linear arithmetic, using `ih` from the context. -/
theorem double_eq (n : Nat) : double n = 2 * n := by
  induction n with
  | zero => rfl
  | succ k ih =>
    show double k + 2 = 2 * (k + 1)
    omega

/-- Two automation tactics you will use constantly. -/
example (a b : Nat) (h : a ≤ b) : a < b + 1 := by omega
example (f : Nat → Nat) (a b : Nat) (h : a = b) : f a = f b := by grind

/-! ## Exercises -/

/-- Exercise 0.1. Hint: `induction n`, then copy the shape of `double_eq`. -/
theorem double_add (m n : Nat) : double (m + n) = double m + double n := by
  sorry

/-- Exercise 0.2. Hint: you can *use* `double_eq` instead of doing induction
again: `rw [double_eq, double_eq]`. -/
theorem double_double (n : Nat) : double (double n) = 4 * n := by
  sorry

end TauLeanTutorial.Warmup
