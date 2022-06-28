* Encoding: UTF-8.
 * Given to drink: CA3AB
 Given to eat: CA4
 Child was given 'Nothing' to eat: CA4 = 5 or 7

 * The denominator for this table is number of children with diarrhoea during the last two weeks: CA1=1

* v02. 2019-03-14: Denominator label has been changed.
* v03 - 2020-04-14. A new note has been inserted. Labels in French and Spanish have been removed.
*************************.

* Call include file for the working directory and the survey name.

include "surveyname.sps".

get file = 'ch.sav'.

select if (UF17 = 1).

weight by chweight.

* diarrhoea in last 2 weeks.
recode CA1 (1 = 100) (else = 0) into diarrhea.
variable labels diarrhea "Had diarrhoea in last two weeks".

do if (CA1 = 1).
+ compute dtotal = 1.
end if.
value labels dtotal 1 "Number of children with diarrhoea in the last two weeks".
variable labels dtotal "".

* CA3A categories.
* Much less		1
Somewhat less	2
About the same	3
More		4
Nothing to drink	5
DK		8.

recode CA3 (8,9 = 9) (else = copy).
variable labels CA3 "Drinking practices during diarrhoea:".
value labels CA3
  1 "Much less"
  2 "Somewhat less"
  3 "About the same"
  4 "More"
  5 "Nothing"
  9 "DK/Missing".

* CA4.
*Much less		1
Somewhat less	2
About the same	3
More		4
Stopped food	5
Never gave food	7
DK		8.

recode CA4 (5,7 = 5) (8,9 = 9) (else = copy).
variable labels CA4 "Eating practices during diarrhoea:".
value labels CA4
  1 "Much less"
  2 "Somewhat less"
  3 "About the same"
  4 "More"
  5 "Nothing"
  9 "DK/Missing".

compute tot = 1.
variable labels tot "".
value labels tot 1 "Total".

variable labels caretakerdis "Mother's functional difficulties [A]".

compute layer = 0.
variable labels layer "".
value labels layer 0 "Drinking practices during diarrhoea".
variable labels CA3 "Child was given to drink: ".
compute layer1 = 0.
variable labels layer1 "".
value labels layer1 0 "Eating practices during diarrhoea".
variable labels CA4 "Child was given to eat: ".

* Ctables command in English.
ctables
  /vlabels variables = tot dtotal layer layer1 
         display = none
  /table tot [c] 
         + HL4 [c] 
         + hh6 [c] 
         + hh7 [c] 
         + CAGE_11 [c] 
         + melevel [c]
         + caretakerdis [c]
         + ethnicity [c]
         + windex5 [c]    by  
  	layer [c] > (CA3 [c] [rowpct.validn '' f5.1] )+
                  layer1 [c] > (CA4 [c] [rowpct.validn '' f5.1]) + 
                  dtotal [c] [count '' f5.0]
  /categories variables=all empty=exclude missing=exclude
  /categories variables = CA3 CA4 total = yes position = after label = "Total"
  /slabels position=column visible = no
  /titles title=
	 "Table TC.3.2: Feeding practices during diarrhoea"
	  "Percent distribution of children age 0-59 months with diarrhoea in the last two weeks by amount of liquids and food given during episode of diarrhoea, " 
 	   + surveyname
   caption="[A] The disaggregate of Mother's functional difficulties is shown only for respondents to the Adult Functioning module, i.e. individually interviewed women age 18-49 years and men age 18-49 years in selected households."
.
	   
new file.
