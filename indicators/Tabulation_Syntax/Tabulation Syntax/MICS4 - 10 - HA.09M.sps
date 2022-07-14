include "surveyname.sps".

get file = 'mm.sav'.

select if (MWM7 = 1).

weight by mmweight.

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage of men who:".

compute total = 1.
variable labels total "".
value labels total 1 "Number of men age 15-49 years".

compute sexever = 0.
if (MSB1 <> 0) sexever = 100.
variable labels sexever "Ever had sex".

compute sex12 = 0.
if (MSB1 <> 0 and MSB3U >= 1 and MSB3U <= 3) sex12 = 100.
variable labels sex12 "Had sex in the last 12 months".

compute morepart = 0.
if (sex12 = 100 and MSB8 = 1) morepart = 100.
variable labels morepart "Had sex with more than one partner in last 12 months [1]".

do if (morepart = 100).
+ compute condom = 0.
+ if (MSB4 = 1) condom = 100.
+ compute tcondom = 1.
end if.

variable labels condom "Percent of men age 15-49 years who had " +
		"more than one sexual partner in the last 12 months, " +
		"who also reported that a condom was used the last time they had sex [2]".
		
variable labels tcondom "".
value labels tcondom 1 "Number of men age 15-49 years who had more than one sexual partner in the last 12 months".

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

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

* value labels layer 0 "Pourcentage de hommes qui:".
* variable labels sexever "ont déjà eu des rapports sexuels".
* variable labels sex12 "ont eu des rapports sexuels au cours des 12 derniers mois".
* variable labels morepart "ont eu des rapports sexuels avec plus d'un partenaire au cours des 12 derniers mois [1]".
* variable labels condom "Pourcentage de hommes âgées de 15-49 ans qui ont eu plus d'un partenaire sexuel " + 
 	"au cours des 12 derniers mois, et ont également déclaré avoir utilisé un préservatif " + 
	 "la dernière fois qu'elles ont eu des rapports sexuels [2]".
* value labels tcondom 1 "Nombre de hommes âgées de 15-49 ans qui ont eu plus d'un partenaire sexuel au cours des 12 derniers mois".
* variable labels mstatus "Etat matrimonial".
* value labels mstatus
  1 "Déjà été mariée/vécu avec une femme"
  2 "N'a jamais été mariée/vécu avec une femme".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = tot total layer tcondom display = none
  /table hh7 [c] + hh6 [c] + mage1 [c] + mage2 [c] + mage3 [c] + mmstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c] > (sexever [s] [mean,'',f5.1] + sex12 [s] [mean,'',f5.1]+ morepart [s] [mean,'',f5.1]) + total [c] [count,'',f5.0] +
 	                 condom [s] [mean,'',f5.1] + tcondom [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table HA.9M: Sex with multiple partners"
		 "Percentage of men age 15-49 years who ever had sex, percentage who had sex in the last 12 months, " +
   "percentage who have had sex with more than one partner in the last 12 months and among those who had sex " +
   "with multiple partners, the percentage who used a condom at last sex, " + surveyname
  caption=
	  "[1] MICS indicator 9.13"						
	  "[2] MICS indicator 9.14"	.

* ctables command in French.
*	ctables
  /vlabels variables = tot total layer tcondom display = none
  /table hh7 [c] + hh6 [c] + mage1 [c] + mage2 [c] + mage3 [c] + mmstatus [c] + mmelevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   layer [c] > (sexever [s] [mean,'',f5.1] + sex12 [s] [mean,'',f5.1]+ morepart [s] [mean,'',f5.1]) + total [c] [count,'',f5.0] +
 	                 condom [s] [mean,'',f5.1] + tcondom [c] [count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Tableau HA.9M: Rapports sexuels avec plusieurs partenaires"
  	"Pourcentage de hommes âgées de 15-49 ans qui ont déjà eu des rapports sexuels, pourcentage de celles ayant eu des " + 
	  "rapports sexuels au cours des 12 derniers mois, pourcentage de celles ayant eu des rapports sexuels avec plus d'un partenaire " + 
	  "au cours des 12 derniers mois et de celles qui ont eu des rapports sexuels avec plusieurs partenaires, pourcentage de celles qui " + 
	  "ont utilisé un préservatif lors du dernier rapport sexuel, " + surveyname
  caption=
	  "[1] Indicateur MICS 9.13"						
	  "[2] Indicateur MICS 9.14".

new file.
