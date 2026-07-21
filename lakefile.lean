import Lake
open Lake DSL

/-! # Root Lake project (for the verilib atomization pipeline)

    The real Lean verification tree lives under `lean/`. This root `lakefile`
    exists so the **repo root is a valid Lake project**, which is what
    `probe-aeneas extract .` (run by the hosted atomization pipeline from the
    repo root) requires: it treats the project directory as the Lean/Lake
    project and locates the Rust crate relative to it.

    Rather than duplicate the sources, the package sets `srcDir := "lean"`, so
    every library root below resolves under `lean/` — this is a thin overlay of
    `lean/lakefile.lean`, kept in sync with it. Developers working purely on the
    Lean proofs continue to use `lean/lakefile.lean` (e.g. `cd lean && lake
    build`); nothing about that workflow or the `Makefile` changes. -/

require aeneas from git
  "https://github.com/AeneasVerif/aeneas.git" @ "b059c34a" / "backends" / "lean"

package «symcrust» where
  -- The Lean sources live in `lean/`; treat that as the package source root so
  -- the repo root can act as the Lake project without moving any files.
  srcDir := "lean"

/-! ## Specifications library -/
lean_lib «Spec»

/-! ## Default-built library (active Spec + Properties proof closure). -/
@[default_target]
lean_lib «Symcrust»

/-! ## Per-primitive convenience aliases. -/
lean_lib «MLKEM»
lean_lib «SHA3»

/-- Verified models of hardware intrinsics. -/
@[default_target]
lean_lib «Intrinsics» where
  globs := #[.andSubmodules `Intrinsics]

/-! ## Spec test vectors. -/
lean_lib «SpecTests» where
  globs := #[.andSubmodules `SpecTests]

lean_exe mlKemTests where
  root := `SpecTests.MLKEM.TestVectors
