* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweight1 = hhweight*HH11.

weight by hhweight1.

recode HC6 (06,07,08,09,10,11 = 100) (else  = 0) into sfuels.
variable labels  sfuels "Solid fuels for cooking".

select if (sfuels = 100).

compute total = 1.
variable labels  total "".
value labels total 1 "Number of household members in households using solid fuels for cooking".

variable labels  HC7 "Place of cooking:".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands bellow.
* value labels total 1 "Nombre des membres des ménages utilisant des combustibles solides pour faire la cuisine".
* variable labels  HC7 "Lieu de cuisine:".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot
         display = none
  /table hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
   hc7 [c] [rowpct.validn,'',f5.1] +  total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var=HC7 total = yes position=after label="Total"
  /slabels position=column visible = no
  /titles title=
   "Table CH.10: Solid fuel use by place of cooking"
		"Percent distribution of household members in households using solid fuels by place of cooking, " + surveyname.

* Ctables command in French.
*
ctables
  /vlabels variables =  total tot
         display = none
  /table hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
   hc7 [c] [rowpct.validn,'',f5.1] +  total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var=HC7 total = yes position=after label="Total"
  /slabels position=column visible = no
  /titles title=
   "Tableau CH.10: Utilisation de combustible solide par lieu de cuisine"
		"Répartition en pourcentage des membres des ménages dans les ménages utilisant des combustibles solides par lieu de cuisine, " + surveyname.


new file.
