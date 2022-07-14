* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweight1 = HH11*hhweight.

weight by hhweight1.

compute total  = 1.
variable labels  total "Number of household members".
value labels total 1 "".

recode WS4 (0 thru 29 = 2) (30 thru 990 = 3) (998, 999 = 9) into time.

* Water on premises.
if (WS1 = 11 | WS1 = 12 | WS1 = 13) time = 1.
if (WS2 = 11 | WS2 = 12 | WS2 = 13) time = 1.
if (WS3 = 1 | WS3 = 2 ) time = 1.
variable labels  time "Time to source of drinking water".
value labels time 
	1 "Water on premises"
	2 "Less than 30 minutes"
	3 "30 minutes or more"
	9 "Missing/DK" .

recode WS1 (11,12,13,14,15,21,31,41,51 = 1) (else = 2) into type.

do if (WS1 = 91).
+ recode WS2 (11,12,13,14,15,21,31,41,51 = 1) (else = 2) into type.
end if.

variable labels  type "Time to source of drinking water".
value labels type 1 "Users of improved drinking water sources" 2 "Users of unimproved drinking water sources".

compute tot1 = 1.
variable labels  tot1 "Total".
value labels tot1 1 " ".

compute tot2 = 100.
variable labels  tot2 "Total".
value labels tot2 100 " ".

* For labels in French uncomment commands bellow.

* variable labels  total " Nombre de membres de ménage".

* variable labels  time " Temps mis pour atteindre la source d'eau de boisson".
* value labels time 
	1 " Eau sur place"
	2 " Moins de 30 minutes"
	3 "30 minutes ou plus"
	9 " Manquant/NSP" .

* variable labels  type " Temps mis pour atteindre la source d'eau de boisson".
* value labels type 1 " Utilisateurs de sources améliorées d'eau de boisson" 2 " Utilisateurs de sources non améliorée d'eau de boisson ".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = time
          display = none
  /table hh7 [c] + hh6[c] + helevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
    type [c] > time[c][layerrowpct.validn,'',f5.1] + tot2 [s] [mean,'',f5.1] + total [s] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Table WS.3: Time to source of drinking water "
		"Percent distribution of household population according to time to go to source of drinking water, " +
                                    "get water and return, for users of improved and unimproved drinking water sources, " + surveyname.

* Ctables command in French.
*
ctables
  /vlabels variables = time
          display = none
  /table hh7 [c] + hh6[c] + helevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
    type [c] > time[c][layerrowpct.validn,'',f5.1] + tot2 [s] [mean,'',f5.1] + total [s] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
     "Tableau WS.3: Temps mis pour atteindre la source d'eau de boisson "
		"Répartition en pourcentage de la population des ménages selon le temps mis par les utilisateurs " +
                                    "de sources améliorées et non améliorées d'eau de boisson, pour se rendre à la source d'eau de boisson, obtenir de l'eau et retourner, " + surveyname.

new file.
