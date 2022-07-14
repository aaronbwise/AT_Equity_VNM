* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

select if (cage <= 23).

recode cage (low thru 5 = 1) (6 thru 11 = 2) (12 thru 23 = 3) into agecat.
variable labels agecat "Age".
value labels agecat
  1 "0-5 months"
  2 "6-11 months"
  3 "12-23 months".

compute ctotal = 1.
variable labels ctotal "Number of children age 0-23 months:".
value labels ctotal 1"".

compute bfeeding = 0.
if (BF18 = 1) bfeeding = 100.
variable labels bfeeding "Percentage of children age 0-23 months fed with a bottle with a nipple [1]".

compute total = 1.
variable labels total  "Total".
value labels total 1 " ".

* For labels in French uncomment commands bellow.

* value labels agecat
  1 "0-5 mois"
  2 "6-11 mois"
  3 "12-23 mois".
* variable labels ctotal "Nombre d'enfants âgés de 0-23 mois:".
* variable labels bfeeding "Pourcentage d'enfants âgés de 0-23 mois ayant rçu le biberon [1]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table hl4 [c] + agecat [c] + hh7 [c] + hh6 [c] +  melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
           bfeeding [s] [mean,'',f5.1] +
           ctotal [s] [count,'' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visable = no
  /titles title=
  "Table NU.8: Bottle feeding"
  "Percentage of children age 0-23 months who were fed with a bottle with a nipple during the previous day, " + surveyname
  caption=
   "[1] MICS indicator 2.11".	

* Ctables command in French.
*
ctables
  /table hl4 [c] + agecat [c] + hh7 [c] + hh6 [c] +  melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
           bfeeding [s] [mean,'',f5.1] +
           ctotal [s] [count,'' f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visable = no
  /titles title=
  "Tableau NU.8: Allaitement au biberon"
  "Pourcentage d'enfants agés de 0-23 mois qui ont été allaités avec un biberon la veille, " + surveyname
  caption=
   "[1] Indicateur MICS 2.11".														

new file.
