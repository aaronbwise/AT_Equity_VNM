include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

select if (wage = 1 or wage = 2).

weight by wmweight.

compute total = 1.
variable labels total "".
value labels total 1 "Number of women age 15-24 years".

compute hadsex = 0.
if (SB1<> 0 and SB3U < 4) hadsex = 100.
variable labels hadsex "Percentage who have had sex in the last 12 months".

do if (hadsex = 100).

+ compute place = 0.
+ if (HA16 = 1 or HA20 = 1 or HA22 = 1 or HA24 = 1 or HA27 = 1)  place = 100.

+ compute tested = 0.
+ if (HA16 = 1 or HA20 = 1 or HA22 = 1 or HA24 = 1) tested = 100.

+ compute tested12 = 0.
+ if (HA23 = 1 or HA25 = 1) tested12 = 100.

+ compute results = 0.
+ if ((HA23 = 1 and (HA17 = 1 or HA21 = 1)) or (HA25 = 1 and HA26 = 1)) results = 100.

+ compute totals = 1.

end if.

variable labels place "Know a place to get tested".
variable labels tested "Have ever been tested".
variable labels tested12 "Have been tested in the last 12 months".
variable labels results "Have been tested in the last 12 months and have been told result [1]".
variable labels totals "".
value labels totals 1 "Number of women age 15-24 years who have had sex in the last 12 months".

recode mstatus (1,2 = 1) (3 = 2).
variable labels mstatus "Marital status".
value labels mstatus
  1 "Ever married/in union"
  2 "Never married/in union".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of women who:".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.
* value labels total 1 "Nombre de femmes âgées de 15-24 ans".
* variable labels hadsex "Pourcentage de celles ayant eu des rapports sexuels au cours des 12 derniers mois".
* variable labels place "connaissent un endroit pour se faire tester".
* variable labels tested "ont déjà été testées".
* variable labels tested12 "ont déjà été testées au cours des 12 derniers mois".
* variable labels results "ont été testées et ont eu le résultat [1]".
* value labels totals 1 "Nombre de femmes âgées de 15-24 ans qui ont eu des rapports sexuels au cours des 12 derniers mois".
* variable labels mstatus "Etat matrimonial".
* value labels mstatus
  1 "Déjà été mariée/vécu avec un homme"
  2 "N'a jamais été mariée/vécu avec un homme".
* value labels layer 0 "Pourcentage de femmes qui:".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total tot layer totals display = none
  /table hh7 [c] + hh6 [c] + wage [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   hadsex [s] [mean,'',f5.1] + total[c][count,'',f5.0] + 
	                  layer [c]  > (place [s] [mean,'',f5.1] + tested [s] [mean,'',f5.1] + tested12 [s] [mean,'',f5.1] + results [s] [mean,'',f5.1]) +  
                   totals[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table HA.6: Knowledge of a place for HIV testing among sexually active young women"
	  "Percentage of women age 15-24 years who have had sex in the last 12 months, " +
	  "and among women who have had sex in the last 12 months, the percentage who know "+
	  "where to get an HIV test, percentage of women who have ever been tested, percentage of " +
	  "women who have been tested in the last 12 months, and percentage of women who have been "+
	  "tested and have been told the result, " + surveyname
  caption = 
	  "[1] MICS indicator 9.7".	

* ctables command in French.
* ctables
  /vlabels variables =  total tot layer totals display = none
  /table hh7 [c] + hh6 [c] + wage [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   hadsex [s] [mean,'',f5.1] +  total[c][count,'',f5.0] + 
	                  layer [c]  > (place [s] [mean,'',f5.1] + tested [s] [mean,'',f5.1] + tested12 [s] [mean,'',f5.1] + results [s] [mean,'',f5.1]) +  
                   totals[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
  	"Tableau HA.6: Connaissance d'un endroit pour le test de dépistage du VIH chez les jeunes femmes sexuellement actives"
	  "Pourcentage de femmes âgées de 15-24 ans qui ont eu des rapports sexuels au cours des 12 derniers mois, et de femmes qui ont eu des " + 
	  "rapports sexuels au cours des 12 derniers mois, pourcentage de celles qui savent où faire le test de dépistage du VIH, " + 
	  "pourcentage de femmes qui ont déjà été testées, pourcentage de femmes qui ont été testées au cours des 12 derniers mois, " + 
	  "et pourcentage ente femmes qui ont été testées et ont reçu le résultat, " + surveyname
  caption = 
	  "[1] Indicateur MICS 9.7".

new file.
