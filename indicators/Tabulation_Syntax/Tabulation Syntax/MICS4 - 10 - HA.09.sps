include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of women who:".

compute total = 1.
variable labels total "".
value labels total 1 "Number of women age 15-49 years".

compute sexever = 0.
if (SB1 <> 0) sexever = 100.
variable labels sexever "Ever had sex".

compute sex12 = 0.
if (SB1 <> 0 and SB3U >= 1 and SB3U <= 3) sex12 = 100.
variable labels sex12 "Had sex in the last 12 months".

compute morepart = 0.
if (sex12 = 100 and SB8 = 1) morepart = 100.
variable labels morepart "Had sex with more than one partner in last 12 months [1]".

do if (morepart = 100).
+ compute condom = 0.
+ if (SB4 = 1) condom = 100.
+ compute tcondom = 1.
end if.

variable labels condom "Percent of women age 15-49 years who had " +
		"more than one sexual partner in the last 12 months, " +
		"who also reported that a condom was used the last time they had sex [2]".
		
variable labels tcondom "".
value labels tcondom 1 "Number of women age 15-49 years who had more than one sexual partner in the last 12 months".

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

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

* value labels layer 0 "Pourcentage de femmes qui:".
* variable labels sexever "ont d�j� eu des rapports sexuels".
* variable labels sex12 "ont eu des rapports sexuels au cours des 12 derniers mois".
* variable labels morepart "ont eu des rapports sexuels avec plus d'un partenaire au cours des 12 derniers mois [1]".
* variable labels condom "Pourcentage de femmes �g�es de 15-49 ans qui ont eu plus d'un partenaire sexuel " + 
 	"au cours des 12 derniers mois, et ont �galement d�clar� avoir utilis� un pr�servatif " + 
	 "la derni�re fois qu'elles ont eu des rapports sexuels [2]".
* value labels tcondom 1 "Nombre de femmes �g�es de 15-49 ans qui ont eu plus d'un partenaire sexuel au cours des 12 derniers mois".
* variable labels mstatus "Etat matrimonial".
* value labels mstatus
  1 "D�j� �t� mari�e/v�cu avec un homme"
  2 "N'a jamais �t� mari�e/v�cu avec un homme".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = tot total layer tcondom display = none
  /table hh7 [c] + hh6 [c] + wage1 [c] + wage2 [c] + wage3 [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c] > (sexever [s] [mean,'',f5.1] + sex12 [s] [mean,'',f5.1]+ morepart [s] [mean,'',f5.1]) + total [c] [count,'',f5.0] +
 	                 condom [s] [mean,'',f5.1] + tcondom [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table HA.9: Sex with multiple partners"
		 "Percentage of women age 15-49 years who ever had sex, percentage who had sex in the last 12 months, " +
   "percentage who have had sex with more than one partner in the last 12 months and among those who had sex " +
   "with multiple partners, the percentage who used a condom at last sex, " + surveyname
  caption=
	  "[1] MICS indicator 9.13"						
	  "[2] MICS indicator 9.14"	.

* ctables command in French.
*	ctables
  /vlabels variables = tot total layer tcondom display = none
  /table hh7 [c] + hh6 [c] + wage1 [c] + wage2 [c] + wage3 [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c] > (sexever [s] [mean,'',f5.1] + sex12 [s] [mean,'',f5.1]+ morepart [s] [mean,'',f5.1]) + total [c] [count,'',f5.0] +
 	                 condom [s] [mean,'',f5.1] + tcondom [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Tableau HA.9: Rapports sexuels avec plusieurs partenaires"
  	"Pourcentage de femmes �g�es de 15-49 ans qui ont d�j� eu des rapports sexuels, pourcentage de celles ayant eu des " + 
	  "rapports sexuels au cours des 12 derniers mois, pourcentage de celles ayant eu des rapports sexuels avec plus d'un partenaire " + 
	  "au cours des 12 derniers mois et de celles qui ont eu des rapports sexuels avec plusieurs partenaires, pourcentage de celles qui " + 
	  "ont utilis� un pr�servatif lors du dernier rapport sexuel, " + surveyname
  caption=
	  "[1] Indicateur MICS 9.13"						
	  "[2] Indicateur MICS 9.14".

new file.
