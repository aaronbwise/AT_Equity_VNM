include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.
select if (HL6 >= 5 and HL6 <= 14).

recode HL6 (5 thru 11 = 1) (12 thru 14 = 2) into agegrp.
variable label agegrp "Age".
value label agegrp
  1 "5-11 years"
  2 "12-14 years".

compute total = 1.
variable label total "Number of children age 5-14 years".
value label total 1 "".

recode ED5 (1 = 1) (else = 2) into part.
variable label part "School participation".
value label part 1 "Yes" 2 "No" .

recode CL4 CL6 CL8  (98,99,sysmis = 0) .

* For children 5 - 11 yrs.
do if (agegrp = 1).

+ compute paid1 = 0.
+ if (CL3 = 1) paid1 = 100.

+ compute unpaid1 = 0.
+ if (CL3 = 2) unpaid1 = 100.

+ compute family1 = 0.
+ if (CL5 = 1 or CL7 = 1) family1 = 100.

+ compute hours1 = 0.
+ if (CL3 = 1 or CL3 = 2 or CL5 = 1 or CL7 = 1) hours1 = 100.

+ compute less1 = 0.
+ if (CL9 = 1 and CL10 < 28) less1 = 100.

+ compute more1 = 0.
+ if (CL9 = 1 and CL10 >= 28 and CL10 <= 95) more1 = 100.

+ compute working1 = 0.
+ if (CL3 = 1 or CL3 = 2 or CL5 = 1 or CL7 = 1 or (CL10 >= 28 and CL10 <= 95)) working1 = 100.

+ compute layer1 = 1.

+ compute total1 = 1.

end if.

variable label paid1 "Paid work".
variable label unpaid1 "Unpaid work".
variable label family1 "Working for family business".
variable label hours1 "Economic activity for at least one hour".
variable label less1 "Household chores less than 28 hours".
variable label more1 "Household chores for 28 hours or more".
variable label working1 "Child labour".
value label layer1 1"Percentage of children age 5-11 involved in".
variable label layer1 "".
variable label total1 "".
value label total1 1 "Number of children age 5-11".

* For children 12 - 14 yrs.
do if (agegrp = 2).

+ compute paid2 = 0.
+ if (CL3 = 1) paid2 = 100.

+ compute unpaid2 = 0.
+ if (CL3 = 2) unpaid2 = 100.

+ compute family2 = 0.
+ if (CL5 = 1 or CL7 = 1) family2 = 100.

+ compute hours12 = 0.
+ if ((CL3=1 or CL3=2 or CL5=1 or CL7=1) and (CL4 + CL6 + CL8 < 14)) hours12 = 100.

+ compute hours22 = 0.
+ if (CL4 + CL6 + CL8 >= 14) hours22 = 100.

+ compute less2 = 0.
+ if (CL9=1 and CL10 < 28) less2 = 100.

+ compute more2 = 0.
+ if (CL10 >= 28 and CL10 <= 95) more2 = 100.

+ compute working2 = 0.
+ if (CL4 + CL6 + CL8 >= 14 or (CL10 >= 28 and CL10 <=95)) working2 = 100.

+ compute layer2 = 1.

+ compute total2 = 1.

end if.

variable label paid2 "Paid work".
variable label unpaid2 "Unpaid work".
variable label family2 "Working for family business".
variable label hours12 "Economic actvity less than 14 hours".
variable label hours22 "Economic activity for 14 hours or more".
variable label less2 "Household chores less than 28 hours".
variable label more2 "Household chores for 28 hours or more".
variable label working2 "Child labour".
value label layer2 1 "Percentage of children age 12-14 involved in".
variable label layer2 "".
value label total2 1 "Number of children age 12-14".
variable label total2 "".

compute working = 0.
if (agegrp = 1 and (CL3=1 or CL3=2 or CL5=1 or CL7=1 or (CL10 >= 28 and CL10 <= 95))) working = 100.
if (agegrp = 2 and (CL4 + CL6 + CL8 >= 14 or (CL10 >= 28 and CL10 <=95))) working = 100.
variable label working "Total child labour [1]".

compute ecact = 1.
variable label ecact "".
value label ecact 1 "Economic activity".

compute wout = 1.
variable label wout "".
value label wout 1 "Working outside household".

compute tot = 1.
variable label tot "Total".
value label tot 1 " ".

* For labels in French uncomment commands bellow.

* variable label paid1 "Travail rémunéré".
* variable label unpaid1 "Travail non rémunéré".
* variable label family1 "Travail pour l'entreprise familiale".
* variable label hours1 "Activité économique pendant au moins une heure".
* variable label less1 "Travaux ménagers pendant moins de 28 heures".
* variable label more1 "Travaux ménagers pendant 28 heures ou plus".
* variable label working1 "Travail des enfants".
* value label layer1 1 "Pourcentage d'enfants âgés de 5-11 ans impliqués dans".
* value label total1 1 "Nombre d'enfants âgés de 5-11 ans".
* variable label paid2 "Travail rémunéré".
* variable label unpaid2 "Travail non rémunéré".
* variable label family2 "Travail pour l'entreprise familiale".
* variable label hours12 "Activité économique pendant moins de 14 heures".
* variable label hours22 "Activité économique pendant 14 heures ou plus".
* variable label less2 "Travaux ménagers pendant moins de 28 heures".
* variable label more2 "Travaux ménagers pendant 28 heures ou plus".
* variable label working2 "Travail des enfants".
* value label layer2 1 "Pourcentage d'enfants âgés de 12-14 ans impliqués dans".
* value label total2 1 "Nombre d'enfants âgés de 12-14 ans".
* variable label working "Total du travail des enfants [1]".
* value label ecact 1 "Une activité économique".
* value label wout 1 "Travaillent à l'extérieur du ménage".
* variable label part "Fréquentation scolaire".
* value label part 1 "Oui" 2 "Non". 

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = layer1 ecact wout total1 layer2 total2
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + part [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
   layer1 [c] > (ecact[c] > (wout [c] > (paid1 [s] [mean,'',f5.1] + unpaid1 [s] [mean,'',f5.1]) + family1 [s] [mean,'',f5.1]) + 
                     hours1 [s] [mean,'',f5.1] + less1 [s] [mean,'',f5.1] + more1 [s] [mean,'',f5.1] + working1 [s] [mean,'',f5.1]) + total1 [c][count,'',f5.0] +
   layer2 [c] > (ecact[c] > (wout [c] > (paid2 [s] [mean,'',f5.1] + unpaid2 [s] [mean,'',f5.1]) + family2 [s] [mean,'',f5.1]) + 
                     hours12 [s] [mean,'',f5.1] + hours22 [s] [mean,'',f5.1] + less2 [s] [mean,'',f5.1] + more2 [s] [mean,'',f5.1] + working2 [s] [mean,'',f5.1]) + total2 [c][count,'',f5.0] +
   working [s] [mean,'',f5.1] + total [s] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
   "Table CP.2: Child labour"
  	"Percentage of children by involvement in economic activity and household chores during the past week, "
                  "according to age groups, and percentage of children age 5-14 involved in child labour, " + surveyname
  caption="[1] MICS indicator 8.2".

* Ctables command in French.
*
ctables
  /vlabels variables = layer1 ecact wout total1 layer2 total2
         display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + part [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
   layer1 [c] > (ecact[c] > (wout [c] > (paid1 [s] [mean,'',f5.1] + unpaid1 [s] [mean,'',f5.1]) + family1 [s] [mean,'',f5.1]) + 
                     hours1 [s] [mean,'',f5.1] + less1 [s] [mean,'',f5.1] + more1 [s] [mean,'',f5.1] + working1 [s] [mean,'',f5.1]) + total1 [c][count,'',f5.0] +
   layer2 [c] > (ecact[c] > (wout [c] > (paid2 [s] [mean,'',f5.1] + unpaid2 [s] [mean,'',f5.1]) + family2 [s] [mean,'',f5.1]) + 
                     hours12 [s] [mean,'',f5.1] + hours22 [s] [mean,'',f5.1] + less2 [s] [mean,'',f5.1] + more2 [s] [mean,'',f5.1] + working2 [s] [mean,'',f5.1]) + total2 [c][count,'',f5.0] +
   working [s] [mean,'',f5.1] + total [s] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
   "Tableau CP.2: Travail des enfants"
  	"Pourcentage d'enfants selon leur participation à une activité économique et aux travaux ménagers au cours de la semaine dernière, "
                  "selon les tranches d'âge, et pourcentage d'enfants âgés de 5-14 ans engagés dans le travail des enfants, " + surveyname
  caption="[1] Indicateur MICS 8.2".											


new file.
