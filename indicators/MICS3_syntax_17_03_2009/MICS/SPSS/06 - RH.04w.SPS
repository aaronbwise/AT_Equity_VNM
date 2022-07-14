GET file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

compute anc = 0.
if (MN2A = "A") anc = 1.
if (anc = 0 and MN2B = "B") anc = 2.
if (anc = 0 and MN2C = "C") anc = 3.
if (anc = 0 and MN2F = "F") anc = 4.
if (anc = 0 and MN2G = "G") anc = 5.
if (anc = 0 and MN2H = "H") anc =  6.
if (anc = 0 and (MN2X = "X" or MN2A = "?"))  anc =  7.
if (anc = 0 and (MN2Y = "Y")) anc = 8.
variable label anc "Person delivering antenatal care".
value label anc
  1 "Medical doctor"
  2 "Nurse/midwife"
  3 "Auxiliary midwife"
  4 "Traditional birth attendant"
  5 "Community health worker"
  6 "Relative/Friend"
  7 "Other/missing"
  8 "No antenatal care received".

compute ancmore = 0.
if (anc <> 8) ancmore = 100.
variable label ancmore "Percent of pregnant women receiving ANC one or more "+
  "times during pregnancy*".

select if ((CM12 = "Y" or CM12 = "O" or CM12 = "S") and ancmore  = 100).

compute total = 1.
variable label total "Number of women who gave birth in two years preceding "+
  "survey and received antenatal care".
value label total 1 "".

compute layer = 1.
variable label layer "".
value label layer 1 "Percent of pregnant women who had:".

recode MN3A (1 = 100) (else = 0) into weighed.
variable label weighed "Weight measured".

recode MN3B (1 = 100) (else = 0) into pressure.
variable label pressure "Blood pressure measured".

recode MN3C (1 = 100) (else = 0) into urine.
variable label Urine "Urine specimen taken".

recode MN3D (1 = 100) (else = 0) into blood.
variable label blood "Blood sample taken".

tables
  /format = zero
  /observation =  blood pressure urine weighed
  /ftotal = tot1 "Total"
  /table = HH7 + HH6 + wage + melevel + wlthind5 + HC1B + tot1 by
	   layer > (blood + pressure + urine + weighed) +total
  /statistics
    mean(blood (f5.1) '')
    mean(pressure (f5.1) '')
    mean(urine (f5.1) '')
    mean(weighed (f5.1) '')
    count(total (f5.0) '')
  /title
    "Table RH.4w: Antenatal care content" 
    "Percentage of pregnant women receiving specific care as par of the antenatal care provided among women aged "+
		"15-49 years who gave birth in two years preceding the survey and "+
		"received antenatal care, Country, Year".
new file.