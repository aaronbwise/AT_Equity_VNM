include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* Select children who are of primary school entry age at the beginning of the current (or the most recent) school year.;
* This definition is country-specific and should be changed to reflect the situation in your country.

select if (schage = 6).

compute total = 1.
variable label total  "".
value label total 1 "Number of children of primary school entry age".

compute first  = 0.
* Grade 2 of primary school is accepted to take into account early starters.
if (ED6A = 1 and (ED6B  = 1 or ED6B = 2)) first =  100.
variable label first "Percentage of children of primary school entry age entering grade 1 [1]".

compute tot = 1.
variable label tot "Total".
value label tot 1 " ".

* For labels in French uncomment commands bellow.
* value label total 1 " Nombre d'enfants en âge d'entrer en primaire".
* variable label first " Pourcentage d'enfants d'âge scolaire primaire allant en classe 1 [1]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
   /vlabels variables = total
    display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
               first [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
    "Table ED.3: Primary school entry"
		"Percentage of children of primary school entry age entering grade 1 (net intake rate), " + surveyname
  caption=
    "[1] MICS indicator 7.3".

* Ctables command in French.
*
ctables
   /vlabels variables = total
    display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
               first [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
    "Tableau ED.3: Entrée à l'école primaire"
		"Pourcentage d'enfants d'âge scolaire primaire allant en classe 1 (taux net d'admission), " + surveyname
  caption=
    "[1] Indicateur MICS 7.3".		

new file.
