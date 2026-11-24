import TauLeanTutorial.Ch01_StateMachines
import TauLeanTutorial.Ch02_ShiftRegister

/-!
# Chapter 5: Traces and invariants (Days 12–14, alongside chapter 4)

So far each theorem has been about `run … t` at one time `t`. Another view:
the whole execution is a **trace**, a function `Nat → σ`, and a property of
the circuit is a predicate on traces.

Why bother? Once several components (producers, buses, consumers) act at
the same time, it is easier to say "the trace of the whole machine satisfies
each component's constraint" than to write one giant `step`. Our
collaborators work in this **trace semantics** style. Software Foundations
uses operational (step-relation) semantics. This chapter shows the two
agree for our deterministic circuits.

Reading pair: SF vol. 2 *Hoare*. `invariant_rule` below is the hardware
version of Hoare logic's while-loop rule: if `P` holds at reset and every
clock edge preserves it, `P` holds forever.
-/

namespace TauLeanTutorial.Traces

abbrev Trace (σ : Type) := Nat → σ

def Always {σ : Type} (P : σ → Prop) (tr : Trace σ) : Prop := ∀ t, P (tr t)
def Eventually {σ : Type} (P : σ → Prop) (tr : Trace σ) : Prop := ∃ t, P (tr t)

/-- Worked: the invariant rule, with an assumption `Q` on inputs. -/
theorem invariant_rule {σ ι : Type} (step : σ → ι → σ) (s₀ : σ) (inp : Nat → ι)
    (P : σ → Prop) (Q : ι → Prop)
    (h0 : P s₀) (hinp : ∀ t, Q (inp t)) (hstep : ∀ s x, P s → Q x → P (step s x)) :
    Always P (run step s₀ inp) := by
  unfold Always
  intro t
  induction t with
  | zero => exact h0
  | succ n ih =>
    rw [run_succ]
    exact hstep _ _ ih (hinp n)

/-! ## Exercises -/

open ShiftRegister in
/-- Exercise 5.1: if every input is a byte (0..255), every register always
holds a byte. Use `invariant_rule`; do not do induction yourself. -/
theorem regs_in_range (inp : Nat → Int) (h : ∀ t, 0 ≤ inp t ∧ inp t ≤ 255) :
    Always (fun s : Regs => ∀ i, 0 ≤ s i ∧ s i ≤ 255) (regsAt inp) := by
  sorry

open ShiftRegister in
/-- Exercise 5.2: some properties relate *two* points in time, so they are
not single-state invariants. Prove: on every cycle, stage 1 holds what
stage 0 held one cycle earlier. Then write one such property of your own. -/
theorem stage1_follows_stage0 (inp : Nat → Int) :
    ∀ t, regsAt inp (t + 1) 1 = regsAt inp t 0 := by
  sorry

end TauLeanTutorial.Traces
