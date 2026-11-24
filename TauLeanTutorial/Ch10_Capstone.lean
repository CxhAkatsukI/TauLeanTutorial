import TauLeanTutorial.Ch01_StateMachines

/-!
# Chapter 10: Capstone: `out = a + b` on a toy streaming machine (Days 19–21)

Put chapters 6–9 together. Two memory units stream operands along two lanes
to a vector unit, which adds them on cycle 5. Values are 8-bit and wrap
around.

```
  MemA ──lane 0──▶ ─ ─ ─ ─ ▶ ┐
                             VXM: out = a + b   (cycle 5, position 4)
  MemB ──lane 1──▶ ─ ─ ─ ─ ▶ ┘
          ▲
        MemB' also writes into lane 1
```

Your job is to prove three things about the **same** `step`:
1. **Value**: for all `a b : BitVec 8`, the good program outputs `a + b`.
2. **Timing**: the output is valid on cycle 5 and not before.
3. **Provenance**: the operands came from `MemA` and `MemB`. Then build the
   broken program where `MemB'` overwrites lane 1 in flight. Show that it
   still passes (2) but fails (1) and (3).

Stretch goal: write a checker `checkProducers : List Write → Bool` and prove
it sound, as in chapter 9.

The definitions below are a starting point. Change them if you find a
cleaner model, and explain why in your write-up.
-/

namespace TauLeanTutorial.Capstone

inductive Producer
  | MemA | MemB | MemB'
  deriving DecidableEq, Repr

structure Tagged where
  val : BitVec 8
  src : Producer
  deriving DecidableEq, Repr

structure Write where
  lane : Nat
  cycle : Nat
  pos : Nat
  v : Tagged
  deriving Repr

/-- lane ↦ position ↦ value in flight. -/
abbrev Lanes := Nat → Nat → Option Tagged

def writesAt (prog : List Write) (t : Nat) : Nat → Nat → Option Tagged :=
  fun l i => (prog.find? fun w => w.lane == l && w.cycle == t && w.pos == i).map (·.v)

def lanesStep (s : Lanes) (w : Nat → Nat → Option Tagged) : Lanes :=
  fun l i => match w l i with
    | some v => some v
    | none => if i = 0 then none else s l (i - 1)

def lanesAt (prog : List Write) (t : Nat) : Lanes :=
  run lanesStep (fun _ _ => none) (writesAt prog) t

/-- The vector unit's output on cycle `t`: `none` unless both operands are present. -/
def outAt (prog : List Write) (t : Nat) : Option (BitVec 8) :=
  match lanesAt prog t 0 4, lanesAt prog t 1 4 with
  | some x, some y => some (x.val + y.val)
  | _, _ => none

def good (a b : BitVec 8) : List Write :=
  [⟨0, 0, 0, ⟨a, .MemA⟩⟩, ⟨1, 0, 0, ⟨b, .MemB⟩⟩]

#eval outAt (good 1 2) 5     -- some 3
#eval outAt (good 255 1) 5   -- some 0: wraparound

/-- Task 1 (value). -/
theorem good_value (a b : BitVec 8) : outAt (good a b) 5 = some (a + b) := by
  sorry

/-- Task 2 (timing): nothing valid comes out before cycle 5. -/
theorem good_not_early (a b : BitVec 8) : ∀ t, t < 5 → outAt (good a b) t = none := by
  sorry

-- Task 3: define `bad`, the provenance spec, and the three theorems yourself.

end TauLeanTutorial.Capstone
