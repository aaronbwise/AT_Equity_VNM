include "surveyname.sps".

get file = 'mm.sav'.

select if (MWM7 = 1).

weight by mmweight.

compute total = 1.
variable labels total "".
value labels total 1 "Number of men".

compute place = 0.
if (MHA24 = 1 or MHA27 = 1)  place = 100.
variable labels place "Know a place to get tested [1]".

compute tested = 0.
if (MHA24 = 1) tested = 100.
variable labels tested "Have ever been tested".

compute tested12 = 0.
if (MHA25 = 1) tested12 = 100.
variable labels tested12 "Have been tested in the last 12 months".

compute results = 0.
if (MHA25 = 1 and MHA26 = 1) results = 100.
variable labels results "Have been tested in the last 12 months and have been told result [2]".

recode mmstatus (1,2 = 1) (3 = 2).
variable labels mmstatus "Marital status".
value labels mmstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode mage (1,2 = 1) (else = sysmis) into mage1.
recode mage (1,2 = copy) (else = sysmis) into mage2.
recode mage (3 = 3) (4,5 = 4) (6,7 = 5) (else = sysmis) into mage3.
variable labels mage1 "Age".
variable labels mage2 " ".
variable labels mage3 " ".
value labels mage1 1 "15-24".
value labels mage2 1 "  15-19" 2 "  20-24".
value labels mage3 3 "25-29" 4 "30-39" 5 "40-49".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of men who:".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

* value labels total 1 "Nombre de hommes".
* variable labels place "connaissent un endroit où se faire tester [1]".
* variable labels tested "ont déjà été testées".
* variable labels tested12 "ont été testées au cours des 12 derniers mois".
* variable labels results "ont été testées et ont reçu le résultat [2]".
* variable labels mmstatus "Etat matrimonial".
* value labels mmstatus
  1 "Déjà été mariée/vécu avec une femme"
  2 "N'a jamais été mariée/vécu avec une femme".
* value labels layer 0 "Pourcentage de hommes qui:".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total tot layer display = none
  /table hh7 [c] + hh6 [c] + mage1 [c] + mage2 [c] + mage3 [c] + mmstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c]  > (place [s] [mean,'',f5.1] + tested [s] [mean,'',f5.1] + tested12 [s] [mean,'',f5.1] + results [s] [mean,'',f5.1]) +  
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
  	"Table HA.5M: Knowledge of a place for HIV testing"
  	"Percentage of men age 15-49 years who know where to get an HIV test, " +
   "percentage of men who have ever been tested, percentage of men who have "+
   "been tested in the last 12 months, and percentage of men who have been tested "+
   "and have been told the result, " + surveyname
  caption = 
	  "[1] MICS indicator 9.5"					
	  "[2] MICS indicator 9.6".	

* ctables command in French.
* ctables
  /vlabels variables = total tot layer display = none
  /table hh7 [c] + hh6 [c] + mage1 [c] + mage2 [c] + mage3 [c] + mmstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c]  > (place [s] [mean,'',f5.1] + tested [s] [mean,'',f5.1] + tested12 [s] [mean,'',f5.1] + results [s] [mean,'',f5.1]) +  
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
  	"Tableau HA.5M: Connaissance d'un endroit pour le test de dépistage du VIH"
	  "Pourcentage de hommes âgées de 15-49 ans qui connaissent là où subir un test de dépistage du VIH, " + 
	  "pourcentage de hommes qui ont déjà été testées, pourcentage de hommes qui ont été testées au cours des 12 derniers mois, " + 
	  "et pourcentage de hommes qui ont été testées mais n'ont pas reçu le résultat, " + surveyname
  caption = 
	  "[1] Indicateur MICS 9.5"					
	  "[2] Indicateur MICS 9.6".	

new file.
