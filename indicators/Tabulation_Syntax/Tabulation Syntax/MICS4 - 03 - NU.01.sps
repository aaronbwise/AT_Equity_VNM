* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

do if (wazflag = 0).
+ recode WAZ2 (-2.00 thru hi = 0) (else = 100) into wa2.
+ recode WAZ2 (-3.00 thru hi = 0) (else = 100) into wa3.
+ compute wamean = WAZ2.
+ compute totwa = 1.
else.
+ compute wa2 = 9.
+ compute wa3 = 9.
end if.
variable labels wa2 "Weight for age:".
variable labels wa3 "Weight for age:".
variable labels wamean "Weight for age:".
variable labels totwa "Weight for age:".

do if (hazflag = 0).
+ recode HAZ2 (-2.00 thru hi = 0) (else = 100) into ha2.
+ recode HAZ2 (-3.00 thru hi = 0) (else = 100) into ha3.
+ compute hamean = HAZ2.
+ compute totha = 1.
else.
+ compute ha2 = 9.
+ compute ha3 = 9.
end if.
variable labels ha2 "Height for age:".
variable labels ha3 "Height for age:".
variable labels hamean "Height for age:".
variable labels totha "Height for age:".

do if (whzflag = 0).
+ recode WHZ2 (-2.00 thru hi = 0) (else = 100) into wh2.
+ recode WHZ2 (-3.00 thru hi = 0) (else = 100) into wh3.
+ recode WHZ2 (lo thru +2.00 = 0) (else = 100) into wh3a.
+ compute whmean = WHZ2.
+ compute totwh = 1.
else.
+ compute wh2 = 9.
+ compute wh3 = 9.
+ compute wh3a = 9.
end if.
variable labels wh2 "Weight for height:".
variable labels wh3 "Weight for height:".
variable labels wh3a "Weight for height:".
variable labels whmean "Weight for height:".
variable labels totwh "Weight for height:".

missing values wa2 wa3 ha2 ha3 wh2 wh3 wh3a (9).

compute total = 1.
variable labels total "Total".
value labels total 1 " ".

* For labels in French uncomment commands bellow.
 * variables labels wa2 "Poids- pour-âge:".
 * variable labels wa3 "Poids- pour-âge:".
 * variable labels wamean "Poids- pour-âge:".
 * variable labels totwa "Poids- pour-âge:".

 * variable labels ha2 "Taille-pour-âge:".
 * variable labels ha3 "Taille-pour-âge:".
 * variable labels hamean "Taille-pour-âge:".
 * variable labels totha "Taille-pour-âge:".

 * variable labels wh2 "Poids-pour-taille:".
 * variable labels wh3 "Poids-pour-taille:".
 * variable labels wh3a "Poids-pour-taille:".
 * variable labels whmean "Poids-pour-taille:".
 * variable labels totwh "Poids-pour-taille:".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /table hl4 [c] + hh6 [c] + hh7 [c] + cage_6 [c] + melevel [c] + windex5 [c] + ethnicity [c]+ total [c] by 
                                    wa2 [s] [mean,'% below -2 sd [1]',f5.1] +
		wa3 [s] [mean,'% below -3 sd [2]',f5.1] +
		wamean [s] [mean,'Mean Z-Score (SD)',f5.1] +
                                    totwa [s] [validn,'Number of children' f5.0] +
 		ha2 [s] [mean,'% below -2 sd [3]',f5.1] +
		ha3 [s] [mean,'% below -3 sd [4]',f5.1] +
                                    hamean [s] [mean,'Mean Z-Score (SD)',f5.1] +
                                    totha [s] [validn,'Number of children',f5.0] +
  		wh2 [s] [mean,'% below -2 sd [5]',f5.1] +
		wh3 [s] [mean,'% below -3 sd [6]',f5.1] +
		wh3a [s] [mean,'% above +2 sd',f5.1] +
                                    whmean [s] [mean,'Mean Z-Score (SD)',f5.1] +
                                    totwh [s] [validn,'Number of children',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
  "Table NU.1: Nutritional status of children" 
  "Percentage of children under age 5 by nutritional status according to three anthropometric indices: " +
  "weight for age, height for age, and weight for height" + surveyname
  caption=
    "[1] MICS indicator 2.1a and MDG indicator 1.8"
    "[2] MICS indicator 2.1b"
    "[3] MICS indicator 2.2a, [4] MICS indicator 2.2b"
    "[5] MICS indicator 2.3a, [6] MICS indicator 2.3b".

* Ctables command in French.
*
ctables
  /table hl4 [c] + hh6 [c] + hh7 [c] + cage_6 [c] + melevel [c] + windex5 [c] + ethnicity [c]+ total [c] by 
                                    wa2 [s] [mean,'pourcentage inférieur à -2 sd [1]',f5.1] +
		wa3 [s] [mean,'pourcentage inférieur à -3 sd [2]',f5.1] +
		wamean [s] [mean,'Moyenne Score Z- (SD)',f5.1] +
                                    totwa [s] [validn,'Nombre d enfants de moins de 5 ans',f5.0] +
 		ha2 [s] [mean,'pourcentage inférieur à -2 sd [3]',f5.1] +
		ha3 [s] [mean,'pourcentage inférieur à -3 sd [4]',f5.1] +
                                    hamean [s] [mean,'Moyenne Score Z- (SD)',f5.1] +
                                    totha [s] [validn,'Nombre d enfants de moins de 5 ans',f5.0] +
  		wh2 [s] [mean,'pourcentage inférieur à -2 sd [5]',f5.1] +
		wh3 [s] [mean,'pourcentage inférieur à -3 sd [6]',f5.1] +
		wh3a [s] [mean,'pourcentage supérieur à  +2 sd',f5.1] +
                                    whmean [s] [mean,'Moyenne Score Z- (SD)',f5.1] +
                                    totwh [s] [validn,'Nombre d enfants de moins de 5 ans',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column
  /title title=
  "Table NU.1: Etat nutritionnel des enfants" 
  "Pourcentage des enfants de moins de 5 ans par état nutritionnel selon trois indices anthropométriques: " +
  " poids-pour-âge, taille-pour-âge, et poids-pour-taille, " + surveyname
  caption=
    "[1] Indicateur MICS 2.1a et Indicateur OMD 1.8"
    "[2] Indicateur MICS 2.1b"
    "[3] Indicateur MICS 2.2a, [4] Indicateur MICS 2.2b"
    "[5] Indicateur MICS 2.3a, [6] Indicateur MICS 2.3b".	
											
new file.
