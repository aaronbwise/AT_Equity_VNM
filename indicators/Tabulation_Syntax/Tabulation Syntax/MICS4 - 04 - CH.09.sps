* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweight1 = hhweight*HH11.

weight by hhweight1.

compute total = 1.
variable labels  total "".
value labels total 1 "Number of household members".

recode HC6 (97,99 = 99) (else = copy) into HC6.
variable labels  HC6 "Percentage of household members in households using:".

recode HC6 (06,07,08,09,10,11 = 100) (else  = 0) into sfuels.
variable labels  sfuels "Solid fuels for cooking [1]".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands bellow.
*value labels total 1 "Nombre de membres des ménages".
*variable labels  HC6 "Pourcentage des membres des ménages dans les ménages utilisant:".
*variable labels  sfuels "Combustibles solides pour la cuisine [1]".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot
         display = none
  /table hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
   hc6 [c] [rowpct.validn,'',f5.1] + sfuels [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var=HC6 total = yes position=after label="Total"
  /slabels position=column visible = no
  /titles title=
   "Table CH.9: Solid fuel use"
		"Percent distribution of household members according to type of cooking fuel used by the household, "+
                                     "and percentage of household members living in households using solid fuels for cooking, " + surveyname
  CAPTION=
    "[1] MICS indicator 3.11".

* Ctables command in French.
*
ctables
  /vlabels variables =  total tot
         display = none
  /table hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
   hc6 [c] [rowpct.validn,'',f5.1] + sfuels [s] [mean,'',f5.1] + total [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var=HC6 total = yes position=after label="Total"
  /slabels position=column visible = no
  /titles title=
   "Tableau CH.9: Utilisation de combustible solide"
		"Répartition en pourcentage des membres des ménages selon le type de combustible de cuisine utilisé par le ménage, "+
                                     "et pourcentage des membres des ménages vivant dans des ménages utilisant des combustibles solides pour la cuisine, " + surveyname
  CAPTION=
    "[1] Indicateur MICS 3.11".
														
new file.
