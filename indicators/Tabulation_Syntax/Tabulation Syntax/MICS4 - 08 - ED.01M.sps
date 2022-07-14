include "surveyname.sps".

get file = 'mn.sav'.

select if (MWM7 = 1).

weight by mnweight.

select if (mage = 1 or mage = 2).

compute literate  = 0.
if (MWB4 = 2 or MWB4 = 3 or MWB7 = 3) literate = 100.
variable label literate "Percentage literate [1]".

compute notknown = 0.
if (MWB7 = 4 or MWB7 = 8 or MWB7 = 9) notknown = 100.
variable label notknown "Percentage not known ".

compute total = 1.
variable label total "Number of men age 15-24 years".
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
  /table hh7 [c] + hh6 [c] + mmelevel [c] + mage[c] + windex5 [c] + ethnicity[c] + tot1[c] by 
  literate [s] [mean,'',f5.1] + notknown [s] [mean,'',f5.1] + total[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
  "Table ED.1M: Literacy among young men"
 	 "Percentage of men age 15-24 years who are literate, " + surveyname
  caption = "[1] MICS indicator 7.1; MDG indicator 2.3".

* Ctables command in French.
*
ctables
  /table hh7 [c] + hh6 [c] + mmelevel [c] + mage[c] + windex5 [c] + ethnicity[c] + tot1[c] by 
  literate [s] [mean,'',f5.1] + notknown [s] [mean,'',f5.1] + total[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
  "Tableau ED.1: Alphabétisation chez les jeunes hommes"
 	 "Pourcentage de hommes âgées de 15-24 ans qui sont alphabétisées, " + surveyname
  caption = "[1] Indicateur MICS 7.1; Indicateur OMD 2.3".
			
new file.
