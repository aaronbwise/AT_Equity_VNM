include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (wage = 1 or wage = 2).

compute literate  = 0.
if (WB4 = 2 or WB4 = 3 or WB7 = 3) literate = 100.
variable label literate "Percentage literate [1]".

compute notknown = 0.
if (WB7 = 4 or WB7 = 8 or WB7 = 9) notknown = 100.
variable label notknown "Percentage not known ".

compute total = 1.
variable label total "Number of women age 15-24 years".
value label total 1 "".

compute tot1 = 1.
variable label tot1 "Total".
value label tot1 1 " ".

* For labels in French uncomment commands bellow.

* variable label literate " Pourcentage d'alphabétisées [1]".
* variable label notknown " Pourcentage non connu".
* variable label total " Nombre de femmes âgées de 15-24 ans".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table hh7 [c] + hh6 [c] + welevel [c] + wage[c] + windex5 [c] + ethnicity[c] + tot1[c] by 
  literate [s] [mean,'',f5.1] + notknown [s] [mean,'',f5.1] + total[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
  "Table ED.1: Literacy among young women"
 	 "Percentage of women age 15-24 years who are literate, " + surveyname
  caption = "[1] MICS indicator 7.1; MDG indicator 2.3".

* Ctables command in French.
*
ctables
  /table hh7 [c] + hh6 [c] + welevel [c] + wage[c] + windex5 [c] + ethnicity[c] + tot1[c] by 
  literate [s] [mean,'',f5.1] + notknown [s] [mean,'',f5.1] + total[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
  "Tableau ED.1: Alphabétisation chez les jeunes femmes"
 	 "Pourcentage de femmes âgées de 15-24 ans qui sont alphabétisées, " + surveyname
  caption = "[1] Indicateur MICS 7.1; Indicateur OMD 2.3".
			
new file.
