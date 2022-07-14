* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

compute htotal  = 1.
value labels htotal 1 "Number of households".
variable labels htotal "".

recode SI1 (6 = 100) (else = 0) into nosalt.
variable labels nosalt "Percent of households with no salt".

recode SI1 (1,2,3 = 100) (else = 0) into salttest.
variable labels salttest "Percent of households in which salt was tested".

recode SI1 (6 = 0)  (1 = 1) (2 = 2) (3 = 3) (else = sysmis) into iodized.
variable labels iodized "Percent of households with salt test result".
value labels iodized
  0 "Percent of households with no salt"
  1 "Not iodized 0 PPM"
  2 ">0 and <15 PPM"
  3 "15+ PPM [1]".

do if (nosalt  = 100 or salttest  = 100).
compute total = 1.
variable labels total "".
value labels total 1 "Number of households in which salt was tested or with no salt".
end if.

compute tot = 1.
variable labels tot "Total".
value labels tot 1" ".

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 100" ".

* For labels in French uncomment commands bellow.

* value labels htotal 1 "Nombre de ménages".
* variable labels nosalt "Pourcentage de ménages dans lesquels le sel a été analysé".
* variable labels salttest "Pourcentage des ménages ayant".

* variable labels iodized "Pourcentage des ménages ayant le résultat de l'analyse du sel".
* value labels iodized
  0 "Pas de sel"
  1 "Non iodé 0 PPM"
  2 ">0 et <15 PPM"
  3 "15+ PPM [1]".

* value labels total 1 "Nombre de ménages dans  lesquels le sel a été analysé ou n'ayant pas de sel".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = htotal total
             display = none
  /table hh7 [c] + hh6 [c] + windex5 [c]  + tot [c] by 
           salttest [s] [mean,'',f5.1] + htotal [c] [count,'',f5.0] + iodized [c] [rowpct.validn,'',f5.1] +  tot1 [s] [mean,'',f5.1] +  total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table NU.9: Iodized salt consumption"
  "Percent distribution of households by consumption of iodized salt, " + surveyname
  caption ="[1] MICS indicator 2.16".

* Ctables command in French.
*
ctables
  /vlabels variables = htotal total
             display = none
  /table hh7 [c] + hh6 [c] + windex5 [c]  + tot [c] by 
           salttest [s] [mean,'',f5.1] + htotal [c] [count,'',f5.0] + iodized [c] [rowpct.validn,'',f5.1] +  tot1 [s] [mean,'',f5.1] +  total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Tableau NU.9: Consommation de sel iodé"
  "Répartition en pourcentage des ménages selon la consommation de sel iodé, " + surveyname
  caption ="[1]  Indicateur MICS 2.16".
								
new file.
