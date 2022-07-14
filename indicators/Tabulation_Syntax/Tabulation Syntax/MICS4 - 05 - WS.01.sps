* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweight1 = HH11*hhweight.

weight by hhweight1.

compute total = 1.
variable labels  total "Number of household members".
value labels total 1 " ".

recode WS1 (98,99 = 99) (else = copy) into WS1.

compute improved = 0.
if (WS1 = 11 or  WS1 = 12 or WS1 = 13 or WS1 = 14 or WS1 = 21 or WS1 = 31 or WS1 = 41 or WS1 = 51) improved = 100.
if ((WS2 = 11 or WS2 = 12 or WS2 = 13 or WS2 = 14 or WS2 = 21 or WS2 = 31 or WS2 = 41 or WS2 = 51) and WS1 = 91) improved = 100.
variable labels  improved "Percentage using improved sources of drinking water [1]".

recode improved (100 = 1) (else = 2) into type.
variable labels  WS1 "".
variable labels  type "Main source of drinking water".
value labels type 
	1 "Improved sources"
	2 "Unimproved sources".

compute tot1 = 1.
variable labels  tot1 "Total".
value labels tot1 1 " ".

compute tot2 = 100.
variable labels  tot2 "Total".
value labels tot2 100 " ".

* For labels in French uncomment commands bellow.
* variable labels  total " Nombre des membres des ménages".
* variable labels  improved " Pourcentage de ménages utilisant des sources d'eau de boisson améliorées [1]".
* variable labels  type " Principale source d'eau potable".
* value labels type 
	1 " Sources améliorées"
	2 " Sources non améliorées".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = ws1
         display = none
  /table hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
    type [c] > ws1 [c] [layerrowpct.validn,' ',f5.1] + 
    tot2 [s] [mean,'',f5.1] +
    improved [s] [mean,'',f5.1] +
    total [s] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title = 
   "Table WS.1: Use of improved water sources "
   "Percent distribution of household population according to main source of drinking water " +
   "and percentage of household population using improved drinking water sources, " + surveyname
 caption=
    "[1] MICS indicator 4.1; MDG indicator 7.8"
    "* Households using bottled water as the main source of drinking water are classified into " +
     "improved or unimproved drinking water users according to the water source used for other purposes such as cooking and handwashing".

* Ctables command in French.
*
ctables
  /vlabels variables = ws1
         display = none
  /table hh7 [c] + hh6 [c] + helevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
    type [c] > ws1 [c] [layerrowpct.validn,' ',f5.1] + 
    tot2 [s] [mean,'',f5.1] +
    improved [s] [mean,'',f5.1] +
    total [s] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
   /title title = 
   "Tableau WS.1: Utilisation de sources d'eau améliorées "
   "Répartition en pourcentage des populations des ménages selon la principale source d'eau potable et  pourcentage des populations des ménages " +
   "utilisant des sources d'eau potable améliorées, " + surveyname
 caption=
    "[1] Indicateur MICS 4.1; Indicateur OMD 7.8".
	"* Households using bottled water as the main source of drinking water are classified into " +
     "improved or unimproved drinking water users according to the water source used for other purposes such as cooking and handwashing".
							
new file.
