include "surveyname.sps".

get file = 'wm.sav'.

select if (WM7 = 1).

weight by wmweight.

* Select women that gave birth in two years preceeding the survey.

select if (CM13 = "Y" or CM13 = "O").

compute total = 1.
value labels total 1 "Number of women who gave birth in the preceding two years".
variable labels  total "".

compute anc = 0.
if (MN2A = "A") anc = 11.
if (anc = 0 and MN2B = "B") anc = 12.
if (anc = 0 and MN2C = "C") anc = 13.
if (anc = 0 and MN2F = "F") anc = 21.
if (anc = 0 and MN2G = "G") anc = 22.
if (anc = 0 and (MN2X = "X" or MN2A = "?")) anc = 97.
variable labels  anc "Person providing antenatal care".
value labels anc
  11 "Doctor"
  12 "Nurse / Midwife"
  13 "Auxiliary midwife"
  21 "Traditional birth attendant"
  22 "Community health worker"
  97 "Other/missing".

compute skilled = 0.
if (anc = 11 or anc = 12 or anc = 13) skilled = 100.
variable labels  skilled "Percentage of women who received antenatal care (ANC)".

do if (skilled = 100).

+ compute anymed = 0.
+ if (MN13 = 1) anymed = 100.

+ compute sponce = 0.
+ if (MN14A = "A") sponce = 100.

+ compute spmore = 0.
+ if (MN14A = "A" and MN16 >= 2 and MN16 < 97) spmore = 100.

+ compute layer = 0.

+ compute anctot = 1.

end if.

variable labels  anymed "Any medicine to prevent malaria at any ANC visit during pregnancy".
variable labels  sponce "SP/Fansidar at least once".
variable labels  spmore "SP/Fansidar two or more times [1]".
variable labels  anctot "".
value labels anctot 1 "Number of women who had a live birth in the last two years and who received antenatal care".
variable labels  layer "".
value labels layer 0 "Percentage of pregnant women who took:".

compute tot = 1.
variable labels  tot "".
value labels tot 1 "Total".

* For labels in French uncomment commands bellow.

* value labels total 1 " Nombre de femmes ayant eu des naissances vivantes au cours des deux dernières années".
* variable labels  skilled " Pourcentage de femmes ayant reçu des soins prénatals (SP)".
* variable labels  anymed " un médicament pour prévenir le paludisme à n'importe quelle visite pour soins prénatals durant la grossesse".
* variable labels  sponce " SP/Fansidar au moins une fois".
* variable labels  spmore " SP/Fansidar deux ou plusieurs fois".
* value labels anctot 1 " Nombre de femmes ayant eu une naissance vivante au cours des deux dernières années et reçu des soins prénatals".
* value labels layer 0 " Pourcentage de femmes enceintes qui ont pris:".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables =  total tot anctot layer
         display = none
  /table hh7 [c] + hh6 [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                skilled [s] [mean,'',f5.1] + total [c] [count,'',f5.0] +
                layer[c] > (anymed [s][mean,'',f5.1] + sponce [s][mean,'',f5.1] + spmore [s][mean,'',f5.1]) +
                anctot [c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Table CH.16: Intermittent preventive treatment for malaria"
  	"Percentage of women age 15-49 years who had a live birth during the two years " +
                  "preceding the survey and who received intermittent preventive treatment (IPT) for malaria " +
                  "during pregnancy at any antenatal care visit, " + surveyname
  caption =
    "[1] MICS indicator 3.20".

* Ctables command in French.
*
ctables
  /vlabels variables =  total tot anctot layer
         display = none
  /table hh7 [c] + hh6 [c] + welevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
                skilled [s] [mean,'',f5.1] + total [c] [count,'',f5.0] +
                layer[c] > (anymed [s][mean,'',f5.1] + sponce [s][mean,'',f5.1] + spmore [s][mean,'',f5.1]) +
                anctot [c][count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /titles title=
  "Tableau CH.16: Traitement préventif intermittent (TPI) pour le paludisme"
  	"Pourcentage de femmes âgées de 15-49 ans ayant eu une naissance au cours des deux années précédant l'enquête et " +
                  "qui ont bénéficié du traitement préventif  intermittent (TPI) pour le paludisme durant " +
                  "la grossesse à n'importe quelle visite pour soins prénatals, " + surveyname
  caption =
    "[1] Indicateur MICS 3.20".

new file.
