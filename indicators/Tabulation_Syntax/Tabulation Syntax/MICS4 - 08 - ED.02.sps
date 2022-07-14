include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* Select children who are attending first grade of primary education regardless of age.
select if (ED6A = 1 and ED6B = 1).

compute total = 1.
variable label total  "".
value label total 1 "Number of children attending first grade of primary school".

compute first  = 0.
if (ED8A = 0) first =  100.
variable label first "Percentage of children attending first grade who attended preschool in previous year [1]".

compute tot = 1.
variable label tot "Total".
value label tot 1 " ".

* For labels in French uncomment commands bellow.

* value label total 1 " Nombre d'enfants en première classe d'école primaire".
* variable label first " Pourcentage d'enfants en première classe du primaire et ayant suivi un enseignement préscolaire au cours de l'année précédente [1]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
   /vlabels variables = total
    display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
               first [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
     "Table ED.2: School readiness"
		"Percentage of children attending first grade of primary school who attended pre-school the previous year, " + surveyname
  caption=
    "[1] MICS indicator 7.2".

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
     "Tableau ED.2: Préparation à l'école"
		"Pourcentage d'enfants en première classe d'école primaire et ayant suivi un enseignement préscolaire l'année précédente, " + surveyname
  caption=
    "[1] Indicateur MICS 7.2".

new file.
