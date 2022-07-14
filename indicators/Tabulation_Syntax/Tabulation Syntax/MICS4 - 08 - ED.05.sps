include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

* Select children who are of secondary school age; this definition is
* country-specific and should be changed to reflect the situation in your
* country.

select if (schage >= 12 and schage <= 17).

* Make a new category for mother's education level for children over 17 years. 
* Refer to the existing melevel categories and create new one.
recode melevel (sysmis = 6) (else = copy).
value label melevel 
1 "None"
2 "Primary"
3 "Secondary"
4 "Higher"
5 "Not in the household"
6 "Cannot be determined".

compute secondary  = 0.
if (ED6A >= 2 and ED6A <= 3) secondary =  100.
* Set test for "Age at the begining of school year" equal to age in last grade of secondary and test for ED4B equal to the last grade of secondary.
if (schage = 17 and ED4A = 2 and ED4B = 6 and ED5 = 2) secondary  = 100.

compute prim  = 0.
if (ED6A = 1) prim =  100.

variable label prim "".
variable label secondary "".
variable label HL4 "".

compute tot1 = 1.
variable label tot1 "Total".
value label tot1 1 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
   /vlabels variables = hl4 secondary prim
    display = none
  /table hh7[c] + hh6[c] + schage [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
              hl4[c] > (secondary [s] [mean,'Net attendance ratio (adjusted) [1]',f5.1] + 
                           prim [s] [mean,'Percent attending primary school',f5.1] +
                           secondary [s] [validn,'Number of children',f5.0])
  /categories var=all empty=exclude missing=exclude
  /categories var=hl4 total=yes position = after label = "Total"
  /slabels position=column
  /title title=
  "Table ED.5: Secondary school attendance"
  	"Percentage of children of secondary school age attending secondary school or higher (adjusted net attendance ratio), " +
  	"and percentage of children attending primary school, " + surveyname
  caption ="[1] MICS indicator 7.5".

* Ctables command in French.
*
ctables
   /vlabels variables = hl4 secondary prim
    display = none
  /table hh7[c] + hh6[c] + schage [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
              hl4[c] > (secondary [s] [mean,'Ratio net de fréquentation (ajusté) [1]',f5.1] + 
                           prim [s] [mean,'Pourcentage fréquentation école primaire',f5.1] +
                           secondary [s] [validn,'Nombre denfants',f5.0])
  /categories var=all empty=exclude missing=exclude
  /categories var=hl4 total=yes position = after label = "Total"
  /slabels position=column
  /title title=
  "Tableau ED.5: Fréquentation de l'école secondaire"
  	"Pourcentage d'enfants d'âge scolaire secondaire fréquentant l'école secondaire ou supérieure (ratio net de féquentation ajusté) " +
  	"et pourcentage d'enfants fréquentant l'école primaire, " + surveyname
  caption ="[1] Indicateur MICS 7.5".

new file.
