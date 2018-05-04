# → {} <:
# Figure 16-2: Algorithmic subtyping, p212

    import ./11-7-records

    syntax {
      $T ::= ... / Top
    }


## Subtyping

These rules essentially recapitulate some of the results we found in 15-1 and
16-1, but using the `↦` prefix to separate the results from declarative
subtyping.

    rule SA-Top {
      ↦ $S <: Top
    }

    rule SA-Arrow {
      ↦ $T1 <: $S1 / ↦ $S2 <: $T2
      ----------------------------
      ↦ ($S1 → $S2) <: ($T1 → $T2)
    }

Records:

    rule SA-Rcd-0 {
      ↦ $R <: Rcd
    }

    rule SA-Rcd-N {
      $R1 . $l = $S / ↦ $S <: $T / ↦ $R1 <: $R2
      -----------------------------------------
                ↦ $R1 <: ($l: $T, $R2)
    }

I'm going to add `Bool` and `Nat` here too, so we can write some examples. We
may be able to replace these with an `SA-Refl` rule if we add the cut to our
language.

    rule SA-Bool { ↦ Bool <: Bool }
    rule SA-Nat  { ↦ Nat  <: Nat  }
