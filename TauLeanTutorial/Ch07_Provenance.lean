import TauLeanTutorial.Ch01_StateMachines

/-!
# Chapter 7: Whose value did you read? (Day 16)

In a statically scheduled accelerator, values travel along shared lanes,
moving one hop per cycle. A producer writing into a lane **overwrites**
whatever value is passing through at that position. This is not a
"two writers in the same cycle" conflict, so a double-write check does not
catch it.

This chapter builds a counterexample in which:
* the consumer reads on the right cycle,
* the lane holds a valid value,
* and the answer is still wrong, because the value came from the wrong producer.

The fix is to **tag every value with its producer** and make "reads from
the right producer" part of the specification.
-/

namespace TauLeanTutorial.Provenance

inductive Producer
  | B      -- the producer the spec says the consumer should read
  | B'     -- another producer sharing the lane
  deriving DecidableEq, Repr

structure Tagged where
  val : Int
  src : Producer
  deriving DecidableEq, Repr

/-- A write: on `cycle`, put `v` at lane position `pos`. -/
structure Write where
  cycle : Nat
  pos : Nat
  v : Tagged
  deriving Repr

/-- Lane state: position ↦ value in flight (or empty). -/
abbrev Lane := Nat → Option Tagged

def writesAt (prog : List Write) (t : Nat) : Nat → Option Tagged :=
  fun i => (prog.find? fun w => w.cycle == t && w.pos == i).map (·.v)

/-- One hop per cycle. A write this cycle wins over the value arriving
from upstream. -/
def laneStep (lane : Lane) (w : Nat → Option Tagged) : Lane :=
  fun i => match w i with
    | some v => some v
    | none => if i = 0 then none else lane (i - 1)

def laneAt (prog : List Write) (t : Nat) : Lane :=
  run laneStep (fun _ => none) (writesAt prog) t

/-- The consumer reads lane position 4 on cycle 5. -/
def readAt (prog : List Write) : Option Tagged := laneAt prog 5 4

/-- The consumer computes `a + b` from what it read. -/
def consume (a : Int) (prog : List Write) : Option Int := (readAt prog).map (a + ·.val)

/-- Intended program: `B` writes `b` at position 0 on cycle 0. It arrives
at position 4 on cycle 5. -/
def good (b : Int) : List Write := [⟨0, 0, ⟨b, .B⟩⟩]

/-- Broken program: `B'` writes `b'` at position 1 on cycle 1, exactly as
`b` passes through position 1. -/
def bad (b b' : Int) : List Write := [⟨0, 0, ⟨b, .B⟩⟩, ⟨1, 1, ⟨b', .B'⟩⟩]

#eval consume 1 (good 2)  -- some 3
#eval consume 1 (bad 2 7) -- some 8: on time, valid, wrong
#eval readAt (bad 2 7)    -- the tag shows who wrote it: B'

/-! ## Specification and exercises -/

/-- What a value-only check sees: "something valid arrived". -/
def ArrivesOnTime (prog : List Write) : Prop := (readAt prog).isSome = true

/-- The stronger spec: the value read came from producer `p`. -/
def ReadsFrom (prog : List Write) (p : Producer) : Prop :=
  (readAt prog).map (·.src) = some p

/-- Exercise 7.1: the good program reads `b` from `B`, for every `b`.
Hint: try `rfl`. If that fails, `simp [readAt, laneAt, laneStep, writesAt, good]`. -/
theorem good_correct (b : Int) : readAt (good b) = some ⟨b, .B⟩ := by
  sorry

/-- Exercise 7.2: the bad program passes the value-only check... -/
theorem bad_on_time (b b' : Int) : ArrivesOnTime (bad b b') := by
  sorry

/-- Exercise 7.3: ...but fails the provenance spec. -/
theorem bad_wrong_producer (b b' : Int) : ¬ ReadsFrom (bad b b') .B := by
  sorry

end TauLeanTutorial.Provenance
