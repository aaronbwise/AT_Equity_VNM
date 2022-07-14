include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

select if (HL6 >= 0 and HL6 <= 17). 

compute total = 1.
variable labels total "".
value labels total 1 "Number of children age 0-17 years".

recode HL6 (0 thru 4 = 1) (5 thru 9 = 2) (10 thru 14 = 3) (15 thru 17 = 4) into agegrp.
variable labels agegrp "Age".
value labels agegrp
  1 "0-4 years"
  2 "5-9 years"
  3 "10-14 years"
  4 "15-17 years".

compute status = 0.
if (HL11 = 1 and HL12 <> 0 and HL13 = 1 and HL14 <> 0) status = 1.
if (HL11 = 2 and HL13 = 1 and HL14 = 0) status = 2.
if (HL11 = 1 and HL12 = 0 and HL13 = 2) status = 3.
if (HL11 = 1 and HL12 = 0 and HL13 = 1 and HL14 = 0) status = 4.
if (HL11 = 2 and HL13 = 2) status = 5.
if (HL11 = 1 and HL12 <> 0 and HL13 = 1 and HL14 = 0) status = 6.
if (HL11 = 1 and HL12 <> 0 and HL13 = 2) status = 7.
if (HL11 = 1 and HL12 = 0 and HL13 = 1 and HL14 <> 0) status = 8.
if (HL11 = 2 and HL13 = 1 and HL14 <> 0) status = 9.
if (HL11 = 8 or HL11 = 9 or HL13 = 8 or HL13 = 9) status = 10.

variable labels status "".
value labels status
  1 "Living with both parents"
  2 "Only father alive"
  3 "Only mother alive"
  4 "Both alive"
  5 "Both dead"
  6 "Father alive"
  7 "Father dead"
  8 "Mother alive"
  9 "Mother dead"
  10 "Impossible to determine".

recode status (1=1) (2 thru 5=2) (6 thru 7=3) (8 thru 9=4) (10=5) into status1.
variable labels status1 "".
value labels status1 
  1 " "
  2 "Living with neither parent"
  3 "Living with mother only"
  4 "Living with father only"
  5 " ".

compute noparent = 0.
if (status1 = 2) noparent = 100.
variable labels noparent "Not living with a biological parent [1]".

compute oneboth = 0.
if (HL11 = 2 or HL13 = 2) oneboth = 100.
variable labels oneboth "One or both parents dead [2]".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 1 "".

* For labels in French uncomment commands below.

* value labels total 1 "Nombre d'enfants âgés de 0-17 ans".
* value labels status
  1 "Vit avec les deux parents"
  2 "Seul le père en vie"
  3 "Seule la mère en vie"
  4 "Les deux sont en vie"
  5 "Les deux sont décédés"
  6 "Père en vie"
  7 "Père décédé"
  8 "Mère en vie"
  9 "Mère décédée"
  10 "Impossible de déterminer".
* value labels status1 
  1 " "
  2 "Ne vit avec aucun des deux parents"
  3 "Ne vit qu'avec la mère"
  4 "Ne vit qu'avec le père"
  5 " ".
* variable labels noparent "Ne vit pas avec un parent biologique [1]".
* variable labels oneboth "L'un ou les deux parents décédé (s) [2]".

* ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total tot status1 status display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] +  agegrp [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   status1 [c]  > status [c] [layerrowpct.validn,'',f5.1] + tot1[s] [mean,'',f5.1] +
                   noparent [s] [mean,'',f5.1] + oneboth [s] [mean,'',f5.1] +
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Table HA.12: Children's living arrangements and orphanhood"
		 "Percent distribution of children age 0-17 years according to living arrangements, " +
   "percentage of children age 0-17 years in households not living with a biological parent " +
   "and percentage of children who have one or both parents dead, " + surveyname
  caption=
	  "[1] MICS indicator 9.17"																
	  "[2] MICS indicator 9.18"	.

* ctables command in French.
* ctables
  /vlabels variables = total tot status1 status display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] +  agegrp [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                   status1 [c]  > status [c] [layerrowpct.validn,'',f5.1] + tot1[s] [mean,'',f5.1] +
                   noparent [s] [mean,'',f5.1] + oneboth [s] [mean,'',f5.1] +
                   total[c][count,'',f5.0]
  /categories var = all empty = exclude missing = exclude
  /slabels position = column visible = no
  /title title=
   "Tableau HA.12: Modes de vie des enfants et état d'orphelin "
	  "Répartition en pourcentage des enfants âgés de 0-17 ans selon les modes de vie, pourcentage d'enfants âgés de 0-17 ans " + 
	  "ne vivant pas avec un parent biologique dans le ménage, et pourcentage d'enfants dont l'un ou les deux parents sont décédés, " + surveyname
  caption=
	  "[1] Indicateur MICS 9.17"																
	  "[2] Indicateur MICS 9.18".

new file.
