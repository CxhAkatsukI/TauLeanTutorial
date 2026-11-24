/-!
# Chapter 1: A synchronous circuit is a state machine (Day 3)

Every clocked circuit in this tutorial has the same shape:

* `σ` is the **state**: everything stored in registers.
* `ι` is the **input** that arrives during one cycle.
* `step : σ → ι → σ` is **one clock edge**: given the registers now and the
  input this cycle, it returns the registers after the edge.

`run step s₀ inp t` is the state after `t` clock edges, starting from the
reset state `s₀` and reading input `inp 0, inp 1, …`.

Convention used everywhere: **cycle 0 is the reset state**, and the input
`inp t` is sampled on the edge that takes cycle `t` to cycle `t + 1`.

Reading pair: Software Foundations vol. 2, *Smallstep*. Our `step` is the
deterministic special case of SF's step relation, and `run` is SF's
multi-step `-->*` with the number of steps written down explicitly.
-/

namespace TauLeanTutorial

/-- The state after `t` clock edges. -/
def run {σ ι : Type} (step : σ → ι → σ) (s₀ : σ) (inp : Nat → ι) : Nat → σ
  | 0 => s₀
  | t + 1 => step (run step s₀ inp t) (inp t)

@[simp] theorem run_zero {σ ι : Type} (step : σ → ι → σ) (s₀ : σ) (inp : Nat → ι) :
    run step s₀ inp 0 = s₀ := rfl

@[simp] theorem run_succ {σ ι : Type} (step : σ → ι → σ) (s₀ : σ) (inp : Nat → ι)
    (t : Nat) : run step s₀ inp (t + 1) = step (run step s₀ inp t) (inp t) := rfl

namespace Counter

/-- The smallest circuit: a counter that ignores its input. -/
def step (s : Nat) (_ : Unit) : Nat := s + 1

def noInput : Nat → Unit := fun _ => ()

#eval (List.range 6).map (run step 0 noInput) -- [0, 1, 2, 3, 4, 5]

/-- Worked example: induction on time `t`. Almost every theorem in this
tutorial starts this way. -/
theorem counter_run (t : Nat) : run step 0 noInput t = t := by
  induction t with
  | zero => rfl
  | succ n ih => simp [step, ih]

/-- Exercise 1.1. A counter that starts at `c` instead of `0`. -/
theorem counter_run_from (c t : Nat) : run step c noInput t = c + t := by
  sorry

end Counter

end TauLeanTutorial
