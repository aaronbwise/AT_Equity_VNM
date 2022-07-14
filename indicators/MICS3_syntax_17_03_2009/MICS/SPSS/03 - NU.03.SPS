get file = 'ch.sav'.

weight by chweight.

select if (UF9 = 1).

do if (cage >= 0 and cage <= 3).
+ compute exbf = 0.
+ if (BF2 = 1 & (BF3B <> 1 & BF3C <> 1 & BF3D <> 1 & BF3E <> 1 & BF3F <> 1 & 
  BF3G <> 1 & BF3H <> 1))	exbf = 100.
end if.
variable label exbf "Children 0-3 months".

do if (cage >= 0 and cage <= 5).
+ compute exbf5 = 0.
+ if (BF2 = 1 & (BF3B <> 1 & BF3C <> 1 & BF3D <> 1 & BF3E <> 1 & BF3F <> 1 & 
  BF3G <> 1 & BF3H <> 1))	exbf5 = 100.
end if.
variable label exbf5 "Children 0-5 months".

do if (cage >= 6 and cage <= 9).
+ compute solids = 0.
+ if (BF2 = 1 and BF3H = 1) solids = 100.
end if.
variable label solids "Children 6-9 months".

do if (cage >= 12 and cage <= 15).
+ compute bf12_15 = 0.
+ if (BF2 = 1) bf12_15 = 100.
end if.
variable label bf12_15 "Children  12-15 months".

do if (cage >= 20 and cage <= 23).
+ compute bf20_23 = 0.
+ if (BF2 = 1) bf20_23 = 100.
end if.
variable label bf20_23 "Children 20-23 months".

tables
  /format = zero
  /observation = exbf exbf5 solids bf12_15 bf20_23
  /ftotal = tot1 "Total"
  /table = HL4 + HH7 + HH6 + melevel + wlthind5 + HC1B + tot1 by 
		exbf + exbf5 + solids + bf12_15 + bf20_23
  /statistics
    mean(exbf (f5.1) 'Percent exclusively breastfed')
    validn(exbf (f5.0) 'Number of children')
    mean(exbf5 (f5.1) 'Percent exclusively breastfed *')
    validn(exbf5 (f5.0) 'Number of children')
    mean(solids (f5.1) 'Percent receiving breastmilk and solid/mushy food **')
    validn(solids (f5.0) 'Number of children')
    mean(bf12_15 (f5.1) 'Percent breastfed***')
    validn(bf12_15 (f5.0) 'Number of children')
    mean(bf20_23 (f5.1) 'Percent breastfed ***')
    validn(bf20_23 (f5.0) 'Number of children')
  /title
    "Table NU.3: Breastfeeding"
		"Percent of living children according to breastfeeding status at each "+
		"age group, Country, Year"
  /caption
    "* MICS indicator 15 "
		"** MICS indicator 17"
		"*** MICS indicator 16".

new file.
