include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

*___________________________________________ select women that gave birth in two years preceeding the survey.

select if (CM13 = "Y" or CM13 = "O").

compute total = 1.
variable label total "Number of women who gave birth in preceding two years".
value label total 1 "".

compute agebrth = (wdoblc - wdob)/12.
variable label agebrth "Mother's age at birth".
if (CM10 = 1) agebrth = (wdobfc - wdob)/12.

compute bagecat = 9.
if (agebrth < 20) bagecat = 1.
if (agebrth >= 20 and agebrth <35) bagecat = 2.
if (agebrth >= 35 and agebrth <= 49) bagecat = 3.
variable labels bagecat "Mother's age at birth".
value labels bagecat
  1 "Less than 20"
  2 "20-34"
  3 "35-49"
  9 "Missing".

compute delivery = 0.
if (MN18 >= 21 and MN18 <= 26) delivery = 11.
if (MN18 >= 31 and MN18 <= 36) delivery = 12.
if (MN18 = 11 or MN18 = 12) delivery = 13.
if (MN18 = 96) delivery = 96.
if (MN18 = 98 or MN18 = 99) delivery = 98.
variable label delivery "Place of delivery".
value label delivery 
  11 "Public sector health facility"
  12 "Private sector health facility"
  13 "Home"
  96 "Other"
  98 "Missing/DK".

compute dcare = 0.
if (MN17A = "A") dcare = 11.
if (dcare = 0 and MN17B = "B") dcare = 12.
if (dcare = 0 and MN17C = "C") dcare = 13.
if (dcare = 0 and MN17F = "F") dcare = 14.
if (dcare = 0 and MN17G = "G") dcare = 15.
if (dcare = 0 and MN17H = "H") dcare = 16.
if (dcare = 0 and (MN17X = "X" or MN17A = "?")) dcare = 97.
if (dcare = 0 and MN17Y = "Y") dcare = 98.
variable label dcare "Person assisting at delivery".
value label dcare 
  11 "Doctor"
  12 "Nurse / Midwife"
  13 "Auxiliary midwife"
  14 "Traditional birth attendant"
  15 "Community health worker"
  16 "Relative / Friend"
  97 "Other/missing"
  98 "No attendant".		

compute skilled = 0.
if (dcare = 11 or dcare = 12 or dcare = 13) skilled = 100.
variable label skilled "Any skilled personnel [1]".

recode MN19 (1 = 100) (else = 0) into csection.
variable label csection "Percent delivered by C-section [2]".

compute tot1 = 1.
variable label tot1 "Total".
value label tot1 1 " ".

compute tot2 = 100.
variable label tot2 "Total".
value label tot2 100 " ".

* For labels in French uncomment commands bellow.

* variable label total " Nombre de femmes qui ont eu une naissance vivante au cours des deux années précédentes".

* variable labels bagecat "Age de la mère à la naissance".
* value labels bagecat
  1 " Moins de 20"
  2 "20-34"
  3 "35-49"
  9 "Missing".

* variable label delivery " Lieu d'accouchement".
* value label delivery 
  11 " Structure sanitaire du secteur public"
  12 " Structure sanitaire du secteur privé"
  13 " A domcile"
  96 " Autre"
  98 " Manquant/NSP".

* variable label dcare " Personne assistant à l'accouchement".
* value label dcare 
  11 " Médecin"
  12 " Infirmer (e)/ Sage femme"
  13 " Sage femme auxiliaire"
  14 " Accoucheuse traditionnelle"
  15 " Agent de santé communautaire"
  16 " Parent/Ami"
  97 " Autre"
  98 " Pas d'assistant".		

* variable label skilled " Accouchement avec un assistant qualifié [1]".
* variable label csection " Pourcentage d'accouchement par césarienne [2]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table hh7 [c] + hh6 [c] + bagecat [c] + delivery [c] +welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  	dcare [c] [rowpct.validn,'',f5.1] + 
                  tot2 [s] [mean,'',f5.1] +
                  skilled [s] [mean,'',f5.1] +
	csection [s] [mean,'',f5.1] +
  	total [s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /title title=
   "Table RH.9: Assistance during delivery"
    "Percent distribution of women age 15-49 who had a live birth in the two years preceding the survey by person assisting " +
    "at delivery and percentage of births delivered by C-section, " + surveyname
  caption=
	"[1] MICS indicator 5.7; MDG indicator 5.2"
	"[2] MICS indicator 5.9".	

* Ctables command in French.
*
ctables
  /table hh7 [c] + hh6 [c] + bagecat [c] + delivery [c] +welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
  	dcare [c] [rowpct.validn,'',f5.1] + 
                  tot2 [s] [mean,'',f5.1] +
                  skilled [s] [mean,'',f5.1] +
	csection [s] [mean,'',f5.1] +
  	total [s] [count,'',f5.0]
  /categories var=all empty=exclude 
  /slabels position=column visible=no
  /title title=
   "Tableau RH.9: Assistance au cours de l'accouchement"
    "Répartition en pourcentage des femmes âgées de 15-49 ans qui ont eu une naissance au cours des deux années précédant l'enquête " +
    "selon la personne apportant son assistance pendant l'accouchement et pourcentage d'accouchements par césarienne," + surveyname
  caption=
	"[1] Indicateur MICS 5.7; Indicateur OMD 5.2"
	"[2] Indicateur MICS 5.9".											

new file.
