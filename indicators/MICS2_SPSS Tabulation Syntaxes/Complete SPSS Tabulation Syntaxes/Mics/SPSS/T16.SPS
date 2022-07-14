get file = 'ch.sav'.

weight by chweight.

do if (cage >= 0 and cage <= 3).
+ compute exbf = 0.
+ if (BF2 = 1) exbf = 100.
+ if (BF3B = 1) exbf = 0.
+ if (BF3C = 1) exbf = 0.
+ if (BF3D = 1) exbf = 0.
+ if (BF3E = 1) exbf = 0.
+ if (BF3F = 1) exbf = 0.
+ if (BF3G = 1) exbf = 0.
end if.
variable label exbf "Exclusive breastfeeding".

do if (cage >= 6 and cage <= 9).
+ compute solids = 0.
+ if (BF3G = 1) solids = 100.
end if.
variable labels solids "Solid foods".

do if (cage >= 12 and cage <= 15).
+ compute bf12_15 = 0.
+ if (BF2 = 1) bf12_15 = 100.
end if.
variable labels bf12_15 "Breastfed".

do if (cage >= 20 and cage <= 23).
+ compute bf20_23 = 0.
+ if (BF2 = 1) bf20_23 = 100.
end if.
variable labels bf20_23 "Breastfed".

tables
  /observation = exbf solids bf12_15 bf20_23
  /ftotal = tot1 "Total"
  /table = HL3 + HI7 + HI6 + melevel + tot1 by exbf + solids + bf12_15 + bf20_23
  /statistics
    mean(exbf (f5.1) 'Children 0-3 months')
    validn(exbf (f5.0) 'Number of children')
    mean(solids (f5.1) 'Children 6-9 months')
    validn(solids (f5.0) 'Number of children')
    mean(bf12_15 (f5.1) 'Children 12-15 months')
    validn(bf12_15 (f5.0) 'Number of children')
    mean(bf20_23 (f5.1) 'Children 20-23 months')
    validn(bf20_23 (f5.0) 'Number of children')
  /title
    "Table 16: Percent of living children by breastfeeding status, Country, Year"
  /caption
    "World Summit for Children Goal => Number 16".
