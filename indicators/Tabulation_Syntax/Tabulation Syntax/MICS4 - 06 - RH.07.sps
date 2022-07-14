include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

*___________________________________________ select women that gave birth in two years preceeding the survey.

select if (CM13 = "Y" or CM13 = "O").

compute total = 1.
value labels total 1 "".
variable label total "Number of women who gave birth in the preceding two years".

compute novisits = 0.
if (MN3 = 1) novisits = 1.
if (MN3 = 2) novisits = 2.
if (MN3 = 3) novisits = 3.
if (MN3 >= 4) novisits = 4.
if (MN3 = 98 or MN3 = 99) novisits = 9.
variable label novisits "Percent of women who had:".
value label novisits
  0 "No antenetal care visits"
  1 "One visit"
  2 "Two visits"
  3 "Three  visits"
  4 "4 or more visits [1]"
  9 "Missing/DK".

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

compute tot1 = 1.
variable label tot1 "Total".
value label tot1 1" ".

compute tot2 = 100.
variable label tot2 "Total".
value label tot2 100" ".

* For labels in French uncomment commands bellow.

* variable label total " Nombre de femmes qui ont eu une naissance vivante au cours des deux années précédentes".
* variable label novisits " Pourcentage de répartition des femmes qui ont fait:".
* value label novisits
  0 " Aucune visite pour soins prénatals"
  1 " Une visite"
  2 " Deux visites"
  3 " Trois  visites"
  4 "4 visites ou plus [1]"
  9 "Manquant/NSP".
* variable label agebrth "Age de la mère à la naissance".
* variable labels bagecat "Age de la mère à la naissance".
* value labels bagecat
  1 " Moins de 20"
  2 "20-34"
  3 "35-49"
  9 "Missing".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table hh7 [c] + hh6 [c] + bagecat [c] + welevel [c] + windex5 [c] + ethnicity [c]+ tot1 [c] by 
  	novisits [c] [rowpct.validn,'',f5.1]+
 	tot2 [s] [mean,'',f5.1] +
	total [s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /title title=
	"Table RH.7: Number of antenatal care visits"
 	"Percent distribution of women who had a live birth during the two years preceding the survey by number of antenatal care visits by any provider, " + surveyname
  caption=
	 "[1] MICS indicator 5.5b; MDG indicator 5.5".
	 
* Ctables command in French.
*
ctables
  /table hh7 [c] + hh6 [c] + bagecat [c] + welevel [c] + windex5 [c] + ethnicity [c]+ tot1 [c] by 
  	novisits [c] [rowpct.validn,'',f5.1]+
 	tot2 [s] [mean,'',f5.1] +
	total [s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /title title=
	"Tableau RH.7: Nombre de visites prénatales"
 	"Répartition en pourcentage des femmes ayant eu une naissance vivante au cours des deux années précédant " +
	"l'enquête par le nombre de visites prénatales faites par n'importe quel personnel de santé, " + surveyname
   caption=
	 "[1] Indicateur 5.5b; Indicateur OMD 5.5".
					

new file.
