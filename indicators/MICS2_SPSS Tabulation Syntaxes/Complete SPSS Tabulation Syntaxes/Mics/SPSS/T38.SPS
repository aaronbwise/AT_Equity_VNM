get file = 'wm.sav'

weight by wmweight.

select if (CM11X = "Y").

compute total = 1.
variable label total "Number of women".

compute anc = 0.
if (MN2A = 1) anc = 1.
if (anc = 0 and MN2B = 2) anc = 2.
if (anc = 0 and MN2C = 3) anc = 3.
if (anc = 0 and MN2D = 4) anc = 4.
if (anc = 0 and (MN2F = 6 or MN2F = 7)) anc = 6.
if (anc = 0 and MN2Z = 8) anc = 8.
variable label anc "Person delivering antenatal care".
value label anc
  1 "Doctor"
  2 "Nurse/midwife"
  3 "Auxiliary midwife"
  4 "Traditional birth attendant"
  6 "Other/missing"
  8 "No antenatal care received".

compute skilled = 0.
if (anc = 1 or anc = 2 or anc = 3) skilled = 100.
variable label skilled "Any skilled personnel"

tables
  /observation = skilled
  /ftotal = tot1 "Total"
  /table = HI7 + HI6 + melevel + tot1 by anc + tot1 + skilled + total
  /statistics
    cpct(anc (f5.1) '':HI7 HI6 melevel)
    mean(skilled (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table 38: Percent distribution of women aged 15-49 with a birth in the last year by type of personnel delivering antenatal"
    "ccare, Country, Year"
  /caption
    "World Summit for Children Goals => Numbers 9, 11".
