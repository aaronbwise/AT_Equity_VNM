get file = 'hl.sav'.

weight by hhweight.

recode ED16A (7 = 100) (sysmis = copy) (else = 0) into medlevel.
variable label medlevel "Level of education".

recode ED16B (97 = 100) (sysmis = copy) (else = 0) into medgrade.
variable label medgrade "Year of education".

recode CL4 (97 = 100) (sysmis = copy) (else = 0) into mhours.
variable label mhours "Number of hours worked".

tables
  /observation= medlevel medgrade mhours
  /table=medlevel + medgrade + mhours  by (statistics)
  /statistics
    mean(medlevel (F5.1) 'Percent missing')
    validn(medlevel (F5.0) 'Number')
    mean(medgrade (F5.1) 'Percent missing')
    validn(medgrade (F5.0) 'Number')
    mean(mhours (F5.1) 'Percent missing')
    validn(mhours (F5.0) 'Number')
  /title
    "Table 3: Percentage of cases missing information for selected questions, Country, Year".

get file = 'wm.sav'.

weight by wmweight.

compute mbdate = 0.
if (WI3AM = 97) mbdate = 100.
if (WI3AY = 9997) mbdate = 100.
variable label mbdate "Complete birth date".

compute mttdate = 0.
if (sysmis(TT6AM) or sysmis(TT6AY)) mttdate = 9.
missing values mttdate (9).
if (TT6AM = 97) mttdate = 100.
if (TT6AY = 9997) mttdate = 100.
variable label mttdate "Date of last tetanus toxoid injection".

recode HA15 (7 = 100) (sysmis = copy) (else = 0) into mhivtest.
variable label mhivtest "Ever been tested for HIV".

tables
  /observation= mbdate mttdate mhivtest
  /table=mbdate + mttdate + mhivtest  by (statistics)
  /statistics
    mean(mbdate (F5.1) 'Percent missing')
    validn(mbdate (F5.0) 'Number')
    mean(mttdate (F5.1) 'Percent missing')
    validn(mttdate (F5.0) 'Number')
    mean(mhivtest (F5.1) 'Percent missing')
    validn(mhivtest (F5.0) 'Number')
  /title
    "Table 3: Percentage of cases missing information for selected questions, Country, Year".

get file = 'ch.sav'.

weight by chweight.

compute mbdate = 0.
if (BR3D = 97) mbdate = 100.
if (BR3M = 97) mbdate = 100.
if (BR3Y = 9997) mbdate = 100.
variable label mbdate "Complete birth date".

recode CI1 (7 = 100) (else = 0) into mdiarr.
variable label mdiarr "Diarrhoea in last 2 weeks".

recode weight (97,999.9 = 100) (else = 0) into mweight.
variable label mweight "Weight".

recode height (997,999.9 = 100) (else = 0) into mheight.
variable label mheight "Height".

tables
  /observation= mbdate mdiarr mweight mheight
  /table=mbdate + mdiarr + mweight + mheight  by (statistics)
  /statistics
    mean(mbdate (F5.1) 'Percent missing')
    validn(mbdate (F5.0) 'Number')
    mean(mdiarr (F5.1) 'Percent missing')
    validn(mdiarr (F5.0) 'Number')
    mean(mweight (F5.1) 'Percent missing')
    validn(mweight (F5.0) 'Number')
    mean(mheight (F5.1) 'Percent missing')
    validn(mheight (F5.0) 'Number')
  /title
    "Table 3: Percentage of cases missing information for selected questions, Country, Year".
