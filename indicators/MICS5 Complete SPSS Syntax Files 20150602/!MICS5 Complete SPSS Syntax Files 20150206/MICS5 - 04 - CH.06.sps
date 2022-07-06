*v.1 - 2014-03-19.

* Given to drink: CA2.
* Given to eat: CA3.
* Child was given 'Nothing' to eat: CA3 = 5 or 6.

* The denominator for this table is number of children with diarrhoea during the last two weeks: CA1=1.

* Call include file for the working directory and the survey name.

include "surveyname.sps".

get file = 'ch.sav'.

select if (UF9 = 1).

weight by chweight.

* diarrhoea in last 2 weeks.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels diarrhea "Had diarrhoea in last two weeks".

do if (CA1 = 1).
+ compute dtotal = 1.
end if.
value labels dtotal 1 "Number of children aged 0-59 months with diarrhoea".
variable labels dtotal "".

* CA2 categories.
* Much less		1
Somewhat less	2
About the same	3
More		4
Nothing to drink	5
DK		8.

recode CA2 (8,9 = 9) (else = copy).
variable labels CA2 "Drinking practices during diarrhoea:".
value labels CA2
  1 "Child was given to drink: Much less"
  2 "Child was given to drink: Somewhat less"
  3 "Child was given to drink: About the same"
  4 "Child was given to drink: More"
  5 "Child was given to drink: Nothing"
  9 "Missing/DK".

* CA3.
*Much less		1
Somewhat less	2
About the same	3
More		4
Stopped food	5
Never gave food	6
DK		8.

recode CA3 (5,6 = 5) (8,9 = 9) (else = copy).
variable labels CA3 "Eating practices during diarrhoea:".
value labels CA3
  1 "Child was given to eat: Much less"
  2 "Child was given to eat: Somewhat less"
  3 "Child was given to eat: About the same"
  4 "Child was given to eat: More"
  5 "Child was given to eat: Nothing"
  9 "Missing/DK".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

* Ctables command in English (currently active, comment it out if using different language).
ctables
  /vlabels variables = tot dtotal
         display = none
  /table tot [c] + hl4 [c] + hh7 [c] + hh6 [c] + cage_11 [c] + melevel [c]  + windex5 [c] + ethnicity [c]  by 
  	CA2 [c] [rowpct.validn,'',f5.1] +
                  CA3 [c] [rowpct.validn,'',f5.1] + 
                  dtotal [c] [count,'',f5.0]
  /categories var=all empty=exclude missing=exclude
  /categories var = CA2 CA3 total = yes position = after label = "Total"
  /slabels position=column visible = no
  /titles title=
	 "Table CH.6: Feeding practices during diarrhoea"
	  "Percent distribution of children age 0-59 months with diarrhoea in the last two weeks by amount of liquids and food given during episode of diarrhoea, " 
 	   + surveyname.

new file.
