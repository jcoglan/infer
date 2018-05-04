# Cuts

    rule Rule-A {
      b $X / <!> / c $Y
      -----------------
            a $X $Y
    }

    rule Rule-AEq {
      b $X / c $X
      -----------
        a $X $X
    }

    rule Rule-B1 { b 1 }
    rule Rule-B2 { b 2 }
    rule Rule-B3 { b 3 }

    rule Rule-C1 { c 1 }
    rule Rule-C2 { c 2 }
    rule Rule-C3 { c 3 }

    rule Rule-P {
      a $X $Y / d $Y
      --------------
          p $X $Y
    }

    rule Rule-D2 { d 2 }
    rule Rule-D3 { d 3 }


## Examples

    prove { a $X $Y }
    prove { p $X $Y }
