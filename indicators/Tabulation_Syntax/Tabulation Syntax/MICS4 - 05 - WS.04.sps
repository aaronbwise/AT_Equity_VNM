* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

weight by hhweight.

compute total = 1.
variable labels  total "Number of households".
value labels total 1 "".

compute wprem = 0.
if (not(sysmis(WS5))) wprem = 100.
variable labels  wprem "Percentage of households without drinking water on premises".

do if (not(sysmis(WS5))).
+ compute totalnw  = 1.
end if.

recode WS5 (8=9).
add value labels WS5 9 "DK/Missing".

variable labels  WS5 "Person usually collecting drinking water".

variable labels  totalnw "Number of households without drinking water on premises".
value labels totalnw 1 "".

compute tot1 = 1.
variable labels  tot1 "Total".
value labels tot1 1 " ".

* For labels in French uncomment commands bellow.

*variable labels  total " Nombre des ménages".
*variable labels  wprem " Pourcentage des ménages sans eau potable sur place".
*variable labels  WS5 " Personne qui habituellement va chercher de l'eau potable".
*variable labels  totalnw " Nombre des ménages sans eau potable sur place".


ctables
  /table hh7 [c] + hh6[c] + helevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
                wprem [s] [mean,'',f5.1] + total [s][sum,'',f5.0] + ws5 [c] [rowpct.validn,'',f5.1] + totalnw[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var=ws5 total=yes position= after label= "Total"
  /slabels position=column visible = no
  /titles title=
  "Table WS.4: Person collecting water"
  	"Percentage of households without drinking water on premises, " +
  	"and percent distribution of households without drinking water on premises "+
	"according to the person usually collecting drinking water used in the household, " +
  	"" + surveyname.

*ctables
  /table hh7 [c] + hh6[c] + helevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
                wprem [s] [mean,'',f5.1] + total [s][sum,'',f5.0] + ws5[c] [rowpct.validn,'',f5.1] + totalnw[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var=ws5 total=yes position= after label= "Total"
  /slabels position=column visible = no
  /titles title=
  "Tableau WS.4: Personne qui va aller chercher l'eau"
  	"Pourcentage des ménages sans eau potable sur place, " +
  	"et Répartition en pourcentage des ménages sans eau potable sur place selon la personne qui, habituellement, "+
	" va chercher de l'eau potable utilisée dans le ménage, " +
  	"" + surveyname.

new file.
