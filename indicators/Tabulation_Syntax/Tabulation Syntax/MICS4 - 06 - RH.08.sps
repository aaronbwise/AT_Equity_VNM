include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

*___________________________________________ select women that gave birth in two years preceeding the survey.

select if (CM13 = "Y" or CM13 = "O").

compute total = 1.
variable label total "Number of women who gave birth in two years preceding survey".
value label total 1 "".

compute agebrth = (wdoblc - wdob)/12.
variable label agebrth "Mother's age at birth".
if (CM10 = 1) agebrth = (wdobfc - wdob)/12.

compute bagecat = 9.
if (agebrth < 20) bagecat = 1.
if (agebrth >= 20 and agebrth <35) bagecat = 2.
if (agebrth >= 35 and agebrth <= 49) bagecat = 3.
variable labels bagecat "Mother's age at birth".
value labels bagecat
  1 "Less than 20"
  2 "20-34"
  3 "35-49"
  9 "Missing".

compute layer = 0.
variable label layer "".
value label layer 0 "Percent of pregnant women who had:".

recode MN4A (1 = 100) (else = 0) into pressure.
variable label pressure "Blood pressure measured".
recode MN4B (1 = 100) (else = 0) into urine.
variable label  urine "Urine specimen taken".
recode MN4C (1 = 100) (else = 0) into blood.
variable label blood "Blood test taken".

compute allthree = 0.
if (pressure = 100 & urine = 100 & blood = 100) allthree = 100.
variable label allthree "Blood pressure measured, urine specimen and blood test taken [1]".

compute tot1 = 1.
variable label tot1 "Total".
value label tot1 1 " ".

* For labels in French uncomment commands bellow.

* variable label total " Nombre de femmes qui ont eu une naissance vivante au cours des deux années précédentes".

* value label layer 0 " Pourcentage de femmes enceintes qui se sont fait prendre:".

* variable label pressure " la tension".
* variable label  urine " un échantillon d'urine".
* variable label blood " un échantillon de sang".

* variable label allthree " prise de tension, prélèvement d'échantillon d'urine et de sang [1]".

* variable label agebrth " Age de la mère à la naissance".
* variable labels bagecat " Age de la mère à la naissance".
* value labels bagecat
  1 " Moins de 20"
  2 "20-34"
  3 "35-49"
  9 "Missing".

* Ctables command in English (currently active, comment it out if using different language).
ctables
 /vlabels variable = layer
           display = none
   /table hh7 [c] + hh6 [c] + bagecat [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
 	layer [c] > ( pressure [s] [mean,'',f5.1] + urine [s] [mean,'',f5.1] + blood [s] [mean,'',f5.1] )+
	allthree [s] [mean,'',f5.1] +
	total [s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /title title=
   "Table RH.8: Content of antenatal care" 
    "Percentage of women age 15-49 years who had their blood pressure measured, urine sample taken, and blood sample taken as part of antenatal care, " + surveyname
  caption =
    "[1] MICS indicator 5.6".


* Ctables command in French.
*
ctables
 /vlabels variable = layer
           display = none
   /table hh7 [c] + hh6 [c] + bagecat [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
 	layer [c] > ( pressure [s] [mean,'',f5.1] + urine [s] [mean,'',f5.1] + blood [s] [mean,'',f5.1] )+
	allthree [s] [mean,'',f5.1] +
	total [s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /title title=
   "Tableau RH.8: Contenu des soins prénatals" 
    	"Pourcentage de femmes âgées de 15-49 ans qui se sont fait prendre la tension, un échantillon d'urine, " +
	"un échantillon de sang dans le cadre des soins prénatals, "  + surveyname
  caption =
    "[1] Indicateur MICS 5.6".

new file.
