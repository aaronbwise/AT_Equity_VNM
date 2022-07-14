* Call include file for the working directory and the survey name.
include "surveyname.sps".

get file = 'hh.sav'.

select if (HH9 = 1).

compute hhweight1 = HH11 * hhweight.

weight by hhweight1.

* create variable that will provide title in final table.

compute treat = 1.
value labels treat 1  "Water treatment method used in the household".
variable labels  treat " ".

compute none = 0.
if (WS6 <> 1) none = 100.
variable labels  none "None".

compute boil = 0.
if (WS7A = "A") boil = 100.
variable labels  boil "Boil".

compute bleach = 0.
if (WS7B = "B") bleach = 100.
variable labels  bleach "Add bleach / chlorine".

compute cloth = 0.
if (WS7C = "C") cloth = 100.
variable labels  cloth "Strain through a cloth".

compute wfilter = 0.
if (WS7D = "D") wfilter = 100.
variable labels  wfilter "Use water filter".

compute solar = 0.
if (WS7E = "E") solar = 100.
variable labels  solar "Solar disinfection".

compute stand = 0.
if (WS7F = "F") stand = 100.
variable labels  stand "Let it stand and settle".

compute other = 0.
if (WS7X = "X") other = 100.
variable labels  other "Other".

compute dk = 0.
if (WS7Z = "Z") dk = 100.
variable labels  dk "Don't know".

compute total = 1.
value labels total 1 "".
variable labels  total "Number of household members".

recode WS1 (11,12,13,14,15,21,31,41,51 = 1) (else = 2) into type.

do if (WS1 = 91).
+ recode WS2 (11,12,13,14,15,21,31,41,51 = 1) (else = 2) into type.
end if.

variable labels  type "".
value labels type 1 "Improved sources" 2 "Unimproved sources".

do if (type  = 2).
+ compute unproved = 0.
+ if (boil = 100 or bleach = 100 or wfilter = 100 or solar = 100) unproved = 100.
+ compute utotal = 1.
end if.

variable labels  unproved "Percentage of household members in households " +
                                 "using unimproved drinking water sources and using " +
                                 "an appropriate water treatment method [1]".

value labels utotal  1 "".
variable labels  utotal "Number of household members in households using unimproved drinking water sources".

compute tot1 = 1.
variable labels  tot1 "Total".
value labels tot1 1 " ".

* For labels in French uncomment commands bellow.

* value labels treat 1  " Méthode de traitement de l'eau dans le ménage".
* variable labels  none " Aucune".
* variable labels  boil " La faire bouillir".
* variable labels  bleach " Y ajouter de l'eau de javel/ chlore".
* variable labels  cloth " La filtrer à travers un linge".
* variable labels  wfilter " Utiliser un filtre à eau".
* variable labels  solar " Désinfection solaire".
* variable labels  stand " Laisser reposer".
* variable labels  other " Autre".
* variable labels  dk " Manquant/NSP".
* variable labels  total " Nombre des membres des ménages".
* variable labels  unproved " Pourcentage des membres des ménages dans les ménages utilisant " +
		"des sources d'eau de boisson non améliorées  et employant une méthode " +
		"appropriée de traitement de l'eau [1]".
* variable labels  utotal " Nombre des membres des ménages dans les ménages utilisant des sources d'eau de boisson non améliorées".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = treat display = none
  /table hh7 [c] + hh6[c] + helevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
              treat [c] > (none[s][mean,'',f5.1] + boil[s][mean,'',f5.1] + bleach[s][mean,'',f5.1]+ cloth[s][mean,'',f5.1]+wfilter[s][mean,'',f5.1]+ solar[s][mean,'',f5.1]+
                              stand[s][mean,'',f5.1]+ other[s][mean,'',f5.1]+dk[s][mean,'',f5.1]) +
              total[s][sum,'',f5.0] + unproved[s][mean,'',f5.1]+utotal[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table WS.2: Household water treatment"
 	"Percentage of household population by drinking water treatment method used in the household, " +
  	"and for household members living in households where an unimproved drinking water source is used, " +
  	"the percentage who are using an appropriate treatment method, " + surveyname
  caption = "[1] MICS indicator 4.2".

* Ctables command in French.
*
ctables
  /vlabels variables = treat display = none
  /table hh7 [c] + hh6[c] + helevel [c] + windex5 [c] + ethnicity [c] + tot1 [c] by 
              treat [c] > (none[s][mean,'',f5.1] + boil[s][mean,'',f5.1] + bleach[s][mean,'',f5.1]+ cloth[s][mean,'',f5.1]+wfilter[s][mean,'',f5.1]+ solar[s][mean,'',f5.1]+
                              stand[s][mean,'',f5.1]+ other[s][mean,'',f5.1]+dk[s][mean,'',f5.1]) +
              total[s][sum,'',f5.0] + unproved[s][mean,'',f5.1]+utotal[s][sum,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Tableau WS.2: Traitement de l'eau du ménage"
 	"Pourcentage des populations des ménages selon la méthode de traitement de l'eau de boisson utilisée dans le ménage, " +
  	"et pour les membres des ménages vivant dans les ménages où l'on utilise une source d'eau de boisson non améliorée, " +
  	"pourcentage de ceux employant une méthode de traitement appropriée, " + surveyname
  caption = "[1] Indicateur MICS 4.2".
											
new file.
