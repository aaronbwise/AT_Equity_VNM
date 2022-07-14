include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

recode CM10 (sysmis = 0) (else = copy).

do if (WB2 >=15 and WB2<=19).
+ compute tot1519 = 1.

+ compute birth = 0.
+ if (CM10 > 0) birth = 100.
+ compute firstch = 0.
+ if (birth = 0 and CP1 = 1) firstch = 100.
+ compute startbirt = 0.
+ if (birth = 100 or CP1 = 1) startbirt  = 100.
+ compute brth15 = 0.
+ if ((wdobfc - wdob)/12 < 15) brth15 = 100.

end if.

variable labels  tot1519 "Number of women age 15-19".
variable labels  birth "Have had a live birth".
variable labels  firstch "Are pregnant with first child".
variable labels startbirt "Have begun childbearing".
variable labels brth15 "Have had a live birth before age 15".

do if (WB2 >=20 and WB2 <=24).
+ compute tot2024 = 1.
+ compute brth18 = 0.
+ if ((wdobfc - wdob)/12 < 18) brth18 = 100.
end if.

variable labels  tot2024 "Number of women age 20-24".
variable labels brth18 "Percentage of women age 20-24 who have had a live birth before age 18 [1]".

compute layer = 0.
value labels layer 0 "Percentage of women age 15-19 who:".
variable lables layer " ".

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1" ".

* For labels in French uncomment commands bellow.

* variable labels  tot1519 " Pourcentage de femmes âgées de 15-19 ans qui:".
* variable labels  birth " ont déjà eu une naissance vivante ".
* variable labels  firstch " sont enceintes d'un premier enfant".
* variable labels startbirt " ont commencé leur vie féconde ".
* variable labels brth15 " ont eu naissance vivante avant l'âge de 15 ans".
* variable labels  tot2024 " Nombre de femmes âgées de 20-24".
* variable labels brth18 " Pourcentage de femmes âgées de 20-24 ans ayant eu une naissance vivante avant l'âge de 18 ans [1]".
* value label layer 0 " Nombre de femmes âgées  de 15-19 ans".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer 
           display = none
  /table hh7 [c] + hh6 [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
       layer [c] > (birth [s] [mean,'',f5.1] + firstch [s] [mean,'',f5.1] + startbirt [s] [mean,'',f5.1] + brth15 [s] [mean,'',f5.1]) + tot1519 [s] [sum,'',f5.0] + brth18 [s] [mean,'',f5.1] + tot2024 [s] [sum,'',f5.0] 
  /slabels position=column visible =no
  /categories var=all empty=exclude missing=exclude
  /title title=
   "Table RH.2: Early childbearing"
		"Percentage of women age 15-19 who have had a live birth or who are pregnant with the first child, " +
                                    "percentage of women age 15-19 who have begun childbearing before age 15, "+
	                  "and the percentage of women age 20-24 who have had a live birth before age 18, " + surveyname
 caption =
               "[1] MICS indicator 5.2".

* Ctables command in French.
*
ctables
  /vlabels variables = layer 
           display = none
  /table hh7 [c] + hh6 [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
       layer [c] > (birth [s] [mean,'',f5.1] + firstch [s] [mean,'',f5.1] + startbirt [s] [mean,'',f5.1] + brth15 [s] [mean,'',f5.1]) + tot1519 [s] [sum,'',f5.0] + brth18 [s] [mean,'',f5.1] + tot2024 [s] [sum,'',f5.0] 
  /slabels position=column visible =no
  /categories var=all empty=exclude missing=exclude
  /title title=
   "Tableau RH.2: Grossesse précoce"
		"Pourcentage de femmes âgées de 15-19 ans ayant déjà eu une naissance vivante, ou enceintes d'un premier enfant,  " +
                                    "pourcentage de femmes âgées de 15-19 ans ayant commencé leur vie féconde, "+
	                  "pourcentage de femmes ayant eu une naissance vivante avant l'âge de 15 ans "
		"et pourcentage de femmes âgées de 20-24 ans ayant une naissance vivante avant l'âge de 18 ans, " + surveyname
 caption =
               "[1] Indicateur MICS 5.2".

new file.
