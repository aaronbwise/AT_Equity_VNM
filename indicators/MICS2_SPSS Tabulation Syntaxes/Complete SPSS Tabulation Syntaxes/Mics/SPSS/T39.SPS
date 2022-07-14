get file = 'wm.sav'.

weight by wmweight.

select if (CM11X = "Y").

compute total = 1.
variable label total "Number of women".

compute dcare = 0.
if (MN3A = 1) dcare = 1.
if (dcare = 0 and MN3B = 2) dcare = 2.
if (dcare = 0 and MN3C = 3) dcare = 3.
if (dcare = 0 and MN3D = 4) dcare = 4.
if (dcare = 0 and MN3E = 5) dcare = 5.
if (dcare = 0 and (MN3F = 6 or MN3F = 7)) dcare = 6.
if (dcare = 0 and MN3Z = 8) dcare = 8.
variable label dcare "Person assisting at delivery".
value label dcare
  1 "Doctor"
  2 "Nurse/midwife"
  3 "Auxiliary midwife"
  4 "Traditional birth attendant"
  5 "Relative/friend"
  6 "Other/missing"
  8 "No assistance received".

compute skilled = 0.
if (dcare = 1 or dcare = 2 or dcare = 3) skilled = 100.
variable label skilled "Any skilled personnel"

tables
  /observation = skilled
  /ftotal = tot1 "Total"
  /table = HI7 + HI6 + melevel + tot1 by dcare + tot1 + skilled + total
  /statistics
    cpct(dcare (f5.1) '':HI7 HI6 melevel)
    mean(skilled (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table 39: Percent distribution of women aged 15-49 with a birth in the last year by type of personnel assisting at delivery"
    "Country, Year"
  /caption
    "World Summit for Children Goal => Numbers 11".
