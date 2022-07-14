get file = "fg.sav".

*select  daughters age 0-14 years.

select if (FG13 >= 0 and FG13 <= 14).

weight by wmweight.

compute total = 1.
value label total 1 "Number of daughters age 0-14 years".
variable label total "".

compute mothfgm = 1.
if (FG3 = 1) mothfgm = 2.
variable label mothfgm "Mother's FGM/C experience".
value label mothfgm 
  1 "No FGM/C"
  2 "Had FGM/C".

compute agecat = 9.
if (FG13 >= 0 and FG13 <= 4) agecat = 1.
if (FG13 >= 5 and FG13 <= 9) agecat = 2.
if (FG13 >= 10 and FG13 <= 14) agecat = 3.
variable label agecat "Age".
value label agecat 
  1 "0-4"
  2 "5-9"
  3 "10-14"
  9 "Missing/DK".

compute fgm = 0.
if (FG15 = 1) fgm = 100.
variable label fgm "Percentage who had any form of FGM/C [1]".

compute fgmtype1 = 0.
if (FG17 = 1 and FG19 <> 1) fgmtype1 = 100.
variable label fgmtype1 "Had flesh removed". 

compute fgmtype2 = 0.
if (FG18 = 1 and FG19 <> 1) fgmtype2 = 100.
variable label fgmtype2 "Were nicked".

compute fgmtype3 = 0.
if (FG19 = 1) fgmtype3 = 100.
variable label fgmtype3 "Were sewn closed".

compute fgmtypedk = 0.
if (FG15 = 1 and fgmtype1 <> 100 and fgmtype2 <> 100 and fgmtype3 <> 100) fgmtypedk = 100.
variable label fgmtypedk "Form of FGM/C not determined".

compute nofgm = 0.
if (fgm <> 100) nofgm = 100.
variable label nofgm "No FGM/C".

compute layer = 0.
variable label layer "".
value label layer 0 "Percent distribution of daughters age 0-14 years:".

compute layer2 = 0.
variable label layer2 "".
value label layer2 0 "Who had FGM/C".

compute tot = 1.
variable label tot "Total".
value label tot 1 " ".

compute tot2 = 100.
variable label tot2 "Total".
value label tot2 100 "".

* For labels in French uncomment commands bellow.

* value label total 1 "Nombre des filles âgées de 0-14 ans".
* variable label mothfgm "Expérience de la mère en matière de MGF/E".
* value label mothfgm 
  1 "Aucune MGF/E"
  2 "A subi une MGF/E".
* value label agecat 
  1 "0-4"
  2 "5-9"
  3 "10-14"
  9 "Manquant".
* variable label fgm "Pourcentage de celles ayant subi n'importe quelle forme de MGF/E[1]".
* variable label fgmtype1 "Se sont fait retirer des chairs". 
* variable label fgmtype2 "Se sont fait entailler les parties génitales".
* variable label fgmtype3 "Se sont fait fermer la zone du vagin par couture".
* variable label fgmtypedk "Forme de MGF/E non déterminée".
* value label layer 0 "Pourcentage de répartition des filles âgées de 0-14 ans:".
* value label layer2 0 "Qui ont subi des MGF/E".
* variable label nofgm "Aucune MGF/E".


* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer layer2 total
               display = none
  /table hh7 [c] + hh6 [c] + agecat [c] + welevel [c] + mothfgm [c] + windex5 [c] + ethnicity [c] + tot [c] by 
 	 layer [c] > (nofgm [s] [mean,'',f5.1]+ layer2 [c] > (fgmtype1 [s] [mean,'',f5.1] + fgmtype2 [s] [mean,'',f5.1] + fgmtype3 [s] [mean,'',f5.1] + fgmtypedk [s] [mean,'',f5.1])) + tot2 [s] [mean,'',f5.1]+
                   fgm [s] [mean,'',f5.1] + total [c] [count,'',f5.0] 
   /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
  "Table CP.9: Female genital mutilation/cutting (FGM/C) among daughters"
  "Percent distribution of daughters age 0-14 by FGM/C status, " + surveyname
  caption=
   "[1] MICS indicator 8.13".

* Ctables command in French.
*
ctables
  /vlabels variables = layer layer2 total
               display = none
  /table hh7 [c] + hh6 [c] + agecat [c] + welevel [c] + mothfgm [c] + windex5 [c] + ethnicity [c] + tot [c] by 
 	 layer [c] > (nofgm [s] [mean,'',f5.1]+ layer2 [c] > (fgmtype1 [s] [mean,'',f5.1] + fgmtype2 [s] [mean,'',f5.1] + fgmtype3 [s] [mean,'',f5.1] + fgmtypedk [s] [mean,'',f5.1])) + tot2 [s] [mean,'',f5.1]+
                   fgm [s] [mean,'',f5.1] + total [c] [count,'',f5.0] 
   /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
  "Tableau CP.9: Mutilations génitales féminines/excision (MGF/E) chez les filles"
  "Pourcentage de répartition des filles âgées de 0-14 ans par état de MGF/E, " + surveyname
  caption=
   "[1] Indicateur MICS 8.13".							


new file.
