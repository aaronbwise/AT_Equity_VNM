* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open women data file.
get file = 'wm.sav'.

* Select only interviewed women.
select if (WM7 = 1).

* Weight the data by the women weight.
weight by wmweight.

* Create marital status with separate groups for formerly married.
do if (MA1 = 1 or MA1 = 2).
+ compute mstatus1 = 1.
else if (MA5 = 1 or MA5 = 2).
+ compute mstatus1 = MA6+1.
+ if (MA6 = 9) mstatus1 = 9.
else if (MA5 = 3).
+ compute mstatus1 = 5.
else.
+ compute mstatus1 = 9.
end if.
variable labels mstatus1 "Marital/Union status".
value labels mstatus1
	1 "Currently married/in union"
	2 "Widowed"
	3 "Divorced"
	4 "Separated"
	5 "Never married/in union"
	9 "Missing".

* Rename question cm1 and rename value labels.
variable labels CM1 "Motherhood status".
value labels CM1
	1 "Ever gave birth"
	2 "Never gave birth".

* Recode births in last 2 years.
compute BL2Y = 9.
if (cm13='Y') BL2Y = 1.
if (cm13='N' or CM1 = 2) BL2Y = 2.
variable labels BL2Y "Births in last two years".
value labels BL2Y 1 "Had a birth in last two years" 2 "Had no birth in last two years" 9 "Missing".

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1" ".

compute wp = 0.
variable labels wp " ".
compute nwm = 0.
variable labels nwm "Number of women".

* For labels in French uncomment commands bellow.
* variable labels
  mstatus1 "Situation de famille/Union"
  /CM1 "Etat de maternité"
  /BL2Y "Naissances au cours des deux dernières années"
  /nwm "Nombre de femmes".

*value labels
  mstatus1 
     1 "Mariée actuellement/vit avec un homme"
     2 "Veuve"
     3 "Divorcée"
     4 "Séparée"
     5 "Jamais mariée/vécu avec un homme"
     9 "Manquant"
  /CM1 1 "A déjà mis au monde" 2 "N'a jamais mis au monde"
  /BL2Y 1 "A eu une naissance au cours des deux dernières années" 2 "N'a pas eu de naissance au cours des deux dernières années".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variable = wp display = none
  /table hh7 [c] + hh6 [c] + wage [c] + mstatus1 [c] + CM1 [c] + BL2Y [c] + welevel [c] + windex5 + ethnicity [c] + tot1 [c] by
           wp [s] [colpct.count,'Weighted percent' f5.1] + nwm [s] [count, 'Weighted', f5.0, ucount, 'Unweighted', f5.0]
  /categories var=all empty=exclude missing=exclude
  /title title=
	"Table HH.4: Women's background characteristics"
 	 "Percent and frequency distribution of women age 15-49 years by selected characteristics, " + surveyname.

* Ctables command in French.
*
ctables
  /vlabels variable = wp display = none
  /table hh7 [c] + hh6 [c] + wage [c] + mstatus1 [c] + CM1 [c] + BL2Y [c] + welevel [c] + windex5 + ethnicity [c] + tot1 [c] by
           wp [s] [colpct.count,'Weighted percent' f5.1] + nwm [s] [count, 'Weighted', f5.0, ucount, 'Unweighted', f5.0]
  /categories var=all empty=exclude missing=exclude
  /title title=
	"Tableau HH.4: Caractéristiques de base des femmes"								
	"Pourcentage et fréquence de répartition des femmes âgées de 15-49 ans selon les caractéristiques de base sélectionnées, " + surveyname.			

new file.
