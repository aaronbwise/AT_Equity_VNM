include "surveyname.sps".

get file = 'ch.sav'.

weight by chweight.

select if (UF9 = 1) .

compute totalc = 1.
variable label totalc "".
value label totalc 1 "Number of children".

compute regist = 1.
variable label regist "".
value label regist 1 "Children under age 5 whose birth is registered with civil authorities".

compute brthregis = 0.
if (BR1 = 1 or BR1 = 2 or BR2 = 1) brthregis = 100.
variable label brthregis "Total registered [1]".

compute layer = 0.
variable label layer "".
value label layer 0 "Has birth certificate".

compute sertfseen = 0.
if (BR1 = 1) sertfseen = 100.
variable label sertfseen "Seen".

compute certfnots = 0.
if (BR1 = 2) certfnots = 100.
variable label certfnots "Not seen".

compute nocertf = 0.
if (BR1 <> 1 and BR1 <> 2 and BR2 = 1) nocertf = 100.
variable label nocertf "No birth certificate".

compute notregist = 0.
variable label notregist "".
value label notregist 0 "Children under age 5 whose birth is not registered".

do if (brthregis = 0).
+ compute brknow = 0.
+ if (BR3 = 1) brknow = 100.
end if.
variable label brknow "Percent of children whose mother/ caretaker knows how to register birth".

if (brthregis = 0) nrtotal = 1.
variable label nrtotal "".
value label nrtotal 1 "Number of children without birth registration".

compute total = 1.
variable label total "Total".
value label total 1" ".

* For labels in French uncomment commands bellow.
* value label totalc 1 " Nombre denfants".
* value label regist 1 " Enfants de moins de 5 ans dont la naissance est enregistrée auprès de l'état civil".
* variable label brthregis " Total enregistré [1]".
* value label layer 0 " A un certificat de naissance".
* variable label sertfseen " Vu".
* variable label certfnots " Non vu".
* variable label nocertf " Pas de certificat de naissance".
* value label notregist 0 " Enfants de moins de 5 ans dont la naissance n'est pas enregistrée".
* variable label brknow " Pourcentage denfants dont la mère sait comment enregistrer la naissance".
* value label nrtotal 1 " Nombre denfants dont la naissance n'est pas enregistrée".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = regist notregist layer nrtotal totalc
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
   regist [c] > (layer[c] > (sertfseen [s] [mean,'',f5.1] + certfnots [s] [mean,'',f5.1])+ nocertf [s] [mean,'',f5.1] +  brthregis [s] [mean,'',f5.1]) + totalc [c] [count,'',f5.0] +
   notregist [c] > (brknow[s] [mean,'',f5.1] + nrtotal [c] [count,'',f5.0])
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
   "Table CP.1: Birth registration"
  	"Percentage of children under age 5 by whether birth is registered and percentage "+
  	"of children not registered whose mothers/caretakers know how to register birth, " + surveyname
  caption="[1] MICS indicator 8.1".

* Ctables command in French.
*
ctables
  /vlabels variables = regist notregist layer nrtotal totalc
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c] + windex5 [c] + ethnicity [c] + total [c] by 
   regist [c] > (layer[c] > (sertfseen [s] [mean,'',f5.1] + certfnots [s] [mean,'',f5.1])+ nocertf [s] [mean,'',f5.1] +  brthregis [s] [mean,'',f5.1]) + totalc [c] [count,'',f5.0] +
   notregist [c] > (brknow[s] [mean,'',f5.1] + nrtotal [c] [count,'',f5.0])
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
   "Tableau CP.1: Enregistrement des naissances"
  	"Pourcentage d'enfants de moins de 5 ans selon que leurs naissances sont ou non enregistrées et que les mères/gardiennes "+
  	"savent comment enregistrer la naissance, " + surveyname
  caption="[1] Indicateur MICS 8.1".

new file.
