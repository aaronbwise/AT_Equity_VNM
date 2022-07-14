* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweight1 = HH11* hhweight.

weight by hhweight1.

compute total = 1.
variable labels  total "Number of household members".
value labels total 1 " ".

recode WS8 (11,12,13,15,21,22,31 = 1) (95 = 3) (else = 2) into type.
variable labels  type "Type of toilet facility used by household".
value labels type 
	1 "Improved sanitation facility" 
	2 "Unimproved sanitation facility"
                  3 " ".

recode WS8 (97,99 = 99) (else = copy) into WS8.
variable labels  WS8 "".

compute tot1 = 1.
variable labels  tot1 "Total".
value labels tot1 1 " ".

compute tot2 = 100.
variable labels  tot2 "Total".
value labels tot2 100 " ".

* For labels in French uncomment commands bellow.

* variable labels  total " Nombre des membres des m�nages".
* variable labels  type " Type de toilettes utilis�es par le m�nage".
* value labels type 
	1 " Toilettes am�lior�es" 
	2 " Toilettes non am�lior�es"
                  3 " ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = ws8
	display = none
  /table hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
               type [c] > ws8 [c] [layerrowpct.validn,'',f5.1] + tot2 [s] [mean,'',f5.1] + total [s] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
   "Table WS.5: Types of sanitation facilities"
		"Percent distribution of household population according to type of toilet facility used by the household, "+
                                    "" + surveyname.

* Ctables command in French.
*
ctables
  /vlabels variables = ws8
	display = none
  /table hh7 [c] + hh6[c] + helevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
               type [c] > ws8 [c] [layerrowpct.validn,'',f5.1] + tot2 [s] [mean,'',f5.1] + total [s] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
   "Tableau WS.5: Utilisation de toilettes am�lior�es"
		"R�partition en pourcentage des population des m�nages selon le type de toilette utilis�e par le m�nage, "+
		"et pourcentage de populations des m�nages utilisant des toilettes am�lior�es, "
                                    "" + surveyname.

new file.
