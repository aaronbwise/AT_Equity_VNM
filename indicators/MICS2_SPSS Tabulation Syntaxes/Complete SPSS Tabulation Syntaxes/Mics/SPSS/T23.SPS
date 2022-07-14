get file = 'ch.sav'.

weight by chweight.

compute total = 1.
variable label total "Number of children under 5".

do if (diarrhea = 100).

+ recode CI3A (1 = 100) (else = 0) into bmilk.
+ variable label bmilk "Breast milk".

+ recode CI3B (1 = 100) (else = 0) into gruel.
+ variable label gruel "Gruel".

+ recode CI3C (1 = 100) (else = 0) into localok.
+ variable label localok "Local acceptable".

+ recode CI3D (1 = 100) (else = 0) into ors.
+ variable label ors "ORS packet".

+ recode CI3E (1 = 100) (else = 0) into omilk.
+ variable label omilk "Other milk or infant formula".

+ recode CI3F (1 = 100) (else = 0) into waterwfd.
+ variable label waterwfd "Water with feeding".

+ count trtmnts = bmilk gruel localok ors omilk waterwfd (100).

+ recode trtmnts (1 thru 6 = 100) (else = 0) into rectreat.
+ variable label rectreat "Any recommended treatment".

+ recode trtmnts (1 thru 6 = 0) (else = 100) into notreat.
+ variable label notreat "No treatment".

+ compute dtotal = 1.
+ variable label dtotal "Number of children with diarrhea".

end if.

tables
  /observation diarrhea bmilk gruel localok ors omilk waterwfd rectreat notreat
  /ftotal tot1 "Total"
  /table = HL3 + HI7 + HI6 + cage_6 + melevel + tot1 by
           diarrhea + total + bmilk + gruel + localok + ors + omilk + waterwfd + rectreat + notreat + dtotal
  /statistics
    mean(diarrhea (f5.1) '')
    count(total (f5.0) '')
    mean(bmilk (f5.1) '')
    mean(gruel (f5.1) '')
    mean(localok (f5.1) '')
    mean(ors (f5.1) '')
    mean(omilk (f5.1) '')
    mean(waterwfd (f5.1) '')
    mean(rectreat (f5.1) '')
    mean(notreat (f5.1) '')
    count(dtotal (f5.0) '')
  /title
    "Table 23: Percentage of under-five children with diarrhea in the last two weeks and treatment with ORS or ORT, Country, Year"
  /caption
    "World Summit for Children Goal => Number 23".
