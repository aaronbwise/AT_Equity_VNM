get file = "wm.sav".

select if (WM7 = 1).

weight by wmweight.

compute total = 1.
value label total 1 "Number of women aged 15-49 years".
variable label total "".

compute fgm = 0.
if (FG3 = 1) fgm = 100.
variable label fgm "Percentage who had any form of FGM/C [1]".

compute fgmtype1 = 0.
if (FG4 = 1 and FG6 <> 1) fgmtype1 = 100.
variable label fgmtype1 "Had flesh removed". 

compute fgmtype2 = 0.
if (FG5 = 1 and FG6 <> 1) fgmtype2 = 100.
variable label fgmtype2 "Were nicked".

compute fgmtype3 = 0.
if (FG6 = 1) fgmtype3 = 100.
variable label fgmtype3 "Were sewn closed".

compute fgmtypedk = 0.
if (FG3 = 1 and fgmtype1 <> 100 and fgmtype2 <> 100 and fgmtype3 <> 100) fgmtypedk = 100.
variable label fgmtypedk "Form of FGM/C not determined".

compute nofgm = 0.
if (fgm <> 100) nofgm = 100.
variable label nofgm "No FGM/C".

compute layer = 1.
variable label layer "".
value label layer 1"Percent distribution of women age 15-49 years:".

compute layer2 = 100.
variable label layer2 "".
value label layer2 100 "Who had FGM/C".

compute tot = 1.
variable label tot "Total".
value label tot 1 " ".

compute tot2 = 100.
variable label tot2 "Total".
value label tot2 100 "".

* For labels in French uncomment commands bellow.

* value label total 1 "Nombre de femmes âgées de 15-49 ans".
* variable label fgm "Pourcentage de celles ayant subi n'importe quelle forme de MGF/E [1]".
* variable label fgmtype1 "Retiré des chairs". 
* variable label fgmtype2 "Entaillé les parties génitales".
* variable label fgmtype3 "Fermé la zone du vagin par couture".
* variable label fgmtypedk "Forme de MGF/E non déterminée".
* variable label nofgm "Aucune MGF/E".
* value label layer 1"Répartition en pourcentage des femmes âgées de 15-49 ans `a qui on a:".
* value label layer2 100 "Qui a eu l'E / MGF".

* Ctables command in English (currently active, comment it out if using different language).
*

ctables
  /vlabels variables = layer layer2 total
               display = none
  /table hh7 [c] + hh6 [c] + wage [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
 	 layer [c] > (nofgm [s] [mean,'',f5.1]+ layer2 [c] > (fgmtype1 [s] [mean,'',f5.1] + fgmtype2 [s] [mean,'',f5.1] + fgmtype3 [s] [mean,'',f5.1] + fgmtypedk [s] [mean,'',f5.1])) + tot2 [s] [mean,'',f5.1]+
                   fgm [s] [mean,'',f5.1] + total [c] [count,'',f5.0] 
   /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
   "Table CP.8: Female genital mutilation/cutting (FGM/C) among women"
	"Percent distribution of women age 15-49 years by FGM/C status, " + surveyname
  caption ="[1] MICS indicator 8.12".

* Ctables command in French.
*
ctables
  /vlabels variables = layer layer2 total
               display = none
  /table hh7 [c] + hh6 [c] + wage [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
 	 layer [c] > (nofgm [s] [mean,'',f5.1]+ layer2 [c] > (fgmtype1 [s] [mean,'',f5.1] + fgmtype2 [s] [mean,'',f5.1] + fgmtype3 [s] [mean,'',f5.1] + fgmtypedk [s] [mean,'',f5.1])) + tot2 [s] [mean,'',f5.1]+
                   fgm [s] [mean,'',f5.1] + total [c] [count,'',f5.0] 
   /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
   "Tableau CP.8: Mutilations génitales féminines/excision (MGF/E) chez les femmes"
	"Pourcentage de répartition des femmes âgées de 15-49 ans par état de MGF/E, " + surveyname
  caption ="[1] Indicateur MICS 8.12".

new file.
