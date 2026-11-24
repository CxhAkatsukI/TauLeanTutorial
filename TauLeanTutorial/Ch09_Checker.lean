import TauLeanTutorial.Ch08_Banks

/-!
# Chapter 9: A checker you can trust (Day 18)

The research plan: a compiler or search tool (CP-SAT, an LLM, …) proposes
a schedule. A small **checker** written in Lean decides whether to accept
it. We never have to trust the proposer, only the checker. We trust the
checker because we **prove it sound**:

    check s = true → ConflictFree s

A checker should also explain a rejection. `verdict` returns a **witness**:
the two reads that clash. A search tool can use that to try a different
bank or offset. (Real checkers also have a third answer, "unknown", for when
no proof was found. Our toy property is decidable, so we don't need it.)
-/

namespace TauLeanTutorial.Checker

open Banks

def clashB (r q : Read) : Bool := r.cycle == q.cycle && r.bank == q.bank

def check : List Read → Bool
  | [] => true
  | r :: rest => !(rest.any (clashB r)) && check rest

def findClash : List Read → Option (Read × Read)
  | [] => none
  | r :: rest =>
    match rest.find? (clashB r) with
    | some q => some (r, q)
    | none => findClash rest

inductive Verdict
  | pass
  | conflict (r q : Read)
  deriving Repr

def verdict (s : List Read) : Verdict :=
  match findClash s with
  | some (r, q) => .conflict r q
  | none => .pass

#eval verdict (schedule 2 0 0 3) -- conflict: A[1] and B[0] on cycle 2, bank 0
#eval verdict (schedule 4 0 0 3) -- pass
#eval verdict (schedule 2 0 1 3) -- pass: B moved to bank 1

/-! ## Exercises -/

/-- Exercise 9.1: the Boolean test matches the logical definition.
Hint: `simp [clashB, Clash]`. -/
theorem clashB_iff (r q : Read) : clashB r q = true ↔ Clash r q := by
  sorry

/-- Exercise 9.2 (soundness, the key theorem). Hint: `induction s`; use
`List.pairwise_cons`, `List.any_eq_false` and `clashB_iff`. -/
theorem check_sound (s : List Read) : check s = true → ConflictFree s := by
  sorry

/-- Exercise 9.3 (completeness): the checker never rejects a good schedule. -/
theorem check_complete (s : List Read) : ConflictFree s → check s = true := by
  sorry

/-- Exercise 9.4: every reported witness is a real clash, not a false alarm. -/
theorem witness_genuine (s : List Read) (r q : Read) :
    findClash s = some (r, q) → r ∈ s ∧ q ∈ s ∧ Clash r q := by
  sorry

end TauLeanTutorial.Checker
