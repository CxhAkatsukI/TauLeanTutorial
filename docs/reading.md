# Reading list

Read for ideas and do the exercises in this repo. Software Foundations is
written in Rocq (formerly Coq). **Don't install Rocq.** Read the prose and
the theorem statements, and skip the Rocq tactic scripts.

| When | Reading | Why it's here | Pairs with |
|---|---|---|---|
| Day 1 | [Natural Number Game 4](https://adam.math.hhu.de/#/g/leanprover-community/nng4): *Tutorial* and *Addition* worlds | The Lean proof interface and your first inductions | `Ch00` |
| Days 1–2 | *Functional Programming in Lean*, ch. 1–2 | `def`, `structure`, `inductive`, pattern matching, recursion | `Ch00`, `Ch01` |
| As needed | *Theorem Proving in Lean 4*: "Tactics", "Induction and Recursion" | Look things up when an induction gets stuck | `Ch02`–`Ch04` |
| Day 2 | SF vol. 1 ch. 9 [*ProofObjects*](https://softwarefoundations.cis.upenn.edu/lf-current/ProofObjects.html) | A proof is a program, and a theorem is its type. This is why Lean can be both a simulator and a verifier | `Ch00` |
| Days 3–4 | SF vol. 2 ch. 5 [*Smallstep*](https://softwarefoundations.cis.upenn.edu/plf-current/Smallstep.html) | Operational semantics. Our `step` is the deterministic case, and `run` is multi-step `-->*` with a step count | `Ch01` |
| Day 8 | SF vol. 2 ch. 2 [*Hoare*](https://softwarefoundations.cis.upenn.edu/plf-current/Hoare.html) | Pre/postconditions and the loop rule. The clock is our loop | `Ch05` `invariant_rule` |
| Day 9 (morning) | SF vol. 2 ch. 3 [*Hoare2*](https://softwarefoundations.cis.upenn.edu/plf-current/Hoare2.html) | Decorated programs and *finding* invariants: exactly the Day 9 whiteboard exercise | `Ch04` `psum_inv` |

## A note on trace semantics

SF describes programs operationally, with a step relation. People who do
this research professionally often use **trace semantics** instead: an
execution is a function from time to state (or a sequence of events), and
a specification is a predicate on traces. It is more direct when many
components act concurrently. Each component contributes a constraint, and
the system's behavior is the set of traces satisfying all of them.

For the deterministic circuits in this tutorial the two views agree:
`run step s₀ inp` *is* the trace. `Ch05_Traces.lean` makes the switch
explicit, so you can follow either style of discussion.
