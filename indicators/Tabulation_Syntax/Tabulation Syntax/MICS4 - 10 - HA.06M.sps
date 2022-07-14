include "surveyname.sps".

get file = 'mm.sav'.

select if (MWM7 = 1).

select if (mage = 1 or mage = 2).

weight by mmweight.

compute total = 1.
variable labels total "".
value labels total 1 "Number of men age 15-24 years".

compute hadsex = 0.
if (MSB1<> 0 and MSB3U < 4) hadsex = 100.
variable labels hadsex "Percentage who have had sex in the last 12 months".

do if (hadsex = 100).

+ compute place = 0.
+ if (MHA24 = 1 or MHA27 = 1)  place = 100.

+ compute tested = 0.
+ if (MHA24 = 1) tested = 100.

+ compute tested12 = 0.
+ if (MHA25 = 1) tested12 = 100.

+ compute results = 0.
+ if (MHA25 = 1 and MHA26 = 1) results = 100.

+ compute totals = 1.

end if.

variable labels place "Know a place to get tested".
variable labels tested "Have ever been tested".
variable labels tested12 "Have been tested in the last 12 months".
variable labels results "Have been tested in the last 12 months and have been told result [1]".
variable labels totals "".
value labels totals 1 "Number of men age 15-24 years who have had sex in the last 12 months".

recode mmstatus (1,2 = 1) (3 = 2).
variable labels mmstatus "Marital status".
value labels mmstatus
  1 "Ever married/in union"
  2 "Never married/in union".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of men who:".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.
* value labels total 1 "Nombre de hommes âgées de 15-24 ans".
* variable labels hadsex "Pourcentage de celles ayant eu des rapports sexuels au cours des 12 derniers mois".
* variable labels place "connaissent un endroit pour se faire tester".
* variable labels tested "ont déjà été testées".
* variable labels tested12 "ont déjà été testées au cours des 12 derniers mois".
* variable labels results "ont été testées et ont eu le résultat [1]".
* value labels totals 1 "Nombre de hommes âgées de 15-24 ans qui ont eu des rapports sexuels au cours des 12 derniers mois".
* variable labels mmstatus "Etat matrimonial".
* value labels mmstatus
  1 "Déjà été mariée/vécu avec une femme"
  2 "N'a jamais été mariée/vécu avec une femme".
* value labels layer 0 "Pourcentage de hommes qui:".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total tot layer totals display = none
  /table hh7 [c] + hh6 [c] + mage [c] + mmstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   hadsex [s] [mean,'',f5.1] + total[c][count,'',f5.0] + 
	                  layer [c]  > (place [s] [mean,'',f5.1] + tested [s] [mean,'',f5.1] + tested12 [s] [mean,'',f5.1] + results [s] [mean,'',f5.1]) +  
                   totals[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table HA.6M: Knowledge of a place for HIV testing among sexually active young men"
	  "Percentage of men age 15-24 years who have had sex in the last 12 months, " +
	  "and among men who have had sex in the last 12 months, the percentage who know "+
	  "where to get an HIV test, percentage of men who have ever been tested, percentage of " +
	  "men who have been tested in the last 12 months, and percentage of men who have been "+
	  "tested and have been told the result, " + surveyname
  caption = 
	  "[1] MICS indicator 9.7".	

* ctables command in French.
* ctables
  /vlabels variables =  total tot layer totals display = none
  /table hh7 [c] + hh6 [c] + mage [c] + mmstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   hadsex [s] [mean,'',f5.1] +  total[c][count,'',f5.0] + 
	                  layer [c]  > (place [s] [mean,'',f5.1] + tested [s] [mean,'',f5.1] + tested12 [s] [mean,'',f5.1] + results [s] [mean,'',f5.1]) +  
                   totals[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
  	"Tableau HA.6M: Connaissance d'un endroit pour le test de dépistage du VIH chez les jeunes hommes sexuellement actives"
	  "Pourcentage de hommes âgées de 15-24 ans qui ont eu des rapports sexuels au cours des 12 derniers mois, et de hommes qui ont eu des " + 
	  "rapports sexuels au cours des 12 derniers mois, pourcentage de celles qui savent où faire le test de dépistage du VIH, " + 
	  "pourcentage de hommes qui ont déjà été testées, pourcentage de hommes qui ont été testées au cours des 12 derniers mois, " + 
	  "et pourcentage ente hommes qui ont été testées et ont reçu le résultat, " + surveyname
  caption = 
	  "[1] Indicateur MICS 9.7".

new file.
