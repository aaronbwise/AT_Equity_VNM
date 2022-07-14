include "surveyname.sps".

get file = "wm.sav".

select if (WM7 = 1).

weight by wmweight.

compute total = 1.
value label total 1 "Number of women aged 15-49 years".
variable label total "".

compute heardfgm = 0.
if (FG1 = 1 or FG2 = 1) heardfgm = 100.
variable label heardfgm "Percentage of women who have heard of FGM/C".

recode FG22 (8,9 = 9) (else = copy).
variable label FG22 "Percent distribution of women who believe the practice of FGM/C should be:".
value label FG22
  1 "Continued [1]"
  2 "Discontinued"
  3 "Depends"
  9 "Don't know/Missing".

compute fgm = 1.
if (FG3 = 1) fgm = 2.
variable label fgm "FGM/C experience".
value label fgm 
  1 "No FGM/C"
  2 "Had FGM/C".

do if (heardfgm) = 100.
+ compute totalh = 1.
end if.
variable label totalh "".
value label totalh 1 "Number of women age 15-49 years who have heard of FGM/C".

compute tot = 1.
variable label tot "Total".
value label tot 1 " ".

* For labels in French uncomment commands bellow.

* value label total 1 "Nombre de femmes âgées de 15-49 ans".
* variable label heardfgm "Pourcentage de femmes ayant entendu parler de la MGF/E".
* variable label FG22 "Pourcentage de femmes qui pensent que la pratique de la MGF/E:".
* value label FG22
  1 "Devrait se poursuivre [1]"
  2 "Devrait être abandonnée"
  3 "dépend"
  9 "Ne savent pas".
* variable label fgm "Expérience en matière de MGF/E".
* value label fgm 
  1 "Aucune MGF/E"
  2 "A subi une MGF/E".
* value label totalh 1 "Nombre de femmes âgées de 15-49 ans ayant entendu parler de la MGF/E".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total totalh
               display = none
  /table hh7 [c] + hh6 [c] + wage [c] + welevel [c] + fgm [c] + windex5 [c] + ethnicity [c] + tot [c] by 
 	 heardfgm [s] [mean,'',f5.1] + total [c] [count,'',f5.0] + FG22 [c] [rowpct.validn,'',f5.1] + totalh [c] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /categories var = FG22 total = yes position = after label = "Total"
  /slabels position=column visible = no
  /title title=
   "Table CP.10: Approval of female genital mutilation/cutting (FGM/C)"
	"Percentage of women age 15-49 years who have heard of FGM/C, " +
                  "and percent distribution of women according to attitudes towards whether " +
                  "the practice of FGM/C should be continued, " + surveyname
  caption =
	"[1] MICS indicator 8.11".

* Ctables command in French.
*
ctables
  /vlabels variables = total totalh
               display = none
  /table hh7 [c] + hh6 [c] + wage [c] + welevel [c] + fgm [c] + windex5 [c] + ethnicity [c] + tot [c] by 
 	 heardfgm [s] [mean,'',f5.1] + total [c] [count,'',f5.0] + FG22 [c] [rowpct.validn,'',f5.1] + totalh [c] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /categories var = FG22 total = yes position = after label = "Total"
  /slabels position=column visible = no
  /title title=
   "Tableau CP.10: Approbation de la mutilation génitale féminine/excision (MGF/E)"
	"Pourcentage de femmes âgées de 15-49 ans ayant entendu parler de la MGF/E, " +
                  "et répartion en pourcentage des femmes selon leurs attitudes quant " +
                  "à la poursuite de la pratique de la MGF/E, " + surveyname
  caption =
	"[1] Indicateur MICS 8.11".

new file.
