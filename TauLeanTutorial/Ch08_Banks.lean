/-!
# Chapter 8: Resource conflicts, for every tile count (Day 17)

Toy pipeline: tile `i` starts on cycle `i * II` (the initiation interval).
It reads operand `A[i]` on cycle `i * II` and `B[i]` on cycle `i * II + 2`.
Each SRAM bank has **one read port**. Two reads of the same bank on the
same cycle is a conflict.

A simulator can check one tile count `N`. A theorem can check **all** `N`
at once. That is the point of this chapter.
-/

namespace TauLeanTutorial.Banks

structure Read where
  cycle : Nat
  bank : Nat
  name : String
  deriving Repr

def Clash (r q : Read) : Prop := r.cycle = q.cycle ∧ r.bank = q.bank

/-- No two reads in the schedule clash. -/
def ConflictFree (s : List Read) : Prop := s.Pairwise fun r q => ¬ Clash r q

def tileReads (II bankA bankB : Nat) (i : Nat) : List Read :=
  [⟨i * II, bankA, s!"A[{i}]"⟩, ⟨i * II + 2, bankB, s!"B[{i}]"⟩]

def schedule (II bankA bankB N : Nat) : List Read :=
  (List.range N).flatMap (tileReads II bankA bankB)

#eval schedule 2 0 0 3 -- look for two reads on cycle 2 in bank 0

/-! ## Worked: parametric facts, one line each -/

/-- With `II = 4`, an `A` read and a `B` read never share a cycle, for any tiles. -/
theorem ii4_AB (i j : Nat) : i * 4 ≠ j * 4 + 2 := by omega

/-- With `II = 4`, `A` reads of different tiles never share a cycle. -/
theorem ii4_AA (i j : Nat) (h : i ≠ j) : i * 4 ≠ j * 4 := by omega

/-- With `II = 2`, there is a witness: `A[1]` and `B[0]` meet on cycle 2. -/
theorem ii2_witness : ∃ i j : Nat, i * 2 = j * 2 + 2 := ⟨1, 0, rfl⟩

/-! ## Exercises -/

/-- Exercise 8.1 (★): the `A`/`B` timing never overlaps for any `II ≥ 3`.
`omega` alone fails here because `i * II` is nonlinear. Hint: compare `i`
and `j`, write the difference as `d`, and use `Nat.mul_sub` or
`Nat.add_mul`. -/
theorem AB_apart (II i j : Nat) (hII : 3 ≤ II) : i * II ≠ j * II + 2 := by
  sorry

/-- Exercise 8.2: putting `B` in its own bank removes every clash between an
`A` read and a `B` read, whatever the timing. -/
theorem split_banks (II i j bA bB : Nat) (h : bA ≠ bB) :
    ¬ Clash ⟨i * II, bA, "A"⟩ ⟨j * II + 2, bB, "B"⟩ := by
  sorry

end TauLeanTutorial.Banks
