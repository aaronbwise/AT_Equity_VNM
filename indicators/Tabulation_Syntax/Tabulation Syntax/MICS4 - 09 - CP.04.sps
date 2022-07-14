include "surveyname.sps".

get file = "hl.sav".

sort cases by HH1 HH2 HL1.

recode ED4A (1 = 2) (2,3 = 3) (8,9 = 9) (else = 1) into relevel.
variable label relevel "Respondent's education".
value label relevel
  1 "None"
  2 "Primary"
  3 "Secondary +"
  9 "Missing/DK".
format relevel (f1.0).

save out="tmp1.sav"
 /keep HH1, HH2, HL1, relevel
 /rename (HL1 = HH10).

save out="tmp2.sav"
 /keep HH1, HH2, HL1, HL6, HL4
 /rename (HL1 = CD9).

get file = "hh.sav".

select if (HH9 = 1).

* Select households in which child discipline questionnaire was administered.
select if (not sysmis(CD11)).

sort cases by HH1 HH2 HH10.

match files
  /file = *
  /table = 'tmp1.sav'
  /by HH1 HH2 HH10.

sort cases by HH1 HH2 CD9.

match files
  /file = *
  /table = 'tmp2.sav'
  /by HH1 HH2 CD9.

* Random selection of one child age 2-14 years per household is carried out during fieldwork. 
* Household sample weight is multiplied by the total number of children age 2-14 in each household to take the random selection into account.
compute newwgt = hhweight * CD6.
weight by newwgt.

select if (HL6 >= 2 and HL6 <= 14).

recode HL6 (2 thru 4 = 1) (5 thru 9 = 2) (10 thru 14 = 3) into agegrp.
variable label agegrp "Age".
value label agegrp
  1 "2-4 years"
  2 "5-9 years"
  3 "10-14 years".

compute layer = 0.
variable label layer "".
value label layer 0 "Percentage of children age 2-14 years who experienced:".

* Only non-violent discipline.
compute nviolent = 0.
if (CD11 = 1 or CD12 = 1 or CD15 = 1) and (CD13 = 2 and CD14 = 2 and CD16 = 2 and CD17 = 2 and CD18 = 2 and CD19 = 2 and CD20 = 2 and CD21=2) nviolent = 100.
variable label nviolent "Only non-violent discipline".

* Psychological aggression.
compute aggr = 0.
if (CD14 = 1 or CD18 = 1) aggr = 100.
variable label aggr "Psychological aggression".

* Physical punishment.
compute layer1 = 1.
variable label layer1 "".
value label layer1 1 "Physical punishment".

* Physical punishment.
compute physical = 0.
if (CD13 = 1 or CD16 = 1 or CD17 = 1 or CD19 = 1 or CD20 = 1 or CD21 = 1) physical = 100.
variable label physical "Any".

* Severe physical punishment.
compute severep = 0.
if (CD19=1 or CD21=1) severep = 100.
variable label severep "Severe".

* Any violent discipline method.
compute any = 0.
if (aggr = 100 or physical = 100 or severep = 100) any = 100.
variable label any "Any violent discipline method [1]".

compute total1 = 1.
variable label total1 "".
value label total1 1 "Number of children age 2-14 years".

compute tot = 1.
variable label tot "Total".
value label tot 1 " ".

* For labels in French uncomment commands bellow.
* variable label relevel " Instruction de l'enquêté (e)".
* value label relevel
  1 " Aucune"
  2 " Primaire"
  3 " Secondaire +"
  9 " Manquant".
* value label agegrp
  1 "2-4 ans"
  2 "5-9 ans"
  3 "10-14 ans".
* value label layer 0 " Pourcentage d'enfants âgés de 2-14 ans ayant connu:".
* variable label nviolent " Discipline non violente uniquement".
* variable label aggr " Agression psychologique".
* value label layer1 1 " Une punition physique".
* variable label physical " N'importe quelle".
* variable label severep " Sévère ".
* variable label any " N'importe quelle méthode disciplinaire violente [1]".
* value label total1 1 " Nombre d'enfants âgés de 2-14 ans".

* Ctables command in English (currently active, comment it out if using different language).
ctables
   /vlabels variables = layer layer1 total1 
        display = none
   /table hl4 [c] + hh7 [c] + hh6 [c] + agegrp [c] + helevel [c] + relevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
         layer [c] > (nviolent[s][mean,'',f5.1]+ aggr[s][mean,'',f5.1]+ layer1 [c] > (physical [s][mean,'',f5.1] + severep[s][mean,'',f5.1]) + any [s][mean,'',f5.1] ) + 
         total1 [c] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
  "Table CP.4: Child discipline"
 	 "Percentage of children age 2-14 years according to method of disciplining the child, " + surveyname
  caption =
    "[1] MICS indicator 8.5".

* Ctables command in French.
*
ctables
   /vlabels variables = layer layer1 total1 
        display = none
   /table hl4 [c] + hh7 [c] + hh6 [c] + agegrp [c] + helevel [c] + relevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
         layer [c] > (nviolent[s][mean,'',f5.1]+ aggr[s][mean,'',f5.1]+ layer1 [c] > (physical [s][mean,'',f5.1] + severep[s][mean,'',f5.1]) + any [s][mean,'',f5.1] ) + 
         total1 [c] [count,'',f5.0] 
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
  "Table CP.4: Discipline des enfants"
 	 "Pourcentage d'enfants âgés de 2-14 ans selon la méthode de discipline appliquée à l'enfant, " + surveyname
  caption =
    "[1] MICS indicator 8.5".

weight by hhweight.

compute ppunish = 0.
if (CD22 = 1) ppunish = 100.
variable label ppunish "Respondent believes that the child needs to be physically punished".

compute  total2 = 1.
variable label total2 "Respondents to the child discipline module".
value label total2 1 "".

* For labels in French uncomment commands bellow.
* variable label ppunish " L'enquêté (e) croit qu'il faut punir physiquement l'enfant".
* variable label total2 " Rédondant au module sur la discipline de l'enfant".

* Ctables command in English (currently active, comment it out if using different language).
ctables
   /table hl4 [c] + hh7 [c] + hh6 [c] + agegrp [c] + helevel [c] + relevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
     ppunish[s][mean,'',f5.1] + total2 [s] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
  "Table CP.4: Child discipline"
 	 "Percentage of children age 2-14 years according to method of disciplining the child, " + surveyname.

* Ctables command in French.
*
ctables
   /table hl4 [c] + hh7 [c] + hh6 [c] + agegrp [c] + helevel [c] + relevel [c] + windex5 [c] + ethnicity [c] + tot [c] by 
     ppunish[s][mean,'',f5.1] + total2 [s] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /slabels position=column visible = no
  /title title=
  "Table CP.4: Discipline des enfants"
 	 "Pourcentage d'enfants âgés de 2-14 ans selon la méthode de discipline appliquée à l'enfant, " + surveyname.

new file.

* delete working files.
erase file = 'tmp1.sav'.
erase file = 'tmp2.sav'.
