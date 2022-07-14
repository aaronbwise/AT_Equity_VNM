include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* Select children who are of primary school age; this definition is
* country-specific and should be changed to reflect the situation in your
* country.

select if (schage >= 6 and schage <= 11).

compute primary  = 0.
if (ED6A >= 1 and ED6A <= 2) primary =  100.
* Set test for "Age at the begining of school year" equal to age in last grade of primary and test for ED4B equal to the last grade of primary.
if (schage = 11 and ED4A = 1 and ED4B = 6 and ED5 = 2) primary  = 100.
variable label primary "".
variable label HL4 "".

compute tot1 = 1.
variable label tot1 "Total".
value label tot1 1 " ".

* Ctables command in French.
ctables
   /vlabels variables = hl4 primary
    display = none
  /table hh7[c] + hh6[c] + schage [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
              hl4[c] > primary[s][mean,'Net attendance ratio (adjusted) [1]',f5.1,validn,'Number of children',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /categories var=hl4 total=yes position = after label = "Total"
  /slabels position=column
  /title title=
  "Table ED.4: Primary school attendance"
  "Percentage of children of primary school age attending primary or secondary school (Net attendance ratio), " + surveyname
  caption ="[1] MICS indicator 7.4; MDG indicator 2.1".

* Ctables command in English (currently active, comment it out if using different language).
*
ctables
   /vlabels variables = hl4 primary
    display = none
  /table hh7[c] + hh6[c] + schage [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
              hl4[c] > primary[s][mean,'Ratio net de fréquentation scolaire  (ajusté) [1]',f5.1,validn,'Nombre denfants',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /categories var=hl4 total=yes position = after label = "Total"
  /slabels position=column
  /title title=
  "Tableau ED.4: Fréquentation de l'école primaire	"
  "Pourcentage d'enfants d'âge scolaire primaire fréquentant l'école primaire ou secondaire (fréquentation scolaire nette ajustée), " + surveyname
  caption ="[1] Indicateur MICS 7.4; Indicateur OMD 2.1".

new file.
