import Std.Tactic.BVDecide
import TauLeanTutorial.Ch01_StateMachines

/-!
# Chapter 6: Bit widths: an 8-bit adder (Day 15)

Until now values were mathematical `Int`s. Real datapaths have a fixed
width and wrap around. Lean's `BitVec 8` is an 8-bit word, and `+` on it
is addition mod 256. `bv_decide` proves facts about fixed-width words
automatically by handing them to a SAT solver. Lean's kernel still checks
the certificate the solver returns.

Three questions, the same ones the README asks:
1. Does it compute the right value? (combinational correctness)
2. On which cycle is the result valid? (sequential timing)
3. Whose value did it read? (chapter 7)
-/

namespace TauLeanTutorial.Adder

#eval (255 : BitVec 8) + 1 -- 0x00#8: wraparound

/-! ## Combinational: a full adder from gates -/

structure FA where
  sum : Bool
  carry : Bool
  deriving Repr

/-- `!=` on `Bool` is XOR. -/
def fullAdder (a b c : Bool) : FA :=
  ⟨(a != b) != c, (a && b) || (c && (a != b))⟩

/-- Exercise 6.1: the full adder's truth table. Hint: `by decide` checks
all 8 cases. -/
theorem fullAdder_correct :
    ∀ a b c : Bool,
      (fullAdder a b c).sum.toNat + 2 * (fullAdder a b c).carry.toNat
        = a.toNat + b.toNat + c.toNat := by
  sorry

/-! ## An 8-bit adder built only from XOR, AND and shifts

Each `halfStep` adds without carrying (XOR) and computes the carries (AND,
shifted left by one). After 8 rounds no carries are left. -/

def halfStep (p : BitVec 8 × BitVec 8) : BitVec 8 × BitVec 8 :=
  (p.1 ^^^ p.2, (p.1 &&& p.2) <<< 1)

def gateAdd8 (a b : BitVec 8) : BitVec 8 :=
  (halfStep (halfStep (halfStep (halfStep
    (halfStep (halfStep (halfStep (halfStep (a, b))))))))).1

#eval gateAdd8 200 100 -- 0x2c#8 = 300 mod 256 = 44

/-- Exercise 6.2: for all 2^16 inputs, the gate-level adder equals `a + b`.
Hint: `unfold gateAdd8 halfStep` then `bv_decide`. -/
theorem gateAdd8_correct (a b : BitVec 8) : gateAdd8 a b = a + b := by
  sorry

/-! ## Sequential: a registered adder with a valid bit -/

structure OutReg where
  valid : Bool
  out : BitVec 8
  deriving Repr, DecidableEq

/-- `none` is an empty cycle (a bubble). -/
def regStep (_ : OutReg) (inp : Option (BitVec 8 × BitVec 8)) : OutReg :=
  match inp with
  | some (a, b) => ⟨true, a + b⟩
  | none => ⟨false, 0⟩

/-- Two inputs with a bubble between them. -/
def demoInp : Nat → Option (BitVec 8 × BitVec 8)
  | 0 => some (1, 2)
  | 2 => some (255, 1)
  | _ => none

#eval (List.range 4).map (run regStep ⟨false, 0⟩ demoInp)

/-- Exercise 6.3: sample on cycle `t`, see a valid result on cycle `t + 1`. -/
theorem regAdder_timing (inp : Nat → Option (BitVec 8 × BitVec 8)) (t : Nat)
    (a b : BitVec 8) (h : inp t = some (a, b)) :
    run regStep ⟨false, 0⟩ inp (t + 1) = ⟨true, a + b⟩ := by
  sorry

end TauLeanTutorial.Adder
