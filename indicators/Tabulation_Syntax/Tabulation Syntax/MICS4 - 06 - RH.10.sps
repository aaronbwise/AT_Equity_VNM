include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

*___________________________________________ select women that gave birth in two years preceeding the survey.

select if (CM13 = "Y" or CM13 = "O").

compute total = 1.
variable labels total "Number of women who gave birth in preceding two years".
value labels total 1 "".

compute agebrth = (wdoblc - wdob)/12.
variable labels agebrth "Mother's age at birth".
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

compute novisits = 0.
if (MN3 >= 1 and MN3 <= 3) novisits = 1.
if (MN3 >= 4) novisits = 2.
if (MN3 = 98 or MN3 = 99) novisits = 9.
variable labels novisits "Percent of women who had:".
value labels novisits
  0 "None"
  1 "1-3 visits"
  2 "4+ visits"
  9 "Missing/DK".

compute delivery = 0.
if (MN18 >= 21 and MN18 <= 26) delivery = 11.
if (MN18 >= 31 and MN18 <= 36) delivery = 12.
if (MN18 = 11 or MN18 = 12) delivery = 13.
if (MN18 = 96) delivery = 96.
if (MN18 = 98 or MN18 = 99) delivery = 98.
variable labels delivery "Place of delivery".
value labels delivery 
  11 "Public sector health facility"
  12 "Private sector health facility"
  13 "Home"
  96 "Other"
  98 "Missing/DK".

compute instdlv = 0.
if (delivery = 11 or delivery = 12) instdlv = 100.
variable labels instdlv "Delivered in health facility [1]".

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1 " ".

compute tot2 = 100.
variable labels tot2 "Total".
value labels tot2 100 " ".

* For labels in French uncomment commands bellow.

* variable labels total " Nombre de femmes qui ont eu une naissance vivante au cours des deux années précédentes".
* variable labels bagecat "Age de la mère à la naissance".
* value labels bagecat
  1 "Moins de 20"
  2 "20-34"
  3 "35-49"
  9 "Manquant".
* variable labels novisits "Nombre de visites pour soins prénatals:".
* value labels novisits
  0 "Aucune"
  1 "1-3 visits"
  2 "4+ visits"
  9 " Manquant".
* variable labels delivery "Place of delivery".
* value labels delivery 
  11 " Structure de santé du secteur public"
  12 " Structre de santé du secteur privé"
  13 " A domicile"
  96 " Autre"
  98 " Manquant".
* variable labels instdlv " Accouchement dans une structure de santé [1]".

* Ctables command in English (currently active, comment it out if using different language).

ctables
  /table hh7 [c] + hh6 [c] + bagecat [c] + novisits[c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  	delivery [c] [rowpct.validn,'',f5.1] + 
                  tot2 [s] [mean,'',f5.1] +
	instdlv [s] [mean,'',f5.1] +
  	total[s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /title title=
    "Table RH.10: Place of delivery"
    "Percent distribution of women age 15-49 with a birth in two years preceding the survey by place of delivery, " + surveyname
  caption=
    "[1] MICS indicator 5.8".

* Ctables command in French.
*ctables
  /table hh7 [c] + hh6 [c] + bagecat [c] + novisits[c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  	delivery [c] [rowpct.validn,'',f5.1] + 
                  tot2 [s] [mean,'',f5.1] +
	instdlv [s] [mean,'',f5.1] +
  	total[s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /title title=
    "Tableau RH.10: Lieu d'accouchement"
	"Répartition en pourcentage des femmes âgées de 15-49 ans qui ont eu une naissance vivante au cours " +
	"des deux années précédant l'enquête, selon le lieu d'accouchement, " + surveyname
  caption=
    "[1] Indicateur MICS 5.8".
					
new file.
