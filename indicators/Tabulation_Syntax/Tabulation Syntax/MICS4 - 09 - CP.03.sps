include "surveyname.sps".

get file = 'hl.sav'.

weight by hhweight.

select if (HL6 >= 5 and HL6 <= 14).

compute total = 1.
variable label total "".
value label total 1 "Number of children age 5-14 years".

recode HL6 (5 thru 11 = 1) (12 thru 14 = 2) into agegrp.
variable label agegrp "Age".
value label agegrp
  1 "5-11 years"
  2 "12-14 years".

recode CL4 CL6 CL8  (98,99,sysmis = 0) .

compute working = 0.
if (agegrp = 1 and (CL3=1 or CL3=2 or CL5=1 or CL7=1 or (CL10 >= 28 and CL10 <= 95))) working = 100.
if (agegrp = 2 and (CL4 + CL6 + CL8 >= 14 or (CL10 >= 28 and CL10 <=95))) working = 100.
variable label working "Percentage of children involved in child labour".

compute school  = 0.
if (ED5 = 1) school  = 100.
variable label  school "Percentage of children attending school".

do if (working = 100).
+ compute lbschool = 0.
+ if (ED5 = 1) lbschool  = 100.
+ compute lbtotal = 1.
end if.
variable label  lbschool "Percentage of child labourers who are attending school [1]".
variable label lbtotal "".
value label lbtotal 1 "Number of children age 5-14 years involved in child labour".

do if (school = 100).
+ compute schlabor  = 0.
+ if (working = 100) schlabor  = 100.
+ compute schtotal = 1.
end if.
variable label schlabor "Percentage of children attending school who are involved in child labour [2]".
variable label schtotal "".
value label schtotal 1 "Number of children age 5-14 years attending school".

compute tot = 1.
variable label tot "Total".
value label tot 1 " ".

* For labels in French uncomment commands bellow.

* value label total 1 " Nombre d'enfants âgés de 5-14 ans".
* value label agegrp
  1 "5-11 ans"
  2 "12-14 ans".
* variable label working " Pourcentage d'enfants engagés dans le travail des enfants".
* variable label  school " Pourcentage d'enfants fréquentant l'école".
* variable label  lbschool " Pourcentage d'enfants travailleurs fréquentant l'école [1]".
* value label lbtotal 1 " Nombre d'enfants âgés de 5-14 ans engagés dans le travail des enfants".
* variable label schlabor " Pourcentage d'enfants fréquentant l'école et engagés dans le travail des enfants [2]".
* value label schtotal 1 " Nombre d'enfants âgés de 5-14 ans fréquentant l'école".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = total lbtotal schtotal
               display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + agegrp [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
   	working [s] [mean,'',f5.1] + school [s] [mean,'',f5.1] + total [c] [count,'',f5.0] +
 	lbschool [s] [mean,'',f5.1] + lbtotal [c] [count,'',f5.0] + schlabor [s] [mean,'',f5.1] +
  	schtotal [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
  "Table CP.3: Child labour and school attendance"
  	"Percentage of children age 5-14 years involved in child labour who are attending school, "+
                  "and percentage of children age 5-14 years attending school who are involved in child labour, " + surveyname
  caption=
   "[1] MICS indicator 8.3	"						
   "[2] MICS indicator 8.4	".

* Ctables command in French.
*
ctables
  /vlabels variables = total lbtotal schtotal
               display = none
  /table hl4 [c] + hh7 [c] + hh6 [c] + agegrp [c] + melevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
   	working [s] [mean,'',f5.1] + school [s] [mean,'',f5.1] + total [c] [count,'',f5.0] +
 	lbschool [s] [mean,'',f5.1] + lbtotal [c] [count,'',f5.0] + schlabor [s] [mean,'',f5.1] +
  	schtotal [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
  "Tableau CP.3: Travail des enfants et fréquentation scolaire"
  	"Pourcentage d'enfants âgés de 5-14 ans engagés dans le travail des enfants et fréquentant l'école, "+
                  "et pourcentage d'enfants âgés de 5-14 ans fréquentant l'école et engagés dans le travail des enfants, " + surveyname
  caption=
   "[1] Indicateur MICS 8.3"						
   "[2] Indicateur MICS 8.4".

new file.
