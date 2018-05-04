rule S-Refl {
  $S <: $S
}

rule S-Trans {
  $S <: $U / $U <: $T
  -------------------
        $S <: $T
}

rule S-AB { A <: B }
rule S-BC { B <: C }
rule S-CD { C <: D }

prove { A <: $T }
