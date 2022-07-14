include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* the following code assumes that the primary school graduation age is 11 (HL6) (see maxage) and
* that the 6 grade is the last primary grade (ED6B and ED8B) (see higrade); 
* change these values to reflect the situation in your country.

* primary school graduation age.
compute maxage = 11.

* last primary grade.
compute higrade = 6.

* number of children of primary school completion age.
compute pageg = 0.
if (schage = maxage) pageg  = 1.

* number of repeaters.
compute prepeat = 0.
if ((ED6A = 1 and ED6B >= higrade and ED6B < 8)  and ED8A = ED6A and ED8B  = ED6B) prepeat = 1.

* number of children in last primary grade.
compute plgrade = 0.
if ((ED6A = 1 and ED6B >= higrade and ED6B < 8) and prepeat = 0) plgrade  = 1.

* number of children in first secondary grade who were in primary last year.
compute cass = 0.
if (ED6A = 2 and ED8A = 1 and ED8B = higrade) cass  = 1.

* number of children who were in the last grade of primary school the previous year.
compute lgps = 0.
if (ED8A = 1 and ED8B = higrade) lgps  = 1.

compute total = 1.
variable label total "".
value label total 1 "Total".

aggregate outfile = 'tmp1.sav'
  /break    = HL4
  /nplgrade = sum(plgrade)
  /npageg   = sum(pageg)
  /ncass    = sum(cass)
  /nlgps    = sum(lgps).

aggregate outfile = 'tmp2.sav'
  /break    = HH7
  /nplgrade = sum(plgrade)
  /npageg   = sum(pageg)
  /ncass    = sum(cass)
  /nlgps    = sum(lgps).

aggregate outfile = 'tmp3.sav'
  /break    = HH6
  /nplgrade = sum(plgrade)
  /npageg   = sum(pageg)
  /ncass    = sum(cass)
  /nlgps    = sum(lgps).

aggregate outfile = 'tmp4.sav'
  /break    = melevel
  /nplgrade = sum(plgrade)
  /npageg   = sum(pageg)
  /ncass    = sum(cass)
  /nlgps    = sum(lgps).

aggregate outfile = 'tmp5.sav'
  /break    = windex5
  /nplgrade = sum(plgrade)
  /npageg   = sum(pageg)
  /ncass    = sum(cass)
  /nlgps    = sum(lgps).

aggregate outfile = 'tmp6.sav'
  /break    = ethnicity
  /nplgrade = sum(plgrade)
  /npageg   = sum(pageg)
  /ncass    = sum(cass)
  /nlgps    = sum(lgps).

aggregate outfile = 'tmp7.sav'
  /break    = total
  /nplgrade = sum(plgrade)
  /npageg   = sum(pageg)
  /nprepeat = sum(prepeat)
  /ncass    = sum(cass)
  /nlgps    = sum(lgps).

get file = 'tmp1.sav'.
add files
  /file = *
  /file = 'tmp2.sav'
  /file = 'tmp3.sav'
  /file = 'tmp4.sav'
  /file = 'tmp5.sav'
  /file = 'tmp6.sav'
  /file = 'tmp7.sav'.

variable label
  nplgrade  "Number of children attending the last grade of primary"
  /npageg   "Number of children of primary school completion age"
  /nprepeat "Number of repeaters"
  /ncass    "Number of children in first secondary grade who were in primary last year"
  /nlgps    "Number of children who were in the last grade of primary school the previous year".
.
if (npageg > 0) npscr = (nplgrade/npageg)*100.
variable label npscr "Primary school completion rate [1]".

if (nlgps > 0) trse = (ncass/nlgps)*100.
variable label trse "Transition rate to secondary school [2]".

* For labels in French uncomment commands bellow.

* variable label
  npageg   " Nombre d'enfants en âge d'achèvement de l'école primaire"
  /ncass    " Nombre d'enfants qui étaient en dernière classe d'école primaire l'année précédente".
* variable label npscr " Taux d'achèvement à l'école primaire [1]".
* variable label trse " Taux de passage à l'école secondaire [2]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
   /vlabels variables = total
    display = none
  /table hl4 [c] + hh7[c] + hh6[c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
              npscr [s] [mean,'',f5.1] +  npageg [s] [sum,'',f5.0] + trse [s] [mean,'',f5.1] + nlgps [s] [sum,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
    "Table ED.7: Primary school completion and transition to secondary school"
		"Primary school completion rates and transition rate to secondary school, " + surveyname
  CAPTION=
  "[1] MICS indicator 7.7"				
  "[2] MICS indicator 7.8".

* Ctables command in French.
*
ctables
   /vlabels variables = total
    display = none
  /table hl4 [c] + hh7[c] + hh6[c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
              npscr [s] [mean,'',f5.1] +  npageg [s] [sum,'',f5.0] + trse [s] [mean,'',f5.1] + nlgps [s] [sum,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
    "Tableau ED.7: Achèvement de l'école primaire et passage à l'école secondaire"
		"Taux d'achèvement des études primaires et taux de transition à l'école secondaire, " + surveyname
  CAPTION=
  "[1] Indicateur MICS 7.7"				
  "[2] Indicateur MICS 7.8".

new file.

* delete working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
erase file = 'tmp3.sav'.
erase file = 'tmp4.sav'.
erase file = 'tmp5.sav'.
erase file = 'tmp6.sav'.
erase file = 'tmp7.sav'.
