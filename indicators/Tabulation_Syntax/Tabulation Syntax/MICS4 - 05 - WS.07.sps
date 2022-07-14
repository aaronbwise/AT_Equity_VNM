* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

sort cases by HH1 HH2.

save outfile = 'tmp.sav'
  /keep HH1 HH2 WS8.

get file = 'ch.sav'.

sort cases by HH1 HH2.

match files
  /file = *
  /table = 'tmp.sav'
  /by HH1 HH2 .

select if (UF9 = 1).

weight by chweight.

select if (AG2 < 3).

recode CA15 (1,2 = 100) (else = 0) into stools.
variable labels  stools "Percentage of children whose last stools were disposed of safely [1]".
value labels stools 100 "".

variable labels  CA15 "Place of disposal of child's faeces".

compute total  = 1.
value labels total 1 "".
variable labels  total "Number of children age 0-2 years".

recode WS8 (11,12,13,15,21,22,31 = 1) (95 = 3) (else = 2) into type.
variable labels  type "Type of sanitaton facility in dwelling".
value labels type 
	1 "Improved" 
	2 "Unimproved"
    	3 "Open defacation".
		
recode CA15 (99=98).
add value labels CA15 98 "DK/Missing".

compute tot = 100.
value labels tot 1 "".
variable labels  tot "Total".

compute tot1 = 100.
value labels tot1 100 " ".
variable labels  tot1 "Total".

* For labels in French uncomment commands bellow.

* variable labels  stools " Pourcentage des enfants dont les matières fécales ont été évacuées en toute sécurité [1]".
* variable labels  CA15 " Lieu d'évacuation des matières fécales de l'enfant".
* variable labels  total " Nombre des enfants âgés de 0-2 ans".

* Ctables command in English (currently active, comment it out if using different language).
ctables
 /table type [c] + hh7 [c] + hh6[c] + melevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
                   ca15 [c] [rowpct.validn,'',f5.1]+ tot [s] [mean,'',f5.1] + stools [s] [mean,'',f5.1] + total [s] [sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Table WS.7: Disposal of child's faeces"
		"Percent distribution of children age 0-2 years according to place "+
                                    "of disposal of child's faeces, and the percentage of children age 0-2 " +
                                    "years whose stools were disposed of safely the last time the child passed stools, " + surveyname
  caption = "[1] MICS indicator 4.4".

* Ctables command in French.
*
ctables
 /table type [c] + hh7 [c] + hh6[c] + melevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
                   CA15 [c] [rowpct.validn,'',f5.1]+ tot [s] [mean,'',f5.1] + stools [s] [mean,'',f5.1] + total [s] [sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
    "Tableau WS.7: Evacuation des matières fécales de l'enfant"
		"Répartition en pourcentage  des enfants âgés de 0-2 ans selon le lieu d'évacuation des matières fécales de l'enfant, "+
                                    "et  pourcentage des enfants âgés de 0-2 ans dont les selles ont été évacuées en toute " +
                                    "sécurité la dernière fois que l'enfant est allé aux selles, " +
                                    "" + surveyname
  caption = "[1] Indicateur MICS 4.4".
										
new file.

erase file = 'tmp.sav'.


