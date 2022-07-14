include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

select if (CM13 = "Y" or CM13 = "O").

compute total = 1.
variable labels total "".
value labels total 1 "Number of women who gave birth in the 2 years preceding the survey".

* Women who received antenatal care during the last pregnancy.
compute anc = 0.
if (MN2A = "A" or MN2B = "B" or MN2C = "C") anc = 100.
variable labels anc "Received antenatal care from a health care professional for last pregnancy".

* Women who received HIV counselling includes those who were given infornation about
* (a) babies getting AIDS virus from their mothers.
* (b) things that can be done to prevent getting the AIDS virus, and.
* (c) getting tested for the AIDS virus. 
* All three should be "Yes": HA15A=1 and HA15B=1 and HA15C=1.
compute hivprev = 0.
if (HA15A = 1 and HA15B = 1 and HA15C = 1) hivprev = 100.
variable labels hivprev "Received HIV counselling during antenatal care [1]".

* Women who were offered a test (HA15D=1) and were tested (HA16=1), .
* and received the results (HA17=1) during antenatal care form the numerator of MICS indicator 9.9.
compute hivtest = 0.
if (HA15D = 1 and HA16 = 1) hivtest = 100.
variable labels hivtest "Were offered an HIV test and were tested for HIV during antenatal care".

compute hivresp = 0.
if (hivtest = 100 and HA17 = 1) hivresp = 100.
variable labels hivresp "Were offered an HIV test and were tested for HIV during antenatal care, and received the results [2]".

* Combine receipt of HIV counseling and testing coverage.
compute prevres = 0.
if (hivprev = 100 and hivresp = 100) prevres = 100.
variable labels prevres "Received HIV counselling, were offered an HIV test, accepted and received the results".

recode mstatus (1,2 = 1) (3 = 2).
variable labels mstatus "Marital status".
value labels mstatus
  1 "Ever married/in union"
  2 "Never married/in union".

recode wage (1,2 = 1) (else = sysmis) into wage1.
recode wage (1,2 = copy) (else = sysmis) into wage2.
recode wage (3 = 3) (4,5 = 4) (6,7 = 5) (else = sysmis) into wage3.
variable labels wage1 "Age".
variable labels wage2 " ".
variable labels wage3 " ".
value labels wage1 1 "15-24".
value labels wage2 1 "  15-19" 2 "  20-24".
value labels wage3 3 "25-29" 4 "30-39" 5 "40-49".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percent of women who:".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

* value labels total 1 "Nombre de femmes ayant donn� naissance au cours des 2 ann�es pr�c�dant l'enqu�te".
* variable labels anc "ont re�u des soins pr�natals d'un professionnel de la sant� lors de la derni�re grossesse".
* variable labels hivprev "ont re�u des conseils en mati�re de VIH durant les soins pr�natals [1]".
* variable labels hivtest "ont re�u une offre de test de d�pistage du VIH et ont �t� test�es pour le VIH durant les soins pr�natals".
* variable labels hivresp "ont re�u une offre de test de d�pistage du VIH et ont �t� test�es pour le VIH durant les soins pr�natals, et ont re�u les r�sultats [2]".
* variable labels prevres "ont re�u des conseils en mati�re de VIH, une offre de test de d�pistage du VIH, accept� et re�u les r�sultats".
* variable labels mstatus "Etat matrimonial".
* value labels mstatus
  1 "D�j� �t� mari�e/v�cu avec un homme"
  2 "N'a jamais �t� mari�e/v�cu avec un homme".
* value labels layer 0 "Pourcentage de femmes qui:".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot layer display = none
  /table hh7 [c] + hh6 [c] + wage1 [c] + wage2 [c] + wage3 [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c]  > (anc [s] [mean,'',f5.1] + hivprev [s] [mean,'',f5.1] + hivtest [s] [mean,'',f5.1] + hivresp [s] [mean,'',f5.1] + prevres [s] [mean,'',f5.1]) +  
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table HA.7: HIV counselling and testing during antenatal care"
		 "Among women age 15-49 who gave birth in the last 2 years, " +
   "percentage of women who received antenatal care from a health " +
   "professional during the last pregnancy, percentage who received HIV counselling, " +
   "percentage who were offered and accepted an HIV test and received the results, " + surveyname
  caption = 
	  "[1] MICS indicator 9.8"
	  "[2] MICS indicator 9.9".

* ctables command in French.
* ctables
  /vlabels variables =  total tot layer display = none
  /table hh7 [c] + hh6 [c] + wage1 [c] + wage2 [c] + wage3 [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c]  > (anc [s] [mean,'',f5.1] + hivprev [s] [mean,'',f5.1] + hivtest [s] [mean,'',f5.1] + hivresp [s] [mean,'',f5.1] + prevres [s] [mean,'',f5.1]) +  
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Tableau HA.7:Conseils et test en mati�re de VIH durant les soins pr�natals"
		 "Parmi les femmes �g�es de 15-49 ans ayant donn� naissance au cours des 2 derni�res ann�es, pourcentage de celles " + 
		 "qui ont re�u des soins pr�natals d'un professionnel de la sant� au cours de la derni�re grossesse, pourcentage de celles " + 
		 "qui ont re�u des conseils en mati�re de VIH, pourcentage de celles � qui on a propos� et qui ont accept� un test de d�pistage du " + 
		 "VIH et re�u les r�sultats, " + surveyname
  caption = 
	  "[1] Indicateur MICS 9.8"
	  "[2] Indicateur MICS 9.9".

new file.
