include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

select if (wage = 1 or wage = 2).

weight by wmweight.

compute total = 1.
variable labels total "".
value labels total 1 "Number of women age 15-24".

recode HA1 (1 = 100) (else = 0) into knowaids.
variable labels knowaids "Percentage who have heard of AIDS".

recode HA2 (1 = 100) (else = 0) into onepart.
variable labels onepart "Having only one faithful uninfected sex partner".

recode HA4 (1 = 100) (else = 0) into condom.
variable labels condom "Using a condom every time".

count twoways = onepart condom  (100).
recode twoways (2 = 100) (else = 0) into two.
variable labels two "Percentage of women who know both ways".

recode HA7 (1 = 100) (else = 0) into healthy.
variable labels healthy "Percentage who know that a healthy looking person can have the AIDS virus".

recode HA5 (2 = 100) (else = 0) into mosquito.
variable labels mosquito "Mosquito bites".

recode HA3 (2 = 100) (else = 0) into super.
variable labels super "Supernatural means".

recode HA6 (2 = 100) (else = 0) into food.
variable labels food "Sharing food with someone with AIDS".

* The count of ways should be modified to include the two most common misconceptions together
* with the healthy looking person variable.

count ways = food mosquito healthy (100).

recode ways (3 = 100) (else = 0) into three.
variable labels three "Percentage who reject the two most common misconceptions and know that a healthy looking person can have the AIDS virus".

compute compre = 0.
if (two = 100 and three = 100) compre = 100.
variable labels compre "Percentage with comprehensive knowledge [1]".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Percentage who know transmission can be prevented by:".

compute layer2 = 0.
variable labels layer2 "".
value labels layer2 0 "Percentage who know that HIV cannot be transmitted by:".

recode mstatus (1,2 = 1) (3 = 2).
variable labels mstatus "Marital status".
value labels mstatus
  1 "Ever married/in union"
  2 "Never married/in union".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands below.

* value labels total 1 "Nombre de femmes âgées 15-24 ans".
* variable labels knowaids "Pourcentage de celles qui ont entendu parler du SIDA".
* variable labels onepart "Ayant un partenaire sexuel fidèle non infecté".
* variable labels condom "Utilisant un préservatif à chaque fois".
* variable labels two "Pourcentage de femmes connaissant les deux moyens".
* variable labels healthy "Pourcentage de celles qui savent qu'une personne paraissant en bonne santé peut avoir le virus du SIDA".
* variable labels mosquito "Des piqures de moustiques".
* variable labels super "Des moyens surnaturels".
* variable labels food "Le partage des repas avec quelqu'un ayant le SIDA".
* variable labels three "Pourcentage de celles qui rejettent les deux fausses idées les plus courantes et savent qu'une personne paraissant en bonne santé peut avoir le virus du SIDA".
* variable labels compre "Pourcentage de celles ayant une connaissance approfondie [1]".
* value labels layer 0 "Pourcentage de celles qui savent qu'on peut prévenir la transmission en:".
* value labels layer2 0 "Pourcentage de celles qui savent que le VIH ne peut pas être transmis par:".
* variable labels mstatus "Etat matrimonial".
* value labels mstatus
  1 "Déjà été mariée/vécu avec un homme"
  2 "N'a jamais été mariée/vécu avec un homme".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total layer layer2 tot display = none
  /table hh7 [c] + wage [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   knowaids [s] [mean,'',f5.1] + 
                   layer [c] > (onepart [s] [mean,'',f5.1] + condom [s] [mean,'',f5.1]) + two [s] [mean,'',f5.1] + healthy [s] [mean,'',f5.1] + 
	                  layer2 [c] > (mosquito [s] [mean,'',f5.1] + super [s] [mean,'',f5.1] + food [s] [mean,'',f5.1]) + 
                   three[s] [mean,'',f5.1] + compre [s] [mean,'',f5.1] +
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table HA.2: Knowledge about HIV transmission, misconceptions about HIV/AIDS, and comprehensive knowledge about HIV transmission among young people"
   "Percentage of young women age 15-24 years who know the main ways of preventing HIV transmission, percentage who know that a healthy looking " +
   "person can have the AIDS virus, percentage who reject common misconceptions, and percentage who have comprehensive knowledge about HIV " +
   "transmission, " + surveyname
  caption = 
   "[1] MICS indicator 9.2; MDG indicator 6.3".

* ctables command in French.
* ctables
  /vlabels variables =  total layer layer2 tot display = none
  /table hh7 [c] + wage [c] + mstatus [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   knowaids [s] [mean,'',f5.1] + 
                   layer [c] > (onepart [s] [mean,'',f5.1] + condom [s] [mean,'',f5.1]) + two [s] [mean,'',f5.1] + healthy [s] [mean,'',f5.1] + 
	                  layer2 [c] > (mosquito [s] [mean,'',f5.1] + super [s] [mean,'',f5.1] + food [s] [mean,'',f5.1]) + 
                   three[s] [mean,'',f5.1] + compre [s] [mean,'',f5.1] +
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Tableau HA.2: Connaissance de la transmission du VIH, fausses idées à propos du VIH/SIDA, et connaissance approfondie de la transmission du VIH chez les jeunes femmes"
  	"Pourcentage de femmes âgées de 15-24 ans connaissant les principaux moyens de prévenir la transmission du VIH, " + 
	  "pourcentage de celles sachant qu'une personne paraissant en bonne santé peut avoir le virus du SIDA, " + 
	  "pourcentage de celles rejetant les fausses idées courantes, et pourcentage de celles ayant une connaissance approfondie de la transmission du SIDA, " + surveyname
  caption = 
   "[1] Indicateur MICS 9.2; Indicateur OMD 6.3".

new file.
