* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

compute total = 1.
variable labels  total "".
value labels total 1 "Number of households".

compute observed = 2.
if (HW1 = 1) observed = 1.
variable labels  observed "".
value labels observed
  1 "Place for handwashing observed"
  2 "Place for handwashing not observed".

compute sshown = 9.
if (HW3A = "A" or HW3B = "B" or HW3C = "C" or HW3D = "D") sshown = 1.
if (HW4 = 1 and (HW5A  = "A" or HW5B = "B" or HW5C = "C" or HW5D = "D")) sshown  = 2.
if (HW4 <> 1) sshown  = 3.
if (HW4 = 1 and (HW5Y  = "Y")) sshown  = 4.
variable labels  sshown "".
value labels sshown
  1 "Soap observed"
  2 "Soap shown"
  3  "No soap in household"
  4  "Not able/Does not want to show soap"
  9  "Missing".

compute soap = 0.
if (HW3A = "A" or HW3B = "B" or HW3C = "C" or HW3D = "D"or HW5A  = "A" or HW5B = "B" or HW5C = "C" or HW5D = "D") soap = 100.
variable labels  soap "Percentage of households with soap anywhere in the dwelling [1]".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

compute tot1 = 100.
variable labels tot1 "Total".
value labels tot1 100 "".

* For labels in French uncomment commands bellow.
* value labels total 1 " Nombre des ménages".
* value labels observed
  1 " Endroit prévu pour le lavage de mains observé"
  2 " Endroit prévu pour le lavage de mains non observé".
* value labels sshown
  1 " Savon ne montré "
  2 " Savon montré"
  3  " Pas de savon dans le ménage"
  4  " Incapable de/ne veut pas montrer le savon "
  9  " Manquant".
* variable labels  soap " Pourcentage des ménages ayant du savon n'importe où dans le logement [1]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot observed sshown
         display = none
  /table hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
 	   	observed [c] > sshown [c] [layerrowpct.validn,'',f5.1] + tot1 [mean,'',f5.1] + soap [s] [mean,'',f5.1]  + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table WS.10: Availability of soap"
		"Percent distribution of households by availability of soap in the dwelling, " + surveyname
  caption =
   "[1] MICS indicator 4.6".

* Ctables command in French.
*
ctables
  /vlabels variables =  total tot observed sshown
         display = none
  /table hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
 	   	observed [c] > sshown [c] [layerrowpct.validn,'',f5.1] + tot1 [mean,'',f5.1] + soap [s] [mean,'',f5.1]  + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Tableau WS.10: Disponibilité de savon"
		"Répartition en pourcentage des ménages selon la disponibilité de savon dans le logement, " + surveyname
  caption =
   "[1] Indicateur MICS 4.6".

new file.
