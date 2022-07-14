* Call include file for the working directory and the survey name.
include "surveyname.sps".

* Open men data file.
get file = 'mn.sav'.

* Select only interviewed men.
select if (MWM7 = 1).

* Weight the data by the men weight.
weight by mnweight.

* Create marital status with separate groups for formerly married.
do if (MMA1 = 1 or MMA1 = 2).
+ compute mstatus1 = 1.
else if (MMA5 = 1 or MMA5 = 2).
+ compute mstatus1 = MMA6+1.
+ if (MMA6 = 9) mstatus1 = 9.
else if (MMA5 = 3).
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

compute tot1 = 1.
variable labels tot1 "Total".
value labels tot1 1" ".

compute wp = 0.
variable labels wp " ".
compute nmm = 0.
variable labels nmm "Number of men".

* For labels in French uncomment commands bellow.
* variable labels
  mstatus1 "Situation de famille/Union"
  /nmm "Nombre de hommes".

*value labels
  mstatus1 
     1 "Mariée actuellement/vit avec un homme"
     2 "Veuve"
     3 "Divorcée"
     4 "Séparée"
     5 "Jamais mariée/vécu avec un homme"
     9 "Manquant".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variable = wp display = none
  /table hh7 [c] + hh6 [c] + mage [c] + mstatus1 [c] + mmelevel [c] + windex5 + ethnicity [c] + tot1 [c] by
           wp [s] [colpct.count,'Weighted percent' f5.1] + nmm [s] [count, 'Weighted', f5.0, ucount, 'Unweighted', f5.0]
  /categories var=all empty=exclude missing=exclude
  /title title=
	"Table HH.4M: Men's background characteristics"
 	 "Percent  and frequency distribution of men age 15-59 years by selected background characteristics, " + surveyname.	


* Ctables command in French.
*
ctables
  /vlabels variable = wp display = none
  /table hh7 [c] + hh6 [c] + mage [c] + mstatus1 [c] + mmelevel [c] + windex5 + ethnicity [c] + tot1 [c] by
           wp [s] [colpct.count,'Weighted percent' f5.1] + nmm [s] [count, 'Weighted', f5.0, ucount, 'Unweighted', f5.0]
  /categories var=all empty=exclude missing=exclude
  /title title=
	"Tableau HH.4M: Caractéristiques de base des hommes"								
	"Pourcentage et fréquence de répartition des hommes âgées de 15-59 ans selon les caractéristiques de base sélectionnées, " + surveyname.			

new file.
