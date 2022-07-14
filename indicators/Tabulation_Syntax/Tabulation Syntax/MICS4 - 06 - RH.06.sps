include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

*___________________________________________ select women that gave birth in two years preceeding the survey.

select if (CM13 = "Y" or CM13 = "O").

compute total = 1.
value labels total 1 "".
variable label total "Number of women who gave birth in the preceding two years".

compute anc = 0.
if (MN2A = "A") anc = 11.
if (anc = 0 and MN2B = "B") anc = 12.
if (anc = 0 and MN2C = "C") anc = 13.
if (anc = 0 and MN2F = "F") anc = 21.
if (anc = 0 and MN2G = "G") anc = 22.
if (anc = 0 and (MN2X = "X" or MN2A = "?")) anc = 97.
if (anc = 0) anc = 98.
variable label anc "Person providing antenatal care".
value label anc
  11 "Doctor"
  12 "Nurse / Midwife"
  13 "Auxiliary midwife"
  21 "Traditional birth attendant"
  22 "Community health worker"
  97 "Other/missing"
  98 "No antenatal care received".

compute agebrth = (wdoblc - wdob)/12.
variable label agebrth "Mother's age at birth".
if (CM10 = 1) agebrth = (wdobfc - wdob)/12.

compute bagecat = 9.
if (agebrth < 20) bagecat = 1.
if (agebrth >= 20 and agebrth < 35) bagecat = 2.
if (agebrth >= 35 and agebrth <= 49) bagecat = 3.
variable labels bagecat "Mother's age at birth".
value labels bagecat
  1 "Less than 20"
  2 "20-34"
  3 "35-49"
  9 "Missing".

compute skilled = 0.
if (anc = 11 or anc = 12 or anc = 13) skilled = 100.
variable label skilled "At least once by skilled personnel  [1]".

compute tot1 = 1.
variable label tot1 "Total".
value label tot1 1" ".

compute tot2 = 100.
variable label tot2 "Total".
value label tot2 100" ".

* For labels in French uncomment commands bellow.

* variable label total " Nombre de femmes ayant donné naissance au cours des deux années précédentes".
* variable label anc " Personne dispensant les soins prénatals".
* value label anc
  11 " Médecin"
  12 " Infirmier (e)/ Sage femme"
  13 " Sage femme auxiliaire"
  21 " Accoucheuse traditionnelle"
  22 " Agent de santé communautaire"
  97 " Autre"
  98 " Pas de soins prénatals reçus".

* variable label agebrth "Age de la mère à la naissance".
* variable labels bagecat "Age de la mère à la naissance".
* value labels bagecat
  1 " Moins de 20"
  2 "20-34"
  3 "35-49"
  9 "Missing".
* variable label skilled " N'importe quel personnel qualifié [1]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table hh7 [c] + hh6 [c] + bagecat [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  	anc [c] [rowpct.validn,'',f5.1]+
	tot2 [s] [mean,'',f5.1] +
	skilled [s] [mean,'',f5.1] +
	total [s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /title title=
  "Table RH.6: Antenatal care provider"
 	"Percent distribution of women age 15-49 who gave birth in the two years preceding the survey by "+
                  "type of personnel providing antenatal care during the pregnancy for the last birth, " + surveyname
  caption=
    "[1] MICS indicator 5.5a; MDG indicator 5.5".

* Ctables command in French.
*
ctables
  /table hh7 [c] + hh6 [c] + bagecat [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  	anc [c] [rowpct.validn,'',f5.1]+
	tot2 [s] [mean,'',f5.1] +
	skilled [s] [mean,'',f5.1] +
	total [s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /title title=
  "Tableau RH.6: Couverture des soins prénatals"
  	"Répartition en pourcentage des femmes âgées de 15-49 ans ayant donné naissance au cours des deux années précédant " +
	"l'enquête par type de personnel dispensant les soins prénatals, " + surveyname
  caption=
    "[1] Indicateur MICS 5.5a; Indicateur OMD 5.5".								

new file.
